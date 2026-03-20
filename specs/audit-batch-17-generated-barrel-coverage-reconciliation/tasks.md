> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 17 generated / barrel / example coverage 對齊

**Input**: Design documents from `specs/audit-batch-17-generated-barrel-coverage-reconciliation/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認 5 個候選檔案的 generated / barrel / example / indirect coverage 身分

## Phase 2: User Story 1 - generated / barrel / example 類名單與真實測試策略對齊 (Priority: P1)

**Goal**: 讓這 5 個不該算直接缺測的檔案從清單移除

**Independent Test**: `foundation_ai_provider_test.dart` 通過，且 `tdd-audit-report.md` 不再列出這 5 個檔案

- [x] T002 [US1] 執行 `flutter test test/unit/data/providers/foundation_ai_provider_test.dart`
- [x] T003 [US1] 更新 `tdd-audit-report.md`，移除 5 個假陽性並下修 Flutter 缺測數

## Phase 3: Polish & Cross-Cutting Concerns

- [x] T004 更新 batch 17 `tasks.md` 狀態
