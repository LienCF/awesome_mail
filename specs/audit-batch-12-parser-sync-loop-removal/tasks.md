> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 12 parser / sync / pagination 控制流清理

**Input**: Design documents from `specs/audit-batch-12-parser-sync-loop-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認剩餘 4 個檔案與 13 個 `while` / `do-while` 出現點

## Phase 2: Foundational

- [x] T002 [P] 補 IMAP parser 巢狀結構與地址清單解析測試
- [x] T003 [P] 補 retry / pagination / partial failure 測試

## Phase 3: User Story 1 - Parser 狀態機不再使用 `while` (Priority: P1)

**Goal**: 讓 IMAP parser 的索引前進與巢狀解析改成顯式 helper

**Independent Test**: `imap_response_parser` 相關測試通過

- [x] T004 [US1] 改寫 `awesome_mail_flutter/lib/data/protocols/imap/imap_response_parser.dart`

## Phase 4: User Story 2 - Retry 與 checkpoint 不再使用 `while` (Priority: P1)

**Goal**: 讓資料庫寫入重試與 backend job retry 改成更清楚的遞迴控制流

**Independent Test**: `email_synchronizer` 與 `base-job` 相關測試通過

- [x] T005 [US2] 改寫 `awesome_mail_flutter/lib/core/sync/email_synchronizer.dart`
- [x] T006 [US2] 改寫 `awesome-mail/src/jobs/base-job.ts`

## Phase 5: User Story 3 - Gmail 分頁同步不再使用 `do/while` (Priority: P1)

**Goal**: 讓 page token 驅動的同步與 reconciliation 流程改成顯式 page helper

**Independent Test**: `gmail_repository` 相關測試通過

- [x] T007 [US3] 改寫 `awesome_mail_flutter/lib/data/repositories/gmail_repository.dart`

## Phase 6: Polish & Cross-Cutting Concerns

- [x] T008 更新 `tdd-audit-report.md`，將 `while` / `do-while` 類違規歸零
- [x] T009 執行 backend 品質檢查、Flutter analyze、變更相關測試與全量回歸
