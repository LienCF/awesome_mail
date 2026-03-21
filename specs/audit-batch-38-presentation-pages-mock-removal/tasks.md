> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 38 presentation pages mock 清理

**Input**: Design documents from `specs/audit-batch-38-presentation-pages-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 page/controller 測試 9 檔與 generated mock 清單

## Phase 2: Foundational

- [x] T002 [P] 建立可重用的 page 測試 fake / recorder 組合
- [x] T003 [P] 對其中一支測試先做 red，確認 fake 介面缺口

## Phase 3: User Story 1 - page 測試改用 hand-written fake (Priority: P1)

**Goal**: 讓 account setup、auth、sync、home page/controller 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: batch 38 targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 account setup / Gmail setup 測試
- [x] T005 [US1] 改寫 auth page 測試
- [x] T006 [US1] 改寫 home controller / keyboard 測試
- [x] T007 [US1] 改寫 sync page 測試

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T008 刪除 batch 38 涵蓋的 generated .mocks.dart 並執行搜尋驗證
- [x] T009 執行 batch 38 targeted tests、flutter analyze --fatal-infos 與更新 tdd-audit-report.md
