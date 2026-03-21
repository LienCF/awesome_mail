> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 25 service storage/cache mock 清理

**Input**: Design documents from `specs/audit-batch-25-service-storage-cache-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 `data/services` 測試 `10` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 盤點並擴充共用 fake，補足 API / storage / cache / DB / logger 所需能力
- [x] T003 [P] 對 `email_account_service_test.dart` 或 `usage_tracking_service_test.dart` 做 red，確認共用 fake 缺口

## Phase 3: User Story 1 - API / secure storage 類測試改用手寫 fake (Priority: P1)

**Goal**: 讓 API / secure storage 類 `data/services` 測試改以共用手寫 fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 `mocktail Mock`

- [x] T004 [US1] 改寫 `email_account_service_test.dart`
- [x] T005 [US1] 改寫 `metrics_service_test.dart`
- [x] T006 [US1] 改寫 `usage_tracking_service_test.dart`
- [x] T007 [US1] 改寫 `subscription_service_test.dart`
- [x] T008 [US1] 清理 `settings_backup_service_test.dart` 的空白 mock 註解

## Phase 4: User Story 2 - cache / database / logger 類測試改用手寫 fake (Priority: P1)

**Goal**: 讓 cache / database / logger 類 `data/services` 測試改以共用 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 25 檔案已無 `mockito`、`mocktail`

- [x] T009 [US2] 改寫 `email_cache_service_test.dart`
- [x] T010 [US2] 改寫 `email_cache_coordinator_cas_test.dart`
- [x] T011 [US2] 改寫 `email_search_service_test.dart`
- [x] T012 [US2] 改寫 `unread_count_manager_test.dart`
- [x] T013 [US2] 改寫 `draft_service_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T014 刪除 batch 25 對應 generated `.mocks.dart`
- [x] T015 執行 batch 25 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T016 更新 `tdd-audit-report.md` 與 batch 25 `tasks.md`
