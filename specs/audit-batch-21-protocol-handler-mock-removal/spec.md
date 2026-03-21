# Spec: 批次 21 protocol handler mock 清理

## 背景

重新審計後，Flutter 測試仍有大量 Detroit School mock-heavy 違規，其中最適合作為下一批的是 `test/unit/data/protocols` 下的 handler 測試。這一組共有 6 支檔案，其中：

- `carddav_handler_test.dart`
- `exchange_handler_test.dart`
- `jmap_handler_test.dart`
- `imap_handler_test.dart`
- `pop3_handler_test.dart`
- `smtp_handler_test.dart`

目前前 3 支直接依賴 `mockito` generated client mocks，後 3 支雖然幾乎沒有真正使用 mocked socket 行為，但仍保留 `@GenerateMocks([Socket, SecureSocket])` 與對應 `.mocks.dart` 依賴，讓審計結果持續判定為 mock-heavy。

## 問題陳述

這批測試目前有三個問題：

1. handler 測試以 framework-driven stubbing 為主，驗證重點綁在 `when` / `verify` 語法，而不是明確的呼叫紀錄與回傳資料。
2. `IMAP`、`POP3`、`SMTP` 測試保留未使用的 generated mocks，增加維護成本，也造成審計誤判為仍有 mock 濫用。
3. 若不先清掉 protocol handler 這一層，後續 `data/services`、`core/services` 與 `presentation` 批次就無法建立一致的手寫 fake 模式。

## 使用者故事

### US1: protocol handler 測試改用手寫測試替身

作為維護者，我們希望 CardDAV、Exchange、JMAP handler 測試改用手寫 fake client，讓測試以明確的輸入、輸出與呼叫紀錄驗證 handler 行為，而不是依賴 generated mocks。

#### 驗收條件

1. `carddav_handler_test.dart`、`exchange_handler_test.dart`、`jmap_handler_test.dart` 不再 import `mockito` 或對應 `.mocks.dart`。
2. 這 3 支測試仍保留連線、驗證、資料取得、錯誤處理與 forwarding 驗證。
3. 測試改以手寫 fake 的呼叫紀錄驗證 handler 是否正確傳遞參數。

### US2: 移除未使用的 socket generated mocks

作為維護者，我們希望 IMAP、POP3、SMTP handler 測試刪除未使用的 generated mocks，讓測試只留下真正有驗證價值的內容，並從審計結果中移除這類虛假的 mock-heavy 命中。

#### 驗收條件

1. `imap_handler_test.dart`、`pop3_handler_test.dart`、`smtp_handler_test.dart` 不再 import `mockito`、不再使用 `@GenerateMocks`，也不再依賴 `imap_handler_test.mocks.dart`。
2. 測試行為不變，既有 guard 與錯誤處理案例仍能通過。
3. 這批對應 `.mocks.dart` 檔案已刪除。

## 非目標

- 不在這一批重寫 protocol client 本身的 HTTP 測試。
- 不擴大修改 production handler API。
- 不處理 protocol 以外的 provider / service / bloc 測試。

## 成功指標

- 6 支 protocol handler 測試全部通過。
- `flutter analyze --fatal-infos` 通過。
- 搜尋 `test/unit/data/protocols/*handler*` 不再找到 `mockito`、`@GenerateMocks` 或對應 `.mocks.dart` 依賴。
