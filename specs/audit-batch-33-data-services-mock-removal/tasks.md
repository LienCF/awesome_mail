> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 33 data services mock 清理

**Input**: Design documents from `specs/audit-batch-33-data-services-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 data service 測試 `8` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 建立 data services 共用 fake：queue recorder、subscription 狀態源、flags / sync / vector / DB fake
- [x] T003 [P] 對 `ai_task_scheduler_test.dart` 或 `subscription_manager_test.dart` 做 red，確認 fake 缺口

## Phase 3: User Story 1 - delegation / 狀態型 data service 測試改用手寫 fake (Priority: P1)

**Goal**: 讓 delegation / 狀態型 data service 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 mock framework

- [x] T004 [US1] 改寫 `ai_task_scheduler_test.dart`
- [x] T005 [US1] 改寫 `productivity_service_test.dart`
- [x] T006 [US1] 改寫 `in_app_purchase/subscription_manager_test.dart`

## Phase 4: User Story 2 - queue / DB / sync data service 測試改用 in-memory fake (Priority: P1)

**Goal**: 讓 queue / DB / sync 類 data service 測試改以 hand-written fake / in-memory 依賴驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 33 檔案已無 `mockito`、`mocktail`

- [x] T007 [US2] 改寫 `ai_task_queue_service_test.dart`
- [x] T008 [US2] 改寫 `ai_task_queue_service_bulk_security_test.dart`
- [x] T009 [US2] 改寫 `email_flags_service_test.dart`
- [x] T010 [US2] 改寫 `sync_health_checker_test.dart`
- [x] T011 [US2] 改寫 `vector_search_service_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T012 刪除 batch 33 對應 generated `.mocks.dart` 與 orphan generated 檔
- [x] T013 執行 batch 33 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T014 更新 `tdd-audit-report.md` 與 batch 33 `tasks.md`
