# Spec: 批次 30 provider adapter mock 清理

## 背景

batch 29 已把 `test/unit/data/services` 的第一批 mock-heavy 測試清掉，接下來 Flutter 剩餘最大的 mock-heavy 群組是 `awesome_mail_flutter/test/unit/data/providers`。其中 provider 介面層與 Apple / iCloud / ProtonMail adapter 測試目前有 `14` 個檔案仍依賴 `mockito`、generated `.mocks.dart` 或大量 `when` / `verify`：

- `ai_provider_test.dart`
- `ai_provider_test.mocks.dart`
- `calendar_provider_test.dart`
- `calendar_provider_test.mocks.dart`
- `email_provider_test.dart`
- `email_provider_test.mocks.dart`
- `apple/apple_calendar_provider_test.dart`
- `apple/apple_calendar_provider_test.mocks.dart`
- `apple/apple_reminders_provider_test.dart`
- `apple/apple_reminders_provider_test.mocks.dart`
- `icloud/icloud_provider_test.dart`
- `icloud/icloud_provider_test.mocks.dart`
- `protonmail/protonmail_provider_test.dart`
- `protonmail/protonmail_provider_test.mocks.dart`

這批測試的依賴集中在 provider 抽象介面、CalDAV / IMAP / SMTP handler 與 http client，非常適合先收斂成 hand-written fake 與最小 stub。

## 問題陳述

這批 provider 測試目前有四個問題：

1. 介面型測試過度依賴 `mockito`，測的是 mock 腳本與呼叫次數，不是 provider 對協定 / 依賴的實際轉換行為。
2. `AIProvider`、`EmailProvider`、`CalendarProvider`、`CalDAVClient`、`IMAPHandler`、`SMTPHandler` 的 generated mocks 在多個檔案重複出現，維護成本高。
3. `.mocks.dart` 讓這批 adapter 測試依賴 codegen 與 mock framework，而不是用最小 fake 驗證資料映射與錯誤處理。
4. `test/unit/data/providers` 目前仍是 Flutter 最大的 mock-heavy 群組之一，若不先處理這批 adapter，後續 Gmail / Yahoo / token 類 provider 測試會持續沿用同樣模式。

## 使用者故事

### US1: 以 hand-written fake 驅動 provider 介面層測試

作為維護者，我們希望 `AIProvider`、`EmailProvider`、`CalendarProvider` 的測試改以 hand-written fake / stub 驅動，直接驗證抽象介面的行為契約與資料回傳。

#### 驗收條件

1. `ai_provider_test.dart`、`email_provider_test.dart`、`calendar_provider_test.dart` 不再依賴 `mockito`、`@GenerateMocks` 或 generated `.mocks.dart`。
2. 測試直接驗證 provider 回傳值、例外與狀態，而不是 `verify` 次數。
3. 共用 fake 可重複用於其他 provider 測試。

### US2: 以 hand-written fake 驅動 Apple / iCloud / ProtonMail provider adapter 測試

作為維護者，我們希望 Apple、iCloud、ProtonMail provider 測試改以 fake CalDAV / IMAP / SMTP / http 依賴驅動，直接驗證 adapter 對外行為。

#### 驗收條件

1. 這批 adapter 測試改用最小可控 fake client / handler。
2. 測試保留 happy path、錯誤路徑與協定資料轉換驗證。
3. 這批對應 `.mocks.dart` 依賴完全移除。

### US3: 清掉 batch 30 範圍的 mock framework 依賴

作為維護者，我們希望 batch 30 範圍內的 provider 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。

#### 驗收條件

1. 這批對應 `.mocks.dart` 已刪除。
2. batch 30 檔案與共用 fake 檔中已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 production provider 公開 API。
- 不在本批次處理 Gmail / Yahoo / token refresh / hybrid AI provider。
- 不擴大處理 backend mock-heavy 測試。

## 成功指標

- 這 `14` 個 provider 測試檔案改由 hand-written fake 驅動。
- batch 30 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- `test/unit/data/providers` mock-heavy 群組在本批次完成後進一步下降。
