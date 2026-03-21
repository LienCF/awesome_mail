> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 59 backend integration fake 收斂

**Input**: Design documents from `specs/audit-batch-59-backend-integration-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 59 納入的 integration 測試範圍與相依服務

## Phase 2: Foundational

- [x] T002 [P] 建立 integration 共用 hand-written env / D1 / KV / service fake

## Phase 3: User Story 1 - 清理 integration mock-heavy 測試 (Priority: P1)

**Goal**: 讓 integration 測試改由真實 request flow 與 hand-written infra fake 驅動**

**Independent Test**: batch 59 targeted tests 與 `npm run quality:check` 通過

- [x] T003 [US1] 改寫 `auth.test.ts`、`accounts.test.ts`、`sync.test.ts`
- [x] T004 [US1] 改寫 `subscriptions.test.ts` 與 `subscriptions-simple.test.ts`
- [x] T005 [US1] 改寫 `ai.test.ts`、`ai-mock-api.test.ts`、`ai-real-api.test.ts`
- [x] T006 [US1] 改寫 `cron-jobs.test.ts` 與 `oauth-comprehensive.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 執行 batch 59 targeted tests
- [x] T008 執行 `awesome-mail` `npm run quality:check`
- [x] T009 更新 `tdd-audit-report.md` 與剩餘批次快照
