# Spec: 批次 44 data protocols client mock 清理

## 背景

`awesome_mail_flutter/test/unit/data/protocols` 仍有 4 支低階 protocol client 測試依賴 `mocktail` shim。這些測試主要驗證 HTTP 方法、URL、header、SOAP/XML/JSON body 與錯誤處理，適合改成 hand-written HTTP recorder，而不是 mock framework。

## 目標

1. 將下列 4 支測試改成不依賴 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 或 `.mocks.dart`
   - `awesome_mail_flutter/test/unit/data/protocols/caldav/caldav_client_test.dart`
   - `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_client_test.dart`
   - `awesome_mail_flutter/test/unit/data/protocols/exchange/ews_client_test.dart`
   - `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_client_test.dart`
2. 以 hand-written fake / recorder 驅動 `http.Client` 行為，保留對請求內容與錯誤處理的驗證力
3. 通過 batch 44 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不擴大到 protocol handler 測試或 production client 實作
- 不修改 `awesome_mail_flutter/lib/data/protocols/*` 的對外行為

## 驗收條件

- `awesome_mail_flutter/test/unit/data/protocols` 不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`
- batch 44 相關測試全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
