> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 44 data protocols client mock 清理

**Input**: Design documents from `specs/audit-batch-44-protocol-client-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 4 支 protocol client 測試清單

## Phase 2: Foundational

- [x] T002 [P] 建立 protocol client 共用 hand-written HTTP fake / recorder
- [x] T003 [P] 先跑 red，確認 CalDAV / CardDAV / EWS / JMAP 測試改寫時的依賴缺口

## Phase 3: User Story 1 - protocol client 測試改用 hand-written fake (Priority: P1)

**Goal**: 讓 protocol client 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: batch 44 targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 CalDAV client 測試
- [x] T005 [US1] 改寫 CardDAV client 測試
- [x] T006 [US1] 改寫 EWS client 測試
- [x] T007 [US1] 改寫 JMAP client 測試

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T008 刪除 mock shim 依賴並執行搜尋驗證
- [x] T009 執行 batch 44 targeted tests、`flutter analyze --fatal-infos` 與更新 `tdd-audit-report.md`
