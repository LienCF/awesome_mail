> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 53 backend route env fake 基礎收斂

**Input**: Design documents from `specs/audit-batch-53-backend-route-env-fakes/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 batch 53 納入的 4 支 backend unit route 測試與共用 helper 範圍

## Phase 2: Foundational

- [x] T002 [P] 建立 route 測試可共用的 hand-written Env / KV / D1 / DO fake
- [x] T003 [P] 建立共用 route app / JWT / auth user setup 工具

## Phase 3: User Story 1 - 清理小型 route mock-heavy 測試 (Priority: P1)

**Goal**: 讓小型 route 測試改由真實 JWT 與 hand-written Env fake 驅動

**Independent Test**: batch 53 targeted tests 與 `npm run quality:check` 通過

- [x] T004 [US1] 改寫 `metrics.test.ts`
- [x] T005 [US1] 改寫 `logs.test.ts`
- [x] T006 [US1] 改寫 `integrations.test.ts`
- [x] T007 [US1] 改寫 `accounts.test.ts`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T008 執行 batch 53 targeted tests
- [x] T009 執行 `awesome-mail` `npm run quality:check`
- [x] T010 更新 `tdd-audit-report.md` 與剩餘批次快照
