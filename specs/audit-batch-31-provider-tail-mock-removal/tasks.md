> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 31 provider tail mock 清理

**Input**: Design documents from `specs/audit-batch-31-provider-tail-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 provider 測試 `8` 檔與 Yahoo 對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 盤點並建立 provider tail 共用 fake：`ApiClient`、`FlutterSecureStorage`、`Dio`、`GoogleSignInManager`、`FoundationModelsFramework`
- [x] T003 [P] 對 `token_refresh_service_test.dart` 或 `gmail_token_repository_test.dart` 做 red，確認 fake 缺口

## Phase 3: User Story 1 - token / storage / refresh 測試改用手寫 fake (Priority: P1)

**Goal**: 讓 token / storage / refresh 類 provider 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 mock framework

- [x] T004 [US1] 改寫 `gmail/token_refresh_service_test.dart`
- [x] T005 [US1] 改寫 `oauth/oauth_token_refresh_service_test.dart`
- [x] T006 [US1] 改寫 `gmail/gmail_token_repository_test.dart`
- [x] T007 [US1] 改寫 `gmail/gmail_token_refresh_manager_test.dart`

## Phase 4: User Story 2 - OAuth / provider / stream 測試改用手寫 fake (Priority: P1)

**Goal**: 讓 Gmail OAuth / Yahoo / Foundation Models 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 31 檔案已無 `mockito`、`mocktail`

- [x] T008 [US2] 改寫 `gmail/oauth_error_reporter_test.dart`
- [x] T009 [US2] 改寫 `gmail/gmail_oauth_service_real_test.dart`
- [x] T010 [US2] 改寫 `yahoo/yahoo_provider_test.dart`
- [x] T011 [US2] 改寫 `foundation/foundation_models_framework_client_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T012 刪除 `yahoo/yahoo_provider_test.mocks.dart`
- [x] T013 執行 batch 31 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T014 更新 `tdd-audit-report.md` 與 batch 31 `tasks.md`
