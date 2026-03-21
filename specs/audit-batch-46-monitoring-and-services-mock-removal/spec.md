# Spec: 批次 46 monitoring 與 presentation services mock 清理

## 背景

`awesome_mail_flutter/test/unit/core/monitoring` 與 `awesome_mail_flutter/test/unit/presentation/services` 目前還有 3 支測試與 1 個 generated mock 依賴 `mockito` 或 `mocktail`。其中 `network_monitor_test.dart` 主要驗證 `Connectivity` 事件流與網路請求統計，適合改成 hand-written connectivity fake；`service_factory_test.dart` 與 `bloc_ai_settings_service_test.dart` 只需要驗證取回已註冊服務與讀取設定狀態，不需要 mock framework。

## 目標

1. 將下列 3 支測試改成不依賴 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 或 generated `.mocks.dart`
   - `awesome_mail_flutter/test/unit/core/monitoring/network_monitor_test.dart`
   - `awesome_mail_flutter/test/unit/presentation/services/service_factory_test.dart`
   - `awesome_mail_flutter/test/unit/presentation/services/bloc_ai_settings_service_test.dart`
2. 以 hand-written fake / stub 取代 `Connectivity` 與 `SettingsBloc` 的 mock framework 依賴
3. 將 `service_factory_test.dart` 強化為驗證 getter 會回傳已註冊的實例，而不只是型別
4. 刪除 `awesome_mail_flutter/test/unit/core/monitoring/network_monitor_test.mocks.dart`
5. 通過 batch 46 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不擴大到 `test/unit/core/monitoring` 其他已非 mock-heavy 的測試
- 不改動 `NetworkMonitor`、`ServiceFactory`、`BlocAISettingsService` 的對外行為，除非改寫過程揭露真實缺陷
- 不進入 backend mock-heavy 測試

## 驗收條件

- `awesome_mail_flutter/test/unit/core/monitoring` 與 `awesome_mail_flutter/test/unit/presentation/services` 不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`
- batch 46 相關測試全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
