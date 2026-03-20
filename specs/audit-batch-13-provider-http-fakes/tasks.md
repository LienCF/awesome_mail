> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 13 provider HTTP fake client 去 mock 化

**Input**: Design documents from `specs/audit-batch-13-provider-http-fakes/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 4 支 provider 測試與 4 個 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 先補 `FakeHttpClient` 的 red 測試，涵蓋 request 記錄、handler 配對與未匹配錯誤

## Phase 3: User Story 1 - 建立可重用的 fake HTTP client (Priority: P1)

**Goal**: 讓 provider 測試可以用較真實的 fake response 驅動，而不是依賴 mock framework

**Independent Test**: `fake_http_client_test.dart` 通過

- [x] T003 [US1] 實作 `awesome_mail_flutter/test/support/fakes/fake_http_client.dart`

## Phase 4: User Story 2 - Provider 測試去 mock 化 (Priority: P1)

**Goal**: 讓 Google / Microsoft provider 測試改用 `FakeHttpClient`，並移除對應 generated mocks

**Independent Test**: 4 支 provider 測試通過，且不再依賴 `mockito`

- [x] T004 [US2] 改寫 `awesome_mail_flutter/test/unit/data/providers/google/google_calendar_provider_test.dart`
- [x] T005 [US2] 改寫 `awesome_mail_flutter/test/unit/data/providers/google/google_tasks_provider_test.dart`
- [x] T006 [US2] 改寫 `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_calendar_provider_test.dart`
- [x] T007 [US2] 改寫 `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_todo_provider_test.dart`
- [x] T008 [US2] 刪除對應的 4 個 `.mocks.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T009 更新 `tdd-audit-report.md`，記錄 batch 13 的 mock 去除範圍
- [ ] T010 執行 `flutter analyze --fatal-infos`、batch 13 相關測試與全量 `flutter test`
