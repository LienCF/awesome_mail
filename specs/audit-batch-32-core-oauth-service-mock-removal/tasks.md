> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 32 core OAuth service mock 清理

**Input**: Design documents from `specs/audit-batch-32-core-oauth-service-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 core service 測試 `12` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 建立 auth / OAuth core service 共用 fake：provider availability、OAuth result、token store、API client、logger、bloc recorder
- [x] T003 [P] 對 `auth_service_test.dart` 或 `oauth_auth_service_test.dart` 做 red，確認 fake 缺口

## Phase 3: User Story 1 - auth / token orchestration 測試改用手寫 fake (Priority: P1)

**Goal**: 讓 auth / token orchestration 類 core service 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 mock framework

- [x] T004 [US1] 改寫 `auth_service_oauth_test.dart`
- [x] T005 [US1] 改寫 `auth_service_test.dart`
- [x] T006 [US1] 改寫 `oauth_auth_service_test.dart`
- [x] T007 [US1] 改寫 `oauth_onboarding_service_test.dart`

## Phase 4: User Story 2 - provider / error handling 測試改用手寫 fake (Priority: P1)

**Goal**: 讓 OAuth provider / error handling 類 core service 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 32 檔案已無 `mockito`、`mocktail`

- [x] T008 [US2] 改寫 `apple_oauth_service_test.dart`
- [x] T009 [US2] 改寫 `base_oauth_service_test.dart`
- [x] T010 [US2] 改寫 `google_oauth_service_test.dart`
- [x] T011 [US2] 改寫 `oauth_error_handling_test.dart`
- [x] T012 [US2] 改寫 `oauth_integration_test.dart`
- [x] T013 [US2] 改寫 `oauth_security_test.dart`
- [x] T014 [US2] 改寫 `unified_oauth_service_test.dart`
- [x] T015 [US2] 改寫 `menu_service_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T016 刪除 batch 32 對應 generated `.mocks.dart`
- [x] T017 執行 batch 32 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T018 更新 `tdd-audit-report.md` 與 batch 32 `tasks.md`
