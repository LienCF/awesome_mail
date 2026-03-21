> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 37 mailbox bloc mock 清理

**Input**: Design documents from `specs/audit-batch-37-mailbox-bloc-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 mailbox 測試 `2` 檔與共用依賴矩陣

## Phase 2: Foundational

- [x] T002 [P] 建立 mailbox 共用 dependency fake / recorder
- [x] T003 [P] 對其中一支 mailbox 測試先做 red，確認 fake 介面缺口

## Phase 3: User Story 1 - mailbox bloc 改用 hand-written fake (Priority: P1)

**Goal**: 讓 mailbox bloc / handler 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: mailbox targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 `mailbox/mailbox_bloc_test.dart`
- [x] T005 [US1] 改寫 `mailbox/mailbox_handlers_test.dart`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T006 執行 batch 37 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T007 更新 `tdd-audit-report.md` 與 batch 37 `tasks.md`
