> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 40 unit presentation widgets mock 清理

**Input**: Design documents from `specs/audit-batch-40-unit-presentation-widgets-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 7 支測試與 4 個 generated mocks 清單

## Phase 2: Foundational

- [x] T002 [P] 擴充 presentation widget 共用 fake / recorder
- [x] T003 [P] 先跑一支 red，確認 bloc / service fake 介面缺口

## Phase 3: User Story 1 - unit widget 測試改用 hand-written fake (Priority: P1)

**Goal**: 讓 AI widget、sync widget、OAuth feature discovery 與 voice input button 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: batch 40 targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 AI widget 測試
- [x] T005 [US1] 改寫 sync widget 測試
- [x] T006 [US1] 改寫 OAuth feature discovery / voice input / reading pane widget 測試

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 刪除 batch 40 涵蓋的 generated `.mocks.dart` 並執行搜尋驗證
- [x] T008 執行 batch 40 targeted tests、`flutter analyze --fatal-infos` 與更新 `tdd-audit-report.md`
