> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 55 backend route auth / oauth / ai fake 收斂

**Input**: Design documents from `specs/audit-batch-55-backend-route-auth-oauth-ai/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 55 納入的 3 支 backend route 測試與 helper 延伸範圍

## Phase 2: Foundational

- [x] T002 [P] 延伸 route / fetch helper，支援 auth / oauth / ai 路由需要的 D1 / KV / DO / fetch 狀態驗證
- [x] T003 [P] 建立 auth / oauth / ai 共用測試資料與授權 setup 工具

## Phase 3: User Story 1 - 清理最後 3 支 route mock-heavy 測試 (Priority: P1)

**Goal**: 讓大型 route 測試改由真實 JWT 與 hand-written fake 驅動

**Independent Test**: batch 55 targeted tests 與 `npm run quality:check` 通過

- [x] T004 [US1] 改寫 `oauth.test.ts`
- [x] T005 [US1] 改寫 `auth.test.ts`
- [x] T006 [US1] 改寫 `ai.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T007 執行 batch 55 targeted tests
- [x] T008 執行 `awesome-mail` `npm run quality:check`
- [x] T009 更新 `tdd-audit-report.md` 與剩餘批次快照
