> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 50 backend service D1/KV fake 基礎收斂

**Input**: Design documents from `specs/audit-batch-50-backend-service-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 50 納入的 10 支 backend unit service 測試與共用 helper 範圍

## Phase 2: Foundational

- [x] T002 [P] 以 hand-written recorder 重寫 `tests/helpers/mock-d1.ts`
- [x] T003 [P] 建立 service 測試需要的 subclass / fake helper，取代 `spyOn()` 與 mock queue API

## Phase 3: User Story 1 - 清理 D1/KV service mock-heavy 測試 (Priority: P1)

**Goal**: 讓第一批 backend service 測試改由 hand-written D1/KV fake 與 recorder 驅動

**Independent Test**: batch 50 targeted tests 與 `npm run quality:check` 通過

- [x] T004 [US1] 改寫 `ai-cache-coverage.test.ts`、`ai-cache.test.ts`、`token-vault.test.ts`
- [x] T005 [US1] 改寫 `ai-usage-tracker-coverage.test.ts`、`ai-usage-tracker.test.ts`
- [x] T006 [US1] 改寫 `sync-service-coverage.test.ts`、`sync-service.test.ts`
- [x] T007 [US1] 改寫 `usage-tracker.test.ts`、`user-service.test.ts`
- [x] T008 [US1] 改寫 `subscription-service.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T009 執行 batch 50 targeted tests
- [x] T010 執行 `awesome-mail` `npm run quality:check`
- [x] T011 更新 `tdd-audit-report.md` 與剩餘批次快照
