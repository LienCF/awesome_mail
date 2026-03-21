> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 51 backend service fetch / OAuth fake 收斂

**Input**: Design documents from `specs/audit-batch-51-backend-service-fetch-oauth/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 51 納入的 13 支 backend unit service 測試與共用 helper 範圍

## Phase 2: Foundational

- [x] T002 [P] 建立 hand-written fetch recorder，支援 queue 與 calls 驗證
- [x] T003 [P] 建立 AI provider / OAuth 測試所需的 fake helper，取代 `vi.fn()` 與 `.mock.calls`

## Phase 3: User Story 1 - 清理 fetch / OAuth service mock-heavy 測試 (Priority: P1)

**Goal**: 讓 fetch / OAuth 類 service 測試改由 hand-written fetch fake、真實 crypto 與真實 service 協調邏輯驅動

**Independent Test**: batch 51 targeted tests 與 `npm run quality:check` 通過

- [x] T004 [US1] 改寫 `ai-provider-anthropic.test.ts`、`ai-provider-openai.test.ts`、`ai-provider-openrouter.test.ts`
- [x] T005 [US1] 改寫 `ai-service.test.ts`
- [x] T006 [US1] 改寫 `apple-client-secret-service.test.ts`
- [x] T007 [US1] 改寫 `apple-oauth-service.test.ts`、`google-oauth-service.test.ts`
- [x] T008 [US1] 改寫 `oauth-exchange-apple.test.ts`、`oauth-exchange-coverage.test.ts`、`oauth-exchange-google.test.ts`、`oauth-exchange-outlook.test.ts`
- [x] T009 [US1] 改寫 `oauth-refresh-service.test.ts`、`oauth-validation-service.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T010 執行 batch 51 targeted tests
- [x] T011 執行 `awesome-mail` `npm run quality:check`
- [x] T012 更新 `tdd-audit-report.md` 與剩餘批次快照
