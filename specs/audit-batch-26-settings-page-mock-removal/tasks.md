> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 26 settings page mock 清理

**Input**: Design documents from `specs/audit-batch-26-settings-page-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 settings page 測試 `15` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 盤點並建立 settings page 共用 bloc / cubit / service widget 測試 harness
- [x] T003 [P] 對 `about_page_test.dart` 或 `appearance_settings_page_test.dart` 做 red，確認共用 fake 缺口

## Phase 3: User Story 1 - 單頁 settings bloc 類測試改用手寫 fake (Priority: P1)

**Goal**: 讓單頁 settings widget 測試改以 hand-written bloc / cubit fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 `mocktail Mock`

- [x] T004 [US1] 改寫 `about_page_test.dart`
- [x] T005 [US1] 改寫 `accessibility_settings_page_test.dart`
- [x] T006 [US1] 改寫 `appearance_settings_page_test.dart`
- [x] T007 [US1] 改寫 `general_settings_page_test.dart`
- [x] T008 [US1] 改寫 `notification_settings_page_test.dart`
- [x] T009 [US1] 改寫 `privacy_settings_page_test.dart`
- [x] T010 [US1] 改寫 `sync_settings_page_test.dart`
- [x] T011 [US1] 改寫 `update_settings_page_test.dart`

## Phase 4: User Story 2 - 多依賴 settings 頁面改用手寫 fake (Priority: P1)

**Goal**: 讓多依賴 settings 頁面測試改以 hand-written bloc / cubit / service fake 驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 26 檔案已無 `mockito`、`mocktail`

- [x] T012 [US2] 改寫 `account_settings_page_test.dart`
- [x] T013 [US2] 改寫 `ai_settings_page_test.dart`
- [x] T014 [US2] 改寫 `backup_settings_page_test.dart`
- [x] T015 [US2] 改寫 `pgp_keys_page_test.dart`
- [x] T016 [US2] 改寫 `security_settings_page_test.dart`
- [x] T017 [US2] 改寫 `settings_page_test.dart`
- [x] T018 [US2] 改寫 `shortcuts_settings_page_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T019 刪除 batch 26 對應 generated `.mocks.dart`
- [x] T020 執行 batch 26 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T021 更新 `tdd-audit-report.md` 與 batch 26 `tasks.md`
