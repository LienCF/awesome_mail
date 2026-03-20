> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 15 helper coverage 對齊

**Input**: Design documents from `specs/audit-batch-15-helper-coverage-reconciliation/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認 9 個 helper 檔各自已有對應測試檔

## Phase 2: User Story 1 - helper 類缺測名單與真實測試對齊 (Priority: P1)

**Goal**: 讓 helper 類假陽性從缺測清單移除

**Independent Test**: 9 個 helper 對應測試通過，且 `tdd-audit-report.md` 不再列出這些檔案

- [x] T002 [US1] 執行 9 個 helper 對應的 targeted tests
- [x] T003 [US1] 更新 `tdd-audit-report.md`，移除 9 個 helper 假陽性並下修 Flutter 缺測數

## Phase 3: Polish & Cross-Cutting Concerns

- [x] T004 更新 batch 15 `tasks.md` 狀態
