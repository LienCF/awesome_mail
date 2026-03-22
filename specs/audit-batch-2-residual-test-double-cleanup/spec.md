# 規格：殘留測試替身語意清理

## 背景

原生平台批次完成後，複掃顯示 Flutter 測試層仍殘留一小批以 `Mock*` 命名的手寫測試替身、未使用的自製 mock shim，以及過時的測試文件。這些內容和目前專案採用的 Detroit School fake-first 測試策略不一致。

## 目標

1. 移除未使用的自製 mock shim
2. 將 Flutter 測試支援鏈中的手寫 `Mock*` 替身改為 `Fake*` 或 `Test*`
3. 更新 Flutter 測試文件，移除 `mockito` 與 mock-first 指引

## 使用情境與驗證

### US1：Home page 測試使用可讀的 fake/test double

作為維護 Flutter widget 測試的開發者，我們需要 home page 測試與 test shell 使用明確的 fake/test double，而不是 `support/mocks` 與 `Mock*` 類別，這樣測試意圖才會和現行規範一致。

驗證方式：

- `test/support/mocks/` 不再被 Flutter 測試引用
- `macos_home_page_ai_test.dart` 與 `test_app_shell.dart` 不再引用 `Mock*` 支援類別

### US2：Flutter 測試文件反映現行策略

作為團隊成員，我們需要 repo 內測試文件描述目前真實使用的 fake-first 測試方式，避免新測試又回到 `mockito` 或自製 mock DSL。

驗證方式：

- `test/README.md`、`test/TEST_DOCUMENTATION.md`、`test/TESTING_OVERVIEW.md` 不再提及 `mockito` 或 mock-first 範例
- Flutter 測試目錄內不再存在未使用的 `http_client_mocktail_shim.dart`

## 成功標準

- `rg -n "mockito|mocktail" awesome_mail_flutter/test awesome_mail_flutter/integration_test` 無結果
- `rg -n "^class Mock[A-Z]" awesome_mail_flutter/test` 只剩 Flutter/平台 API 固有命名，不再有手寫測試替身
- 相關 Flutter 測試、`flutter analyze --fatal-infos`、backend `npm run quality:check` 皆通過
