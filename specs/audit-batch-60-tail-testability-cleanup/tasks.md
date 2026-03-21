> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 60 尾端測試可測試性清理

**Input**: Design documents from `specs/audit-batch-60-tail-testability-cleanup/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 60 納入的 backend / Flutter 尾端檔案與清理策略

## Phase 2: Foundational

- [x] T002 [P] 在 logger 與 database init 建立最小測試注入點

## Phase 3: User Story 1 - 清理尾端測試違規 (Priority: P1)

**Goal**: 讓尾端測試改由 hand-written fake 與真實行為驗證驅動，移除重複低價值檔案**

**Independent Test**: backend / Flutter targeted tests 與搜尋驗證通過

- [x] T003 [US1] 改寫 `tests/unit/utils/logger.test.ts`
- [x] T004 [US1] 改寫 `tests/unit/database/init-migrations.test.ts` 並移除重複 coverage 檔
- [x] T005 [US1] 刪除重複 backend 測試殘留 `tests/oauth-exchange.test.ts`、`tests/unit/subscriptions.test.ts`
- [x] T006 [US1] 改寫 `foundation_models_framework_client_test.dart` 與移除 `.bak` 備份檔

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 執行 backend / Flutter targeted tests
- [x] T008 執行搜尋驗證與更新 `tdd-audit-report.md`
- [x] T009 視掃描結果決定下一批或完成全量驗證
