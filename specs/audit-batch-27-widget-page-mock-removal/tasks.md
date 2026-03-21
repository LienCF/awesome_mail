> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 27 widget page mock 清理

**Input**: Design documents from `specs/audit-batch-27-widget-page-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 widget/page 測試 `16` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 盤點並建立 widget/page 共用 bloc / cubit / service / navigation 測試 harness
- [x] T003 [P] 對 `ai_classification_page_test.dart` 或 `oauth_login_page_test.dart` 做 red，確認共用 fake 缺口

## Phase 3: User Story 1 - 輕依賴頁面改用手寫 fake (Priority: P1)

**Goal**: 讓輕依賴 widget/page 測試改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 `mocktail Mock`

- [x] T004 [US1] 改寫 `ai/ai_classification_page_test.dart`
- [x] T005 [US1] 改寫 `auth/oauth_login_page_test.dart`
- [x] T006 [US1] 改寫 `automation/automation_page_test.dart`
- [x] T007 [US1] 改寫 `batch/batch_operations_page_test.dart`
- [x] T008 [US1] 改寫 `draft/draft_management_page_test.dart`
- [x] T009 [US1] 改寫 `search/search_page_test.dart`
- [x] T010 [US1] 改寫 `splash/splash_page_test.dart`

## Phase 4: User Story 2 - 中度依賴頁面改用手寫 fake (Priority: P1)

**Goal**: 讓中度依賴 page 測試改以 hand-written bloc / cubit / service fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 27 檔案已無 `mockito`、`mocktail`

- [x] T011 [US2] 改寫 `account_setup/account_setup_page_test.dart`
- [x] T012 [US2] 改寫 `subscription/subscription_analytics_page_test.dart`
- [x] T013 [US2] 改寫 `subscription/subscription_page_impl_test.dart`
- [x] T014 [US2] 改寫 `subscription/subscription_page_test.dart`
- [x] T015 [US2] 改寫 `templates/advanced_template_management_page_test.dart`
- [x] T016 [US2] 改寫 `templates/templates_page_impl_test.dart`

## Phase 5: User Story 3 - 高依賴頁面與收尾 (Priority: P1)

**Goal**: 完成複雜 page 測試改寫並清掉 generated mock 依賴

**Independent Test**: batch 27 搜尋驗證、`flutter analyze --fatal-infos`、Flutter 全量回歸通過

- [x] T017 [US3] 改寫 `compose/compose_page_test.dart`
- [x] T018 [US3] 改寫 `home/home_page_test.dart`
- [x] T019 [US3] 改寫 `home/macos_home_page_test.dart`
- [x] T020 [US3] 刪除 batch 27 對應 generated `.mocks.dart`
- [x] T021 [US3] 執行 batch 27 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T022 [US3] 更新 `tdd-audit-report.md` 與 batch 27 `tasks.md`
