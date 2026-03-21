# Spec: 批次 34 integration mock 清理

## 背景

batch 33 已清空 `awesome_mail_flutter/test/unit/data/services` 的 mock-heavy 測試。重新掃描後，Flutter 下一個剩餘群組是 `awesome_mail_flutter/test/integration`，目前命中的主測試檔有 `4` 支：

- `full_sync_flow_test.dart`
- `oauth_migration_integration_test.dart`
- `offline_mode_test.dart`
- `subscription_flow_integration_test.dart`

另外同目錄還有 `2` 個 generated `.mocks.dart`：

- `oauth_migration_integration_test.mocks.dart`
- `subscription_flow_integration_test.mocks.dart`

## 問題陳述

這批 integration 測試目前有四個主要問題：

1. `subscription_flow_integration_test.dart` 與 `oauth_migration_integration_test.dart` 驗證的是 widget flow、state 與狀態持久化，卻仍依賴 `mockito` 與 generated `.mocks.dart`。
2. `offline_mode_test.dart` 目前用 `mocktail` 撐起 `OfflineQueueServiceImpl` 的依賴，而且測試檔內已明確留下建構不完整的註解，表示測試本身已偏離 production wiring。
3. `full_sync_flow_test.dart` 直接引用 unit test 產生的 `email_synchronizer_test.mocks.dart`，造成 integration 測試跨目錄耦合，也把 `SyncStateManager` / Gmail 邊界的真實流程驗證拆成框架式 `verify(...)`。
4. `test/integration` 是 Flutter 剩餘 mock-heavy 群組之一，不先清掉會拖住後續 `presentation/blocs` 與 backend 收尾。

## 使用者故事

### US1: subscription 與 oauth integration flow 改用手寫 fake

作為維護者，我們希望 subscription 與 oauth integration 測試改用可重用的 hand-written fake / recorder，直接驗證 flow、狀態更新與持久化副作用。

#### 驗收條件

1. `subscription_flow_integration_test.dart`、`oauth_migration_integration_test.dart` 不再依賴 `mockito`、`@GenerateMocks` 或 local `.mocks.dart`。
2. 測試直接驗證 fake service / storage 的狀態與 call record，而不是框架式 `verify(...).called(...)`。
3. 可重用的 fake 優先延伸既有 `test/support/fakes/`，避免再新增重複替身。

### US2: offline queue 與 full sync integration 測試改用 in-memory fake

作為維護者，我們希望 `offline_mode_test.dart` 與 `full_sync_flow_test.dart` 改用最小可控的 hand-written fake / recorder，保留 queue、sync state 與 repository 邊界的真實行為驗證。

#### 驗收條件

1. `offline_mode_test.dart` 改用手寫 fake `EmailCacheService`、`EmailSyncService`、`AccountRepository` 等最小依賴，不再使用 `mocktail`。
2. `full_sync_flow_test.dart` 改用 hand-written `SyncStateManager` recorder 與既有 service/repository fake，移除對 unit generated mock 的依賴。
3. 測試改為驗證 queue persisted state、sync call record、historyId / pageToken 更新結果，而不是只驗證 `verify(...)`。

### US3: batch 34 mock framework 依賴清空

作為維護者，我們希望 batch 34 範圍內的 integration 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。

#### 驗收條件

1. batch 34 的 4 支 integration 測試與支援 fake 檔已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart` 依賴。
2. `oauth_migration_integration_test.mocks.dart` 與 `subscription_flow_integration_test.mocks.dart` 完全移除，且整個 codebase 無引用殘留。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 `FeatureGate`、`OAuthOnboardingWidget`、`OAuthMigrationWidget`、`OfflineQueueServiceImpl`、`EmailSynchronizer` 的 production 公開 API。
- 不在本批次處理 `test/unit/presentation/blocs` 或 backend mock-heavy 測試。
- 不重寫 production sync / OAuth 流程，只補足 integration 測試替身與驗證方式。

## 成功指標

- 這 `4` 支 `test/integration` 測試全部改由 hand-written fake / in-memory 依賴驅動。
- `test/integration` 這一群在本批次完成後降為 `0`。
- batch 34 targeted tests、`flutter analyze --fatal-infos` 與 Flutter 全量回歸通過。
