> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 30 provider adapter mock 清理

**Input**: Design documents from `specs/audit-batch-30-provider-adapter-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 provider 測試 `14` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 盤點並建立 provider 測試共用 fake client / handler / provider stub
- [x] T003 [P] 對 `ai_provider_test.dart` 或 `email_provider_test.dart` 做 red，確認 fake 缺口

## Phase 3: User Story 1 - provider 介面層改用手寫 fake (Priority: P1)

**Goal**: 讓 provider 介面層測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 `mockito`

- [x] T004 [US1] 改寫 `ai_provider_test.dart`
- [x] T005 [US1] 改寫 `calendar_provider_test.dart`
- [x] T006 [US1] 改寫 `email_provider_test.dart`

## Phase 4: User Story 2 - Apple / iCloud / ProtonMail adapter 改用手寫 fake (Priority: P1)

**Goal**: 讓 Apple / iCloud / ProtonMail adapter 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 30 檔案已無 `mockito`、`mocktail`

- [x] T007 [US2] 改寫 `apple/apple_calendar_provider_test.dart`
- [x] T008 [US2] 改寫 `apple/apple_reminders_provider_test.dart`
- [x] T009 [US2] 改寫 `icloud/icloud_provider_test.dart`
- [x] T010 [US2] 改寫 `protonmail/protonmail_provider_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T011 刪除 batch 30 對應 generated `.mocks.dart`
- [x] T012 執行 batch 30 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T013 更新 `tdd-audit-report.md` 與 batch 30 `tasks.md`
