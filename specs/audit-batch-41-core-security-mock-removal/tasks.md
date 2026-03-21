> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 41 core security mock 清理

**Input**: Design documents from `specs/audit-batch-41-core-security-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 3 支 security 測試與 3 個 generated mocks 清單

## Phase 2: Foundational

- [x] T002 [P] 建立 security 共用 hand-written fake / recorder
- [x] T003 [P] 先跑 red，確認 biometric / credential / pgp 測試的依賴缺口

## Phase 3: User Story 1 - core security 測試改用 hand-written fake (Priority: P1)

**Goal**: 讓 core security 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: batch 41 targeted tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 biometric service 測試
- [x] T005 [US1] 改寫 credential manager 測試
- [x] T006 [US1] 改寫 pgp service 測試

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 刪除 batch 41 涵蓋的 generated `.mocks.dart` 並執行搜尋驗證
- [x] T008 執行 batch 41 targeted tests、`flutter analyze --fatal-infos` 與更新 `tdd-audit-report.md`
