> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 57 backend middleware fake 收斂

**Input**: Design documents from `specs/audit-batch-57-backend-middleware-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 57 納入的 middleware 測試範圍與依賴

## Phase 2: Foundational

- [x] T002 [P] 建立 middleware 共用 hand-written fake / recorder

## Phase 3: User Story 1 - 清理 middleware mock-heavy 測試 (Priority: P1)

**Goal**: 讓 middleware 測試改由真 request/response、真 JWT 與 hand-written fake 驅動**

**Independent Test**: batch 57 targeted tests 與 `npm run quality:check` 通過

- [x] T003 [US1] 改寫 `auth.test.ts`
- [x] T004 [US1] 改寫 `auth-coverage.test.ts`、`auth-coverage2.test.ts`、`auth-coverage3.test.ts`
- [x] T005 [US1] 改寫 `error-handler.test.ts`、`error-handler-coverage.test.ts`、`error-handler-coverage2.test.ts`
- [x] T006 [US1] 改寫 `rate-limit-coverage2.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 執行 batch 57 targeted tests
- [x] T008 執行 `awesome-mail` `npm run quality:check`
- [x] T009 更新 `tdd-audit-report.md` 與剩餘批次快照
