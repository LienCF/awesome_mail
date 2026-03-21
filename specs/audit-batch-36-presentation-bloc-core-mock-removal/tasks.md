> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 36 presentation bloc core mock 清理

**Input**: Design documents from `specs/audit-batch-36-presentation-bloc-core-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 bloc 測試 `5` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 建立 email sync / search / sync bloc 所需的手寫 fake 或 recorder
- [x] T003 [P] 對其中一支測試先做 red，確認 fake 介面缺口

## Phase 3: User Story 1 - 核心 bloc / cubit 改用手寫 fake (Priority: P1)

**Goal**: 讓核心 bloc / cubit 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 `email_sync_cubit_test.dart`
- [x] T005 [US1] 改寫 `search/search_bloc_test.dart`
- [x] T006 [US1] 改寫 `sync/sync_bloc_test.dart`

## Phase 4: User Story 2 - 持久化與 AI 行為改用 recorder 驗證 (Priority: P1)

**Goal**: 直接驗證 `AuthBloc` 與 `AIBloc` 的 recorded calls、持久化內容與 state

**Independent Test**: `state_persistence_test.dart`、`ai_bloc_test.dart` 通過，且以 hand-written fake 驅動

- [x] T007 [US2] 改寫 `state_persistence_test.dart`
- [x] T008 [US2] 改寫 `ai/ai_bloc_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T009 刪除 `ai_bloc_test.mocks.dart`、`state_persistence_test.mocks.dart`、`sync_bloc_test.mocks.dart`
- [x] T010 執行 batch 36 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T011 更新 `tdd-audit-report.md` 與 batch 36 `tasks.md`
