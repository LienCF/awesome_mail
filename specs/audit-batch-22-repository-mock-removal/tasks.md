> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 22 repository mock 清理

**Input**: Design documents from `specs/audit-batch-22-repository-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 `data/repositories` `10` 個 mock-heavy 檔案

## Phase 2: Foundational

- [x] T002 [P] 先對 `account_repository_test.dart` 做 red，建立不依賴 mock framework 的 cache / credential fake
- [x] T003 [P] 建立 repository 共用測試替身，供 `email_repository_test.dart`、`email_repository_impl_test.dart` 與 helper 測試共用

## Phase 3: User Story 1 - repository 測試改用共用手寫替身 (Priority: P1)

**Goal**: 讓 repository 相關測試改以共用手寫 fake / in-memory 物件驅動

**Independent Test**: batch 22 repository targeted tests 通過，且主 repository 測試不再依賴 generated mocks

- [x] T004 [US1] 改寫 `account_repository_test.dart`
- [x] T005 [US1] 改寫 `email_repository_test.dart`
- [x] T006 [US1] 改寫 `email_repository_impl_test.dart`
- [x] T007 [US1] 改寫 helper / operations 測試

## Phase 4: User Story 2 - 移除 repository generated mocks 與重複 mock 宣告 (Priority: P1)

**Goal**: 刪除 generated `.mocks.dart` 並清除 repository 批次中的 framework-driven mock 依賴

**Independent Test**: `data/repositories` 批次檔案已無 `mockito`、`@GenerateMocks`、`.mocks.dart`

- [x] T008 [US2] 刪除 `email_repository_test.mocks.dart`
- [x] T009 [US2] 搜尋驗證 repository 批次已無 mock framework 殘留

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T010 執行 batch 22 相關測試與 `flutter analyze --fatal-infos`
- [x] T011 更新 `tdd-audit-report.md` 與 batch 22 `tasks.md`
