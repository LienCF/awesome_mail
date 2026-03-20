# Spec: 批次 13 provider HTTP fake client 去 mock 化

## 背景

批次 12 已經把 app 程式碼中的 `while` / `do-while` 類違規清空，接下來剩餘高優先違規集中在測試端。其中一個明確群組，是 Flutter 多支 provider 測試直接以 `mockito` 產生 `MockClient` 來假造 `http.Client`：

- `awesome_mail_flutter/test/unit/data/providers/google/google_calendar_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/google/google_tasks_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_calendar_provider_test.dart`
- `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_todo_provider_test.dart`

這四支測試的結構高度相似，都是用 stub 回傳固定 HTTP payload，再驗證 provider 的 parsing 與錯誤處理。繼續維持 `mockito` 不只違反 Detroit School 偏好，也讓 generated `.mocks.dart` 一直留在違規名單裡。

## 問題陳述

目前這批測試有兩個問題：

1. 直接依賴 `mockito` / generated mock，而不是較接近真實 HTTP 行為的 fake client。
2. 沒有共用的 HTTP fake 基礎設施，導致相似測試複製同一套 stub 寫法。

如果不處理，批次 9 的 mock-heavy 測試清理會一直停在高噪音狀態，也無法形成可複用的 migration pattern。

## 使用者故事

### US1: provider 測試改用可重用的 fake HTTP client

作為維護者，我們希望 provider 測試改用記錄 request、回傳真實 `http.Response` 的 fake client，讓測試仍然專注在 provider 行為，而不是 mock framework 細節。

#### 驗收條件

1. 建立共用的 `FakeHttpClient` 測試支援元件。
2. `FakeHttpClient` 能依 method / URL 配對 handler，並保留 request 紀錄供測試驗證。
3. 若沒有匹配的 handler，測試會得到清楚的錯誤。

### US2: Google / Microsoft provider 測試不再依賴 generated mocks

作為維護者，我們希望四支 provider 測試改成使用 `FakeHttpClient`，並移除對應 `.mocks.dart`，讓 parsing、同步與錯誤情境仍由真實 response 驅動。

#### 驗收條件

1. 四支 provider 測試不再 import `mockito` 或 `.mocks.dart`。
2. 四支 provider 測試全部通過，且 coverage 行為不退化。
3. 對應的 generated `.mocks.dart` 可刪除。

## 非目標

- 不處理其他 `http.Client` mock-heavy 測試檔。
- 不變更 provider 對外 API 或實際 production 邏輯。
- 不一次處理 batch 10 的缺測清單。

## 成功指標

- 這四支 provider 測試與新 fake client 測試全部通過。
- `flutter analyze --fatal-infos` 通過。
- `tdd-audit-report.md` 更新後，能記錄 batch 13 已完成的 mock 去除範圍。
