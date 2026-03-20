> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 16 page / handler coverage 對齊

**Input**: Design documents from `specs/audit-batch-16-page-handler-coverage-reconciliation/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認 17 個 page / handler 類檔案各自已有對應頁面或 bloc 測試覆蓋

## Phase 2: User Story 1 - page / handler 類缺測名單與真實測試對齊 (Priority: P1)

**Goal**: 讓 page composition 與 private handler 類假陽性從缺測清單移除

**Independent Test**: 相關 targeted tests 通過，且 `tdd-audit-report.md` 不再列出這 17 個檔案

- [x] T002 [US1] 執行 account setup / home / mailbox handlers / settings sections 的 targeted tests
- [x] T003 [US1] 更新 `tdd-audit-report.md`，移除 17 個 page / handler 假陽性並下修 Flutter 缺測數

## Phase 3: Polish & Cross-Cutting Concerns

- [x] T004 更新 batch 16 `tasks.md` 狀態
