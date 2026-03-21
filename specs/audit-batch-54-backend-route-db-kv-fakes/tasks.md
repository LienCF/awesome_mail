> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 54 backend route DB / KV fake 延伸收斂

**Input**: Design documents from `specs/audit-batch-54-backend-route-db-kv-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 54 納入的 4 支 backend unit route 測試與 helper 延伸範圍

## Phase 2: Foundational

- [x] T002 [P] 延伸 route helper，支援 email / subscription / sync 類 DB / KV state 驗證
- [x] T003 [P] 建立 subscription / sync 所需的共用測試資料與 auth setup 工具

## Phase 3: User Story 1 - 清理 DB / KV route mock-heavy 測試 (Priority: P1)

**Goal**: 讓 route 測試改由真實 JWT 與 hand-written DB / KV fake 驅動

**Independent Test**: batch 54 targeted tests 與 `npm run quality:check` 通過

- [x] T004 [US1] 改寫 `emails.test.ts`
- [x] T005 [US1] 改寫 `subscriptions-coverage.test.ts`
- [x] T006 [US1] 改寫 `subscriptions.test.ts`
- [x] T007 [US1] 改寫 `sync.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T008 執行 batch 54 targeted tests
- [x] T009 執行 `awesome-mail` `npm run quality:check`
- [x] T010 更新 `tdd-audit-report.md` 與剩餘批次快照
