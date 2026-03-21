> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 56 backend jobs fake 收斂

**Input**: Design documents from `specs/audit-batch-56-backend-jobs-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 56 納入的 jobs fixture 與 8 支 jobs 測試範圍

## Phase 2: Foundational

- [x] T002 [P] 重構 `job-test-data.ts`，提供可觀察的 DB / KV / R2 hand-written fake
- [x] T003 [P] 補齊 jobs 測試共用的時間、排程與 context 建立工具

## Phase 3: User Story 1 - 清理 jobs mock-heavy 測試 (Priority: P1)

**Goal**: 讓 jobs 測試改由 hand-written fake、真實排程時間與狀態驗證驅動**

**Independent Test**: batch 56 targeted tests 與 `npm run quality:check` 通過

- [x] T004 [US1] 改寫 `base-job.test.ts`
- [x] T005 [US1] 改寫 `cleanup-job.test.ts` 與 `cleanup-job-coverage.test.ts`
- [x] T006 [US1] 改寫 `health-check-job.test.ts` 與 `health-check-job-coverage.test.ts`
- [x] T007 [US1] 改寫 `usage-reset-job.test.ts` 與 `usage-reset-job-coverage.test.ts`
- [x] T008 [US1] 改寫 `job-manager.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T009 執行 batch 56 targeted tests
- [x] T010 執行 `awesome-mail` `npm run quality:check`
- [x] T011 更新 `tdd-audit-report.md` 與剩餘批次快照
