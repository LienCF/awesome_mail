> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 35 presentation bloc foundation mock 清理

**Input**: Design documents from `specs/audit-batch-35-presentation-bloc-foundation-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 bloc 測試 `4` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 建立 bloc manager / email sync / mailbox action 所需的手寫 recorder 或 fake
- [x] T003 [P] 對其中一支測試先做 red，確認 fake 介面缺口

## Phase 3: User Story 1 - 基礎 bloc 測試改用手寫 fake (Priority: P1)

**Goal**: 讓基礎 bloc / cubit 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 `bloc_manager_test.dart`
- [x] T005 [US1] 改寫 `email_sync/email_sync_cubit_test.dart`
- [x] T006 [US1] 改寫 `mailbox/mailbox_action_cubit_test.dart`

## Phase 4: User Story 2 - `BlocFactory` 改用手寫 interface fake (Priority: P1)

**Goal**: 保留 `GetIt` factory 驗證，同時移除 `mocktail`

**Independent Test**: `bloc_factory_test.dart` 通過，且以 hand-written bloc fake 註冊工廠

- [x] T007 [US2] 改寫 `bloc_factory_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T008 刪除 `bloc_manager_test.mocks.dart`
- [x] T009 執行 batch 35 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T010 更新 `tdd-audit-report.md` 與 batch 35 `tasks.md`
