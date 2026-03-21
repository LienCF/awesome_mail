> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 52 backend AuthService fake 收斂

**Input**: Design documents from `specs/audit-batch-52-backend-auth-service-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 52 納入的 5 支 backend unit service 測試與共用 helper 範圍

## Phase 2: Foundational

- [x] T002 [P] 建立 AuthService 所需的 hand-written repository fake 與 helper
- [x] T003 [P] 建立 OAuth flow / token 產生 / profile 驗證共用測試工具

## Phase 3: User Story 1 - 清理 AuthService mock-heavy 測試 (Priority: P1)

**Goal**: 讓 AuthService 類測試改由真實 JWT、真實密碼雜湊與 hand-written repository fake 驅動

**Independent Test**: batch 52 targeted tests 與 `npm run quality:check` 通過

- [x] T004 [US1] 改寫 `auth-service.test.ts`
- [x] T005 [US1] 改寫 `auth-service-coverage.test.ts`
- [x] T006 [US1] 改寫 `auth-service-oauth.test.ts`
- [x] T007 [US1] 改寫 `oauth-edge-cases.test.ts`、`oauth-security.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T008 執行 batch 52 targeted tests
- [x] T009 執行 `awesome-mail` `npm run quality:check`
- [x] T010 更新 `tdd-audit-report.md` 與剩餘批次快照
