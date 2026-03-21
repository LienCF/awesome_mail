> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 58 backend repositories fake 收斂

**Input**: Design documents from `specs/audit-batch-58-backend-repositories-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 58 納入的 repository 測試範圍與依賴

## Phase 2: Foundational

- [x] T002 [P] 建立 repositories 共用 hand-written D1 / KV fake

## Phase 3: User Story 1 - 清理 repositories mock-heavy 測試 (Priority: P1)

**Goal**: 讓 repository 測試改由 hand-written persistence fake 與真實資料狀態驗證驅動**

**Independent Test**: batch 58 targeted tests 與 `npm run quality:check` 通過

- [x] T003 [US1] 改寫 `oauth-provider-repository.test.ts` 與 `oauth-provider-repository-coverage.test.ts`
- [x] T004 [US1] 改寫 `user-repository.test.ts` 與 `user-repository-coverage.test.ts`
- [x] T005 [US1] 改寫 `subscription-repository.test.ts`
- [x] T006 [US1] 改寫 `sync-repository.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 執行 batch 58 targeted tests
- [x] T008 執行 `awesome-mail` `npm run quality:check`
- [x] T009 更新 `tdd-audit-report.md` 與剩餘批次快照
