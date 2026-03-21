> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 46 monitoring 與 presentation services mock 清理

**Input**: Design documents from `specs/audit-batch-46-monitoring-and-services-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 3 支測試與 1 個 generated mock 清單

## Phase 2: Foundational

- [x] T002 [P] 建立 monitoring / settings 共用 hand-written fake 或 stub
- [x] T003 [P] 先跑 red，確認 batch 46 測試改寫時的依賴缺口

## Phase 3: User Story 1 - monitoring 與 service 測試改用 hand-written fake (Priority: P1)

**Goal**: 讓 monitoring 與 presentation services 測試改由 hand-written fake 或 stub 驅動

**Independent Test**: batch 46 targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 network monitor 測試
- [x] T005 [US1] 改寫 service factory 測試
- [x] T006 [US1] 改寫 bloc AI settings service 測試

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 刪除 batch 46 涵蓋的 generated `.mocks.dart` 並執行搜尋驗證
- [x] T008 執行 batch 46 targeted tests、`flutter analyze --fatal-infos` 與更新 `tdd-audit-report.md`
