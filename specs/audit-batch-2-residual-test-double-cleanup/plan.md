> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 計劃：殘留測試替身語意清理

## 技術背景

- Flutter 原生批次修復後，全量 `flutter test` 已通過
- 複掃顯示殘留項目集中在 `awesome_mail_flutter/test`
- backend 與 Python 目前沒有新的功能性紅燈

## 實作策略

### Phase 1：收斂 Flutter 測試替身

- 將 `test/support/mocks/` 的 home page 支援替身搬到 `support/fakes`
- 將 `macos_home_page_ai_test.dart`、`test_app_shell.dart`、局部測試檔的 `Mock*` 命名改為 `Fake*` 或 `Test*`
- 刪除未使用的 `http_client_mocktail_shim.dart`

### Phase 2：更新測試文件

- 重寫 `test/README.md`
- 更新 `test/TEST_DOCUMENTATION.md`
- 更新 `test/TESTING_OVERVIEW.md`

### Phase 3：回歸驗證

- Flutter targeted tests
- `flutter analyze --fatal-infos`
- `flutter test`
- backend `npm run quality:check`
