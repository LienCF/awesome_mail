# Spec: 批次 20 HTTP client mock 收尾

## 背景

批次 13 已經建立共用 `FakeHttpClient`，並把 Google / Microsoft 的一組 provider 測試從 `mockito` generated mocks 遷移出去。批次 18 與批次 19 也已經把直接缺測清單清空，因此目前 `tdd-audit-report.md` 中唯一尚未關帳的審計主題，只剩批次 9 的 Detroit School mock 濫用清理。

這個剩餘群組已經縮到 10 支 Flutter 測試，全部都直接 mock `http.Client`：

- `awesome_mail_flutter/test/unit/data/protocols/caldav/caldav_client_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_client_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_client_test.dart`
- `awesome_mail_flutter/test/unit/data/protocols/exchange/ews_client_test.dart`
- `awesome_mail_flutter/test/unit/data/services/account_config_service_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/outlook/outlook_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/productivity/todoist_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/productivity/notion_provider_test.dart`
- `awesome_mail_flutter/test/unit/core/remote_config_service_test.dart`
- `awesome_mail_flutter/test/unit/core/update_service_test.dart`

## 問題陳述

這批測試目前有三個問題：

1. 仍然依賴 `mockito` generated mocks 或 `mocktail` `MockHttpClient`，測試行為綁定在 stub framework，而不是較真實的 HTTP request / response。
2. 同一類型的 HTTP 測試分散使用兩套 mock 手法，和批次 13 建好的 fake client 模式不一致。
3. 只要這批未清完，批次 9 就不能結案，整體審計也不能宣告全部完成。

## 使用者故事

### US1: 剩餘 HTTP 類測試改用共用 HTTP 測試替身

作為維護者，我們希望所有剩餘直接 mock `http.Client` 的 Flutter 測試都改用共用 HTTP 測試替身，讓測試以真實 `http.Response`、request 紀錄或共用 shim 驗證行為，而不是綁定單一 mock framework 細節。

#### 驗收條件

1. 上述 10 支測試不再 import `mockito`、`mocktail` 的 `http.Client` mock，且不再依賴對應 `.mocks.dart`。
2. 測試仍保留 happy path、錯誤處理與 request 驗證。
3. 所有 HTTP 呼叫都透過共用 `FakeHttpClient` 或共用 shim 驅動。

### US2: 批次 9 關帳

作為維護者，我們希望 `tdd-audit-report.md` 能明確記錄最後一批 `http.Client` mock 清理已完成，讓 batch 9 從待處理名單移除，審計主題歸零。

#### 驗收條件

1. `tdd-audit-report.md` 追加 batch 20 結果，並明確標示 batch 9 已完成。
2. `目前剩餘重點違規` 不再列出任何待收尾批次。
3. `待處理批次建議` 清空或標示已無待處理項目。

## 非目標

- 不擴大處理與 `http.Client` 無關的 widget / bloc 測試 mock。
- 不修改 production API 或新增非必要功能。
- 不更動已經驗證通過、且不屬於本批次的其他審計結果。

## 成功指標

- 10 支 Flutter 測試全部通過，且不再依賴 `http.Client` generated mocks。
- `flutter analyze --fatal-infos` 通過。
- Flutter 全量 `flutter test` 通過。
- `tdd-audit-report.md` 顯示所有審計批次已完成。
