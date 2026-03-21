> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 21 protocol handler mock 清理

## 技術策略

1. 先把 `CardDAVHandler`、`ExchangeHandler`、`JMAPHandler` 測試切換到手寫 fake client，讓測試在不依賴 mock framework 的情況下仍能驗證 forwarding 與錯誤傳遞。
2. 手寫 fake 以「可配置回傳值 / 例外」加上「呼叫紀錄」為核心，避免引入新的測試 DSL。
3. `IMAP`、`POP3`、`SMTP` 測試只移除未使用的 socket mocks 與 generated 檔案，保留原本的 guard / 行為驗證。
4. 完成後刪除對應 `.mocks.dart`，執行 targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與必要的全量測試。

## 分組實作

### A. 手寫 fake client 取代 generated mocks

- `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_handler_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/exchange/exchange_handler_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_handler_test.dart`

### B. 清除未使用 socket mocks

- `awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.dart`

### C. 刪除 generated 檔案

- `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_handler_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/protocols/exchange/exchange_handler_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_handler_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.mocks.dart`
- `awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.mocks.dart`

## 驗證策略

- `flutter test` 執行這 6 支 protocol handler 測試
- `flutter analyze --fatal-infos`
- `rg` 驗證這批檔案中已無 `mockito`、`@GenerateMocks`、`.mocks.dart`
- 視 batch 結果決定是否追加全量 `flutter test`
