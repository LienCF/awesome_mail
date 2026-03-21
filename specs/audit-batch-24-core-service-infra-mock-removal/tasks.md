> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 24 core service infra mock 清理

**Input**: Design documents from `specs/audit-batch-24-core-service-infra-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 core service 測試 `8` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 對 `token_service_test.dart` 做 red，建立不依賴 mock framework 的 `ApiClient` / `FlutterSecureStorage` fake
- [x] T003 [P] 建立 core service infra 共用測試替身，供 API / storage / logger / provider 類測試共用

## Phase 3: User Story 1 - API / storage orchestration 類測試改用手寫 fake (Priority: P1)

**Goal**: 讓 API / storage orchestration 類 core service 測試改以共用手寫 fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 `mocktail Mock`

- [x] T004 [US1] 改寫 `token_service_test.dart`
- [x] T005 [US1] 改寫 `sync_service_test.dart`
- [x] T006 [US1] 改寫 `email_service_test.dart`
- [x] T007 [US1] 改寫 `biometric_auth_service_test.dart`

## Phase 4: User Story 2 - state / logger / provider 類測試改用手寫 fake (Priority: P1)

**Goal**: 讓 state / logger / provider 類 core service 測試改以共用 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 24 檔案已無 `mockito`、`mocktail`

- [x] T008 [US2] 改寫 `device_id_service_test.dart`
- [x] T009 [US2] 改寫 `state_persistence_service_test.dart`
- [x] T010 [US2] 改寫 `app_lifecycle_manager_test.dart`
- [x] T011 [US2] 改寫 `ai_service_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T012 刪除 batch 24 對應 generated `.mocks.dart`
- [x] T013 執行 batch 24 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T014 更新 `tdd-audit-report.md` 與 batch 24 `tasks.md`
