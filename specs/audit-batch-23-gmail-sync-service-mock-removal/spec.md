# Spec: 批次 23 Gmail / sync data services mock 清理

## 背景

批次 22 已清掉 `test/unit/data/repositories` 的 10 支 mock-heavy 測試，並把 Flutter mock-heavy 檔案數降到 `216`。目前 Flutter 最大群組是 `awesome_mail_flutter/test/unit/data/services`，其中最集中且邊界清楚的一批，是 Gmail / sync 相關服務測試，共 12 支：

- `gmail_remote_service_test.dart`
- `gmail_remote_service_label_test.dart`
- `gmail_remote_service_message_test.dart`
- `gmail_remote_service_parser_test.dart`
- `gmail_remote_service_sync_test.dart`
- `gmail_attachment_parser_test.dart`
- `gmail_attachment_download_test.dart`
- `all_mail_sync_service_test.dart`
- `full_content_download_service_test.dart`
- `email_sync_service_test.dart`
- `attachment_download_manager_test.dart`
- `email_cache_coordinator_test.dart`

這批測試目前同時混用了 `mockito` generated mocks 與 `mocktail Mock implements`，而且 Gmail remote service 家族重複依賴同一組 token repository、refresh manager、refresh service、HTTP client 替身。

## 問題陳述

這批測試目前有四個問題：

1. Gmail remote service 家族高度依賴 generated mocks，測試描述聚焦在 `when` / `verify`，不是 request / response 與資料轉換行為。
2. `http.Client`、token refresh、repository 相關相依在多支檔案重複宣告 mock 類別，維護成本高。
3. orchestration 類服務（`all_mail_sync_service`、`email_sync_service`、`full_content_download_service`）仍主要依賴 framework mock，而不是手寫 fake 與記錄器。
4. 這批檔案對應的 `.mocks.dart` 檔仍讓 batch 9 持續命中。

## 使用者故事

### US1: Gmail remote service 測試改用共用手寫替身

作為維護者，我們希望 Gmail remote service 與附件解析 / 下載測試改用共用手寫 fake，直接驗證 HTTP request、token 續期與解析結果。

#### 驗收條件

1. `gmail_remote_service_*` 與 `gmail_attachment_*` 測試不再依賴 generated mocks。
2. 測試透過共用 fake 驗證 token 取得、refresh、HTTP request 與 response parsing。
3. 測試仍保留 label、message、parser、sync 與 attachment 相關行為驗證。

### US2: sync / coordination 類服務改用手寫 fake

作為維護者，我們希望 `all_mail_sync_service`、`full_content_download_service`、`email_sync_service`、`attachment_download_manager` 與 `email_cache_coordinator` 測試改以手寫 fake / in-memory 物件驅動，讓測試更接近實際資料流。

#### 驗收條件

1. 這 5 支服務測試不再出現 `mockito` 或 `mocktail Mock`。
2. 測試以呼叫紀錄、in-memory 狀態或實際資料物件驗證 orchestration 行為。
3. 相關 `.mocks.dart` 已刪除，搜尋驗證通過。

## 非目標

- 不修改 Gmail remote service 或 sync service 的 production API。
- 不擴大處理 `test/unit/data/services` 其他非 Gmail / sync 服務測試。
- 不在本批次處理 backend mock-heavy 測試。

## 成功指標

- 這 12 支 `data/services` 測試不再依賴 generated mocks 或 framework-driven mocks。
- batch 23 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- Flutter mock-heavy 檔案數在本批次完成後進一步下降。
