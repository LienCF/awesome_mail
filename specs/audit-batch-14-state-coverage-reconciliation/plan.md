> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 14 state coverage 對齊與缺測修補

## 技術策略

1. 先確認這批 6 個 state / event 檔目前的真實 coverage 狀態，區分假陽性與實際缺口。
2. 以 `mailbox_chip_state_test.dart` 作為 red 起點，先證明缺少直接測試，再補上 state-level 單元測試。
3. 測試轉綠後，更新 `tdd-audit-report.md` 與 batch 14 `tasks.md`，把 5 個已覆蓋的假陽性移出清單，並下修 Flutter 缺測數。
4. 執行 targeted tests、`flutter analyze --fatal-infos`，最後再跑全量 `flutter test` 完成回歸驗證。

## 分組實作

### A. 狀態 coverage 對齊

- `awesome_mail_flutter/lib/presentation/blocs/account/account_state.dart`
- `awesome_mail_flutter/lib/presentation/blocs/automation/automation_event.dart`
- `awesome_mail_flutter/lib/presentation/blocs/automation/automation_state.dart`
- `awesome_mail_flutter/lib/presentation/blocs/ai/ai_status_state.dart`
- `awesome_mail_flutter/lib/presentation/blocs/settings/pgp_keys/pgp_keys_state.dart`
- `tdd-audit-report.md`

### B. MailboxChipState 直接測試

- `awesome_mail_flutter/lib/presentation/blocs/mailbox/mailbox_chip_state.dart`
- `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_chip_state_test.dart`

## 驗證策略

- `flutter test test/unit/presentation/blocs/mailbox/mailbox_chip_state_test.dart`
- `flutter test test/presentation/blocs/account/account_cubit_test.dart test/unit/presentation/blocs/automation/automation_event_state_test.dart test/unit/presentation/blocs/ai/ai_status_cubit_test.dart test/unit/presentation/blocs/settings/pgp_keys_cubit_test.dart test/unit/presentation/blocs/mailbox/mailbox_chip_cubit_test.dart test/unit/presentation/blocs/mailbox/mailbox_chip_state_test.dart`
- `flutter analyze --fatal-infos`
- `flutter test`
- 更新 `tdd-audit-report.md` 與 batch 14 `tasks.md`
