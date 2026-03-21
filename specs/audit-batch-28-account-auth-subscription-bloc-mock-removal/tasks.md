> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 28 account/auth/subscription bloc mock 清理

**Input**: Design documents from `specs/audit-batch-28-account-auth-subscription-bloc-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 bloc / cubit 測試 `13` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 盤點並建立 bloc 測試共用 service / logger / stream fake
- [x] T003 [P] 對 `app_bloc_test.dart` 或 `auth_bloc_test.dart` 做 red，確認共用 fake 缺口

## Phase 3: User Story 1 - app / auth / settings 類 bloc 改用手寫 fake (Priority: P1)

**Goal**: 讓 app / auth / settings / account 類 bloc 測試改以共用 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 `mockito`

- [x] T004 [US1] 改寫 `app/app_bloc_test.dart`
- [x] T005 [US1] 改寫 `auth/auth_bloc_test.dart`
- [x] T006 [US1] 改寫 `settings/settings_bloc_test.dart`
- [x] T007 [US1] 改寫 `settings/pgp_keys_cubit_test.dart`
- [x] T008 [US1] 改寫 `account_management/account_management_cubit_test.dart`
- [x] T009 [US1] 改寫 `account_setup/account_setup_gmail_bloc_test.dart`

## Phase 4: User Story 2 - subscription 類測試改用手寫 fake (Priority: P1)

**Goal**: 讓 subscription 類 bloc / cubit 測試改以共用 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 28 檔案已無 `mockito`、`mocktail`

- [x] T010 [US2] 改寫 `subscription/subscription_bloc_test.dart`
- [x] T011 [US2] 改寫 `subscription/subscription_cubit_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T012 刪除 batch 28 對應 generated `.mocks.dart`
- [x] T013 執行 batch 28 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T014 更新 `tdd-audit-report.md` 與 batch 28 `tasks.md`
