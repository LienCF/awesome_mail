> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 29 data services mock 清理

**Input**: Design documents from `specs/audit-batch-29-data-services-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 data service 測試 `14` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 盤點並建立 data service 測試共用 `EmailService` / `AIService` / payment provider fake
- [x] T003 [P] 對 `email_rule_engine_simple_test.dart` 或 `payment_service_test.dart` 做 red，確認 fake 缺口

## Phase 3: User Story 1 - automation / batch operation 類 service 改用手寫 fake (Priority: P1)

**Goal**: 讓 automation / batch operation 類 service 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 `mockito`

- [x] T004 [US1] 改寫 `automation/email_rule_engine_simple_test.dart`
- [x] T005 [US1] 改寫 `automation/email_rule_engine_test.dart`
- [x] T006 [US1] 改寫 `batch_operations/batch_operation_service_simple_test.dart`
- [x] T007 [US1] 改寫 `batch_operations/batch_operation_service_test.dart`

## Phase 4: User Story 2 - template / payment 類 service 改用手寫 fake (Priority: P1)

**Goal**: 讓 template / payment 類 service 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 29 檔案已無 `mockito`、`mocktail`

- [x] T008 [US2] 改寫 `template_service_simple_test.dart`
- [x] T009 [US2] 改寫 `template_service_test.dart`
- [x] T010 [US2] 改寫 `payment/payment_service_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T011 刪除 batch 29 對應 generated `.mocks.dart`
- [x] T012 執行 batch 29 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T013 更新 `tdd-audit-report.md` 與 batch 29 `tasks.md`
