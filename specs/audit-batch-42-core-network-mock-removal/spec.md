# Spec: 批次 42 core network mock 清理

## 背景

`awesome_mail_flutter/test/unit/core/network` 仍有 3 支測試依賴 `mockito` 或 `mocktail`，分別覆蓋 `ApiClientImpl`、`HttpClient` 與 `NetworkInfoImpl`。這些測試主要驗證 request 組裝、錯誤轉換與連線狀態映射，適合改成 recorder / in-memory fake。

## 目標

1. 將下列 3 支測試改成不依賴 `mockito`、`mocktail`、`@GenerateMocks` 或 generated `.mocks.dart`
   - `awesome_mail_flutter/test/unit/core/network/api_client_test.dart`
   - `awesome_mail_flutter/test/unit/core/network/http_client_test.dart`
   - `awesome_mail_flutter/test/unit/core/network/network_info_test.dart`
2. 以 hand-written fake / recorder 取代 `HttpClient`、`Dio` 與 `Connectivity` 的 mock framework 依賴
3. 刪除對應的 2 個 generated `.mocks.dart`
4. 通過 batch 42 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不擴大到 `test/unit/core/sync`、`test/unit/data/protocols` 或其他資料夾
- 不修改 production network 流程

## 驗收條件

- `awesome_mail_flutter/test/unit/core/network` 不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`.mocks.dart`
- batch 42 相關測試全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
