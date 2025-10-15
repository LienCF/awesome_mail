# 增量同步與健康監控實作計劃

> **專案:** Awesome Mail Flutter
> **功能:** 增量 API 同步 + 同步健康監控
> **目標:** 支援無限捲動載入郵件 & 確保本地與 Server 狀態一致
> **預估時間:** 13-19 工作天
> **建立日期:** 2025-10-11

---

## 一、問題定義

### 1.1 現有問題
1. **同步限制:** `GmailRepository.syncFolderToDatabase` 在 200 封郵件後停止 (hardcoded)
2. **分頁不完整:** 載入更多 (`reset=false`) 只從資料庫讀取,不觸發 API 同步
3. **狀態追蹤缺失:** `pageToken` 未針對各資料夾追蹤
4. **缺乏一致性保證:** 無機制確保本地與 Server 狀態同步

### 1.2 問題流程
```
使用者選擇資料夾 (如 Trash)
  ↓
初次載入 (reset=true)
  ↓
背景同步從 Gmail API 抓取郵件
  ↓
在 200 封時停止 (maxEmailsPerSync = 200)
  ↓
使用者捲動到底部
  ↓
載入更多 (reset=false) → 只從資料庫載入
  ↓
資料庫只有 200 封,載入 4 頁後 folderHasMore = false
  ↓
無法繼續載入
```

---

## 二、解決方案架構

### 2.1 核心概念
**Database-First + API On-Demand 混合模式 + 健康監控**

```
初次載入:
  1. 從資料庫快速載入 (快速響應)
  2. 背景觸發 API 同步 (200 封限制)
  3. 更新 SyncMetadata

載入更多:
  1. 從資料庫載入下一頁
  2. 如果資料庫沒有 + API 有 pageToken:
     → 觸發增量 API 同步
  3. 更新 SyncMetadata

週期性健康檢查 (每 5 分鐘):
  1. 比對本地 vs Server 郵件數量
  2. 偵測 drift (偏差)
  3. 自動修復:
     - Drift < 5%: 無動作
     - 5-20%: 增量同步
     - > 20%: 完整重新同步
```

---

## 三、詳細技術設計

### 3.1 Phase 1-2: 狀態管理擴展

#### MailboxState 新增欄位
```dart
class MailboxState extends Equatable {
  // 現有欄位...

  // 新增: 每個資料夾的 API pageToken
  final Map<String, String?> folderApiPageTokens;

  // 新增: 每個資料夾的 API 同步狀態
  final Map<String, bool> folderHasMoreFromApi;

  // 新增: 追蹤資料夾的總同步數量
  final Map<String, int> folderTotalSynced;

  const MailboxState({
    // ...
    this.folderApiPageTokens = const {},
    this.folderHasMoreFromApi = const {},
    this.folderTotalSynced = const {},
  });
}
```

#### SyncResult 類別
```dart
class SyncResult {
  const SyncResult({
    required this.syncedCount,
    this.nextPageToken,
    required this.hasMore,
  });

  final int syncedCount;           // 本次同步的郵件數量
  final String? nextPageToken;     // 下次同步的起點
  final bool hasMore;              // 是否還有更多郵件
}
```

#### GmailRepository 修改
```dart
/// 選項 A: 保留限制但支援續傳 (建議)
Future<SyncResult> syncFolderToDatabase(
  String accountId,
  String accountEmail,
  String labelId, {
  String? continueFromToken,       // 新增: 從指定 token 繼續
  int maxEmailsThisSync = 200,     // 保留單次限制
}) async {
  String? pageToken = continueFromToken;
  var totalSynced = 0;

  do {
    final page = await _gmailRemoteService.fetchMessagesByLabel(
      accountId,
      accountEmail,
      labelId,
      pageToken: pageToken,
    );

    // 儲存郵件到資料庫
    for (final email in page.emails) {
      await _emailRepository.saveEmail(email);
    }

    totalSynced += page.emails.length;
    pageToken = page.nextPageToken;

    // 達到單次限制時停止,但返回 pageToken
    if (totalSynced >= maxEmailsThisSync) {
      logInfo('[SyncFolder] Reached sync limit ($maxEmailsThisSync), stopping');
      return SyncResult(
        syncedCount: totalSynced,
        nextPageToken: pageToken,
        hasMore: pageToken != null,
      );
    }
  } while (pageToken != null);

  return SyncResult(
    syncedCount: totalSynced,
    nextPageToken: null,
    hasMore: false,
  );
}
```

---

### 3.2 Phase 3-4: 同步健康監控基礎設施

#### SyncMetadata 資料表 Schema
```sql
CREATE TABLE IF NOT EXISTS sync_metadata (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  account_id TEXT NOT NULL,
  folder_name TEXT NOT NULL,
  last_sync_time INTEGER NOT NULL,      -- Unix timestamp
  last_history_id TEXT,                  -- Gmail historyId
  local_email_count INTEGER DEFAULT 0,
  server_email_count INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'unknown',    -- healthy/drift/error/unknown
  drift_percentage REAL DEFAULT 0.0,
  last_check_time INTEGER,
  consecutive_failures INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  UNIQUE(account_id, folder_name)
);

CREATE INDEX idx_sync_metadata_account ON sync_metadata(account_id);
CREATE INDEX idx_sync_metadata_status ON sync_metadata(sync_status);
```

#### SyncHealthChecker 介面
```dart
abstract class SyncHealthChecker {
  /// 檢查特定資料夾的同步健康狀態
  Future<SyncHealthReport> checkFolderHealth({
    required String accountId,
    required String folderName,
  });

  /// 檢查所有資料夾的健康狀態
  Future<Map<String, SyncHealthReport>> checkAllFolders({
    required String accountId,
  });

  /// 開始週期性健康檢查
  void startPeriodicCheck({
    required String accountId,
    Duration interval = const Duration(minutes: 5),
  });

  void stopPeriodicCheck();
}

class SyncHealthReport {
  const SyncHealthReport({
    required this.folderName,
    required this.status,
    required this.localCount,
    required this.serverCount,
    required this.checkedAt,
    this.historyId,
    this.historyExpired = false,
  });

  final String folderName;
  final SyncStatus status;
  final int localCount;
  final int serverCount;
  final DateTime checkedAt;
  final String? historyId;
  final bool historyExpired;

  int get drift => (serverCount - localCount).abs();
  double get driftPercentage => serverCount > 0 ? drift / serverCount : 0.0;

  SyncAction get recommendedAction {
    if (status == SyncStatus.healthy) return SyncAction.none;
    if (historyExpired || driftPercentage > 0.3) {
      return SyncAction.fullResync;
    }
    return SyncAction.incrementalSync;
  }
}

enum SyncStatus {
  healthy,   // < 5% drift
  drift,     // 5-20% drift
  error,     // > 20% drift
  unknown    // 無法判定
}

enum SyncAction {
  none,              // 健康,無需動作
  incrementalSync,   // 增量同步修復
  fullResync         // 完整重新同步
}
```

---

### 3.3 Phase 5-6: MailboxBloc 整合邏輯

#### _shouldTriggerApiSync 判斷邏輯
```dart
bool _shouldTriggerApiSync({
  required String folderName,
  required bool dbHasMore,
  required bool isReset,
}) {
  // 初次載入: 一定觸發
  if (isReset) return true;

  // 載入更多: 資料庫沒有更多 + API 還有 pageToken
  if (!dbHasMore) {
    final apiHasMore = state.folderHasMoreFromApi[folderName] ?? true;
    return apiHasMore;
  }

  return false;
}
```

#### _triggerApiSync 實作
```dart
Future<void> _triggerApiSync(
  String accountId,
  String accountEmail,
  String labelId,
  String folderName,
) async {
  try {
    // 取得目前的 pageToken
    final currentToken = state.folderApiPageTokens[folderName];

    // 執行增量同步
    final result = await _gmailRepository.syncFolderToDatabase(
      accountId,
      accountEmail,
      labelId,
      continueFromToken: currentToken,
    );

    logInfo('[ApiSync] Synced ${result.syncedCount} emails, nextToken=${result.nextPageToken}');

    // 更新 API 同步狀態
    final newApiPageTokens = Map<String, String?>.from(state.folderApiPageTokens);
    newApiPageTokens[folderName] = result.nextPageToken;

    final newHasMoreFromApi = Map<String, bool>.from(state.folderHasMoreFromApi);
    newHasMoreFromApi[folderName] = result.hasMore;

    final newTotalSynced = Map<String, int>.from(state.folderTotalSynced);
    newTotalSynced[folderName] = (newTotalSynced[folderName] ?? 0) + result.syncedCount;

    emit(state.copyWith(
      folderApiPageTokens: newApiPageTokens,
      folderHasMoreFromApi: newHasMoreFromApi,
      folderTotalSynced: newTotalSynced,
    ));

    // 重新從資料庫載入 (顯示新同步的郵件)
    add(MailboxLoadByLabel(
      labelId: labelId,
      labelName: folderName,
      reset: false,  // 不重置,繼續分頁
    ));

  } catch (e, st) {
    _logger.error('[ApiSync] Failed: $e', e, st);
  }
}
```

#### _onLoadByLabel 修改
```dart
Future<void> _onLoadByLabel(
  MailboxLoadByLabel event,
  Emitter<MailboxState> emit,
) async {
  // 去重機制...
  // 權限檢查...

  try {
    // 1. 從資料庫載入 (快速回饋)
    final offset = event.reset ? 0 : (state.folderOffsets[folderName] ?? 0);
    final emails = await _emailRepository.getEmailsByFolder(
      accountId,
      folderId,
      limit: 50,
      offset: offset,
    );

    // 2. 更新狀態
    final folderEmails = Map<String, List<Email>>.from(state.folderEmails);
    if (event.reset) {
      folderEmails[folderName] = emails;
    } else {
      folderEmails[folderName] = [...(state.folderEmails[folderName] ?? []), ...emails];
    }

    final folderOffsets = Map<String, int>.from(state.folderOffsets);
    folderOffsets[folderName] = offset + emails.length;

    final folderHasMore = Map<String, bool>.from(state.folderHasMore);
    folderHasMore[folderName] = emails.length >= 50;

    emit(state.copyWith(
      folderEmails: folderEmails,
      folderOffsets: folderOffsets,
      folderHasMore: folderHasMore,
      folderLoadingStates: {...state.folderLoadingStates, folderName: false},
    ));

    // 3. 判斷是否需要 API 同步
    final needsApiSync = _shouldTriggerApiSync(
      folderName: folderName,
      dbHasMore: emails.length >= 50,
      isReset: event.reset,
    );

    if (needsApiSync) {
      unawaited(_triggerApiSync(accountId, account.email, event.labelId, folderName));
    }

  } catch (e, st) {
    _logger.error('載入標籤郵件失敗 ($folderName)', e, st);
  }
}
```

---

### 3.4 Phase 6: History API 增量同步強化

#### 智慧降級機制
```dart
class EnhancedHistorySync {
  /// 智慧增量同步:自動處理 history 過期
  Future<HistorySyncResult> smartIncrementalSync({
    required String accountId,
    required String folderName,
    String? lastHistoryId,
  }) async {
    if (lastHistoryId == null) {
      // 無 historyId,執行完整同步
      return await _performFullSync(accountId, folderName);
    }

    try {
      // 1. 嘗試使用 History API
      final result = await _gmailService.fetchHistory(
        accountEmail,
        lastHistoryId,
      );

      if (result.historyExpired) {
        // 2. History 過期,自動降級為完整同步
        _logger.warning('[HistorySync] History expired, fallback to full sync');
        return await _performFullSync(accountId, folderName);
      }

      // 3. 正常增量更新
      _logger.info('[HistorySync] Updated ${result.changedMessageIds.length} messages');
      return HistorySyncResult(
        type: SyncType.incremental,
        updatedEmails: result.changedMessageIds.length,
        newHistoryId: result.newHistoryId,
      );

    } catch (e) {
      // 4. 錯誤處理:降級為完整同步
      _logger.error('[HistorySync] Error, fallback to full sync: $e');
      return await _performFullSync(accountId, folderName);
    }
  }

  Future<HistorySyncResult> _performFullSync(
    String accountId,
    String folderName,
  ) async {
    // 清空並重新同步
    await _emailRepository.deleteAllEmailsInFolder(accountId, folderName);

    final result = await _gmailRepository.syncFolderToDatabase(
      accountId,
      accountEmail,
      _folderNameToLabelId(folderName),
    );

    return HistorySyncResult(
      type: SyncType.full,
      updatedEmails: result.syncedCount,
      newHistoryId: null, // 需要從 profile API 取得
    );
  }
}
```

---

### 3.5 Phase 7-8: 自動修復系統

#### SyncReconciliationService
```dart
class SyncReconciliationService {
  Future<void> autoRepair(
    String accountId,
    String folderName,
    SyncHealthReport report,
  ) async {
    final action = report.recommendedAction;

    _logger.info('[AutoRepair] $folderName requires: $action');

    switch (action) {
      case SyncAction.incrementalSync:
        await _performIncrementalRepair(accountId, folderName, report);
        break;

      case SyncAction.fullResync:
        await _performFullResync(accountId, folderName);
        break;

      case SyncAction.none:
        break;
    }
  }

  Future<void> _performIncrementalRepair(
    String accountId,
    String folderName,
    SyncHealthReport report,
  ) async {
    _logger.info('[IncrementalRepair] Starting for $folderName');

    final result = await _emailSyncService.performIncrementalSync(
      account: account,
      historyId: report.historyId!,
    );

    for (final email in result.updatedEmails) {
      await _emailRepository.saveEmail(email);
    }

    await _updateSyncMetadata(accountId, folderName, result.newHistoryId);

    _logger.info('[IncrementalRepair] Completed: ${result.updatedEmails.length} emails updated');
  }

  Future<void> _performFullResync(
    String accountId,
    String folderName,
  ) async {
    _logger.warning('[FullResync] Starting for $folderName');

    await _emailRepository.deleteAllEmailsInFolder(accountId, folderName);

    await _gmailRepository.syncFolderToDatabase(
      accountId,
      accountEmail,
      _folderNameToLabelId(folderName),
    );

    final profile = await _gmailService.getProfile(accountEmail);
    await _updateSyncMetadata(accountId, folderName, profile?.historyId);

    _logger.info('[FullResync] Completed for $folderName');
  }
}
```

#### 週期性健康檢查
```dart
class PeriodicSyncHealthChecker {
  Timer? _timer;
  final SyncHealthChecker _checker;
  final SyncReconciliationService _reconciliation;

  void startPeriodicCheck({
    required String accountId,
    Duration interval = const Duration(minutes: 5),
  }) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) async {
      await _performHealthCheck(accountId);
    });
  }

  Future<void> _performHealthCheck(String accountId) async {
    _logger.info('[HealthCheck] Starting periodic check');

    final folders = ['Inbox', 'Sent', 'Drafts', 'Trash', 'Spam'];

    for (final folder in folders) {
      try {
        final report = await _checker.checkFolderHealth(
          accountId: accountId,
          folderName: folder,
        );

        await _metadataRepo.updateFromReport(report);

        if (report.status == SyncStatus.drift ||
            report.status == SyncStatus.error) {
          _logger.warning(
            '[HealthCheck] Detected drift in $folder: '
            'local=${report.localCount}, server=${report.serverCount}, '
            'drift=${report.driftPercentage * 100}%'
          );

          await _reconciliation.autoRepair(accountId, folder, report);
        }

      } catch (e) {
        _logger.error('[HealthCheck] Failed for $folder: $e');
      }
    }
  }

  void stopPeriodicCheck() {
    _timer?.cancel();
    _timer = null;
  }
}
```

---

### 3.6 Phase 9: UI 整合

#### _calculateHasMore 方法
```dart
bool _calculateHasMore(MailboxState state, String folderName) {
  // 資料庫還有更多: 可以繼續載入
  final dbHasMore = state.folderHasMore[folderName] ?? true;
  if (dbHasMore) return true;

  // 資料庫沒有了,但 API 還有: 可以觸發 API 同步
  final apiHasMore = state.folderHasMoreFromApi[folderName] ?? true;
  return apiHasMore;
}
```

#### SyncStatusIndicator Widget
```dart
class SyncStatusIndicator extends StatelessWidget {
  final SyncHealthReport? report;

  @override
  Widget build(BuildContext context) {
    if (report == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(report!.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(report!.status),
            size: 14,
            color: _getStatusColor(report!.status),
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(report!.status),
            style: TextStyle(
              fontSize: 12,
              color: _getStatusColor(report!.status),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.healthy: return Colors.green;
      case SyncStatus.drift: return Colors.orange;
      case SyncStatus.error: return Colors.red;
      case SyncStatus.unknown: return Colors.grey;
    }
  }

  IconData _getStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.healthy: return Icons.check_circle;
      case SyncStatus.drift: return Icons.warning;
      case SyncStatus.error: return Icons.error;
      case SyncStatus.unknown: return Icons.help;
    }
  }

  String _getStatusText(SyncStatus status) {
    switch (status) {
      case SyncStatus.healthy: return '已同步';
      case SyncStatus.drift: return '正在同步...';
      case SyncStatus.error: return '同步失敗';
      case SyncStatus.unknown: return '未知';
    }
  }
}
```

---

## 四、關鍵檔案位置

### 需要修改的檔案
1. `lib/presentation/blocs/mailbox/mailbox_state.dart` - 新增 3 個欄位
2. `lib/presentation/blocs/mailbox/mailbox_bloc.dart` - 新增同步邏輯
3. `lib/data/repositories/gmail_repository.dart` - 修改 syncFolderToDatabase
4. `lib/presentation/pages/home/enhanced_macos_home_page.dart` - UI 整合

### 需要建立的檔案
1. `lib/data/models/sync_result.dart` - SyncResult 類別
2. `lib/data/repositories/sync_metadata_repository.dart` - 持久化
3. `lib/data/services/sync_health_checker.dart` - 健康檢查
4. `lib/data/services/sync_reconciliation_service.dart` - 自動修復
5. `lib/data/services/periodic_sync_health_checker.dart` - 週期檢查
6. `lib/presentation/widgets/sync/sync_status_indicator.dart` - UI 指示器

### 測試檔案
1. `test/presentation/blocs/mailbox/mailbox_bloc_test.dart` - Bloc 測試
2. `test/data/repositories/gmail_repository_test.dart` - Repository 測試
3. `test/data/services/sync_health_checker_test.dart` - 健康檢查測試
4. `test/integration/sync_consistency_test.dart` - 整合測試

---

## 五、測試策略

### 5.1 單元測試
```dart
group('MailboxBloc - Incremental API Sync', () {
  test('should trigger API sync when DB is empty on load more', () async {
    when(() => emailRepository.getEmailsByFolder(...))
      .thenAnswer((_) async => []);
    when(() => gmailRepository.syncFolderToDatabase(...))
      .thenAnswer((_) async => SyncResult(
        syncedCount: 50,
        nextPageToken: 'token_page2',
        hasMore: true,
      ));

    bloc.add(MailboxLoadByLabel(
      labelId: 'TRASH',
      labelName: 'Trash',
      reset: false,
    ));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<MailboxState>((s) => s.folderApiPageTokens['Trash'] == 'token_page2'),
      ]),
    );
  });
});

group('SyncHealthChecker', () {
  test('should detect count drift', () async {
    when(() => gmailService.fetchLabels(any()))
      .thenAnswer((_) async => [Folder(id: 'INBOX', totalCount: 250)]);
    when(() => emailRepository.getEmailCountByFolder(any(), 'inbox'))
      .thenAnswer((_) async => 200);

    final report = await checker.checkFolderHealth(
      accountId: 'test',
      folderName: 'Inbox',
    );

    expect(report.status, SyncStatus.drift);
    expect(report.drift, 50);
    expect(report.driftPercentage, 0.2);
    expect(report.recommendedAction, SyncAction.incrementalSync);
  });
});
```

### 5.2 整合測試
```dart
testWidgets('should load emails beyond 200 by scrolling', (tester) async {
  // 1. 載入 Trash 資料夾
  await tester.pumpWidget(app);
  await tester.tap(find.text('Trash'));
  await tester.pumpAndSettle();

  // 2. 驗證初次載入 200 封
  expect(find.byType(EmailListItem), findsNWidgets(50));

  // 3. 捲動到底部 4 次 (200 封)
  for (var i = 0; i < 4; i++) {
    await tester.drag(find.byType(ListView), Offset(0, -5000));
    await tester.pumpAndSettle();
  }

  // 4. 繼續捲動 (應觸發 API 同步)
  await tester.drag(find.byType(ListView), Offset(0, -5000));
  await tester.pumpAndSettle(Duration(seconds: 3));

  // 5. 驗證可以看到第 201+ 封郵件
  final emailCount = tester.widgetList(find.byType(EmailListItem)).length;
  expect(emailCount, greaterThan(200));
});
```

---

## 六、效能指標

### 6.1 目標
- ✅ 單次同步時間 < 5 秒 (200 封)
- ✅ UI 幀率維持 60 FPS
- ✅ 記憶體使用增長 < 50MB (載入 1000 封)
- ✅ 健康檢查執行時間 < 2 秒

### 6.2 監控指標
```dart
class SyncMetrics {
  int totalFolders;
  int healthyFolders;
  int driftFolders;
  int errorFolders;

  double get healthScore => healthyFolders / totalFolders;

  // 同步統計
  int totalSyncs = 0;
  int incrementalSyncs = 0;
  int fullResyncs = 0;
  Duration averageSyncTime = Duration.zero;

  // 修復統計
  int autoRepairs = 0;
  int successfulRepairs = 0;
}
```

---

## 七、風險與緩解

| 風險 | 影響 | 緩解措施 |
|------|------|----------|
| API 限流 | 高 | 單次限制 200 封 + debounce 500ms |
| 記憶體溢出 | 中 | 虛擬列表 + 郵件淘汰機制 |
| Race condition | 中 | Bloc 單向流 + 去重機制 |
| History 過期 | 中 | 自動降級為完整同步 |
| 資料庫效能 | 低 | 索引優化 + 批次操作 |
| UI 卡頓 | 中 | 背景執行 + 進度回饋 |

---

## 八、驗收標準

### 功能性
- ✅ 支援無限捲動載入郵件 (經測試可載入 500+ 封)
- ✅ 本地與 Server 自動保持一致 (drift < 5%)
- ✅ 自動偵測並修復不一致 (< 10 分鐘內修復)
- ✅ 離線/重連場景正常運作

### 效能性
- ✅ 同步 200 封郵件 < 5 秒
- ✅ UI 操作流暢 (60 FPS)
- ✅ 記憶體使用穩定

### 可靠性
- ✅ 測試覆蓋率 ≥ 90%
- ✅ 所有測試通過
- ✅ 無 critical bugs

### 可維護性
- ✅ 清晰的架構分層
- ✅ 完整的文檔
- ✅ 可觀測的日誌

---

## 九、實作 Checklist

### Phase 1-2: 狀態管理 (2-3 天)
- [ ] Phase 1.1: MailboxState 測試
- [ ] Phase 1.2: MailboxState 實作
- [ ] Phase 2.1: SyncResult 類別
- [ ] Phase 2.2: GmailRepository 修改
- [ ] Phase 2.3: 向後相容性驗證

### Phase 3-4: 健康監控 (2-3 天)
- [ ] Phase 3.1: SyncMetadata Schema
- [ ] Phase 3.2: SyncMetadataRepository
- [ ] Phase 3.3: 持久化測試
- [ ] Phase 4.1: SyncHealthChecker 介面
- [ ] Phase 4.2: checkFolderHealth 實作
- [ ] Phase 4.3: 健康檢查測試

### Phase 5-6: 同步邏輯 (3-4 天)
- [ ] Phase 5.1: _shouldTriggerApiSync
- [ ] Phase 5.2: _triggerApiSync
- [ ] Phase 5.3: 整合到 _onLoadByLabel
- [ ] Phase 6.1: History API 強化
- [ ] Phase 6.2: 降級機制
- [ ] Phase 6.3: 增量同步測試

### Phase 7-8: 自動修復 (2-3 天)
- [ ] Phase 7.1: 不一致偵測
- [ ] Phase 7.2: 自動修復機制
- [ ] Phase 7.3: 修復測試
- [ ] Phase 8.1: 週期性檢查
- [ ] Phase 8.2: 生命週期整合
- [ ] Phase 8.3: 防重複機制

### Phase 9-10: UI & 監控 (1-2 天)
- [ ] Phase 9.1: _calculateHasMore
- [ ] Phase 9.2: EmailListWidget 更新
- [ ] Phase 9.3: SyncStatusIndicator
- [ ] Phase 9.4: UI 整合
- [ ] Phase 10.1: 日誌記錄
- [ ] Phase 10.2: 效能指標

### Phase 11-13: 測試 (2-3 天)
- [ ] Phase 11.1: E2E - 載入 200+ 封
- [ ] Phase 11.2: E2E - 同步一致性
- [ ] Phase 11.3: Widget 測試
- [ ] Phase 12.1: 完整測試套件
- [ ] Phase 12.2: 效能測試
- [ ] Phase 13.1: 手動 - 郵件載入
- [ ] Phase 13.2: 手動 - 健康修復
- [ ] Phase 13.3: 手動 - 離線場景

### Phase 14-15: 交付 (1 天)
- [ ] Phase 14: 程式碼重構
- [ ] Phase 15: Git commit

---

## 十、參考資料

### Gmail API 文檔
- History API: https://developers.google.com/gmail/api/guides/sync
- Messages API: https://developers.google.com/gmail/api/reference/rest/v1/users.messages

### 相關 Issue
- 無法載入超過 200 封郵件
- 本地與 Server 狀態不一致

### 設計決策
- 選擇 Database-First 的原因: 快速 UI 響應
- 選擇 200 封限制的原因: 避免 API 超時
- 選擇 5 分鐘健康檢查的原因: 平衡即時性與資源消耗

---

**最後更新:** 2025-10-11
**狀態:** 規劃完成,準備開始實作
