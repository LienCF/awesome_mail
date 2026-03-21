> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 48 presentation blocs 單檔 mock 清理

**Input**: Design documents from `specs/audit-batch-48-presentation-bloc-singletons/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 10 支 `test/presentation/blocs/*` mock-heavy 測試

## Phase 2: Foundational

- [x] T002 [P] 盤點既有 `test/support/fakes/*` 可重用的 logger、service、repository 與 oauth 測試替身
- [x] T003 [P] 先跑 red，確認移除 mock framework 後的依賴缺口

## Phase 3: User Story 1 - presentation bloc / cubit 改用 hand-written fake (Priority: P1)

**Goal**: 讓 `test/presentation/blocs` 剩餘 10 支單檔改由 hand-written fake / recorder 驅動

**Independent Test**: batch 48 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos` 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 `account_cubit_test.dart`、`download_progress_cubit_test.dart`、`sync_progress_cubit_test.dart`
- [x] T005 [US1] 改寫 `compose_bloc_test.dart`、`attachment_action_cubit_test.dart`、`search_bloc_vector_test.dart`
- [x] T006 [US1] 改寫 `folder_cubit_test.dart`、`automation_bloc_test.dart`、`productivity_bloc_test.dart`
- [x] T007 [US1] 改寫 `account_setup_bloc_test.dart`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T008 執行 batch 48 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T009 更新 `tdd-audit-report.md` 與剩餘批次快照
