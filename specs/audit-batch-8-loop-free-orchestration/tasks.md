> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 8 迴圈與輪詢控制流清理

**Input**: Design documents from `specs/audit-batch-8-loop-free-orchestration/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 整理 10 個 `while`/polling 候選檔案並確認本批次全部納入

## Phase 2: Foundational

- [x] T002 [P] 補 `AiTaskQueueService` idle 喚醒與延後任務的回歸測試
- [x] T003 [P] 補通知 APNS token 重試與 Gmail rate limit retry 的 helper 測試

## Phase 3: User Story 1 - 移除有界重試與分頁中的 `while` 控制流 (Priority: P1)

**Goal**: 讓 backend / Flutter 核心重試、串流、分頁流程不再依賴 `while` 控制流

**Independent Test**: request guard、Gmail remote service、notification service、full content download、POP3 handler 與 Foundation provider 相關測試通過

- [x] T004 [US1] 改寫 `awesome-mail/src/middleware/request-guard.ts`
- [x] T005 [US1] 改寫 `awesome_mail_flutter/lib/core/notifications/notification_service.dart`
- [x] T006 [US1] 改寫 `awesome_mail_flutter/lib/data/services/gmail_remote_service.dart`
- [x] T007 [US1] 改寫 `awesome_mail_flutter/lib/data/services/full_content_download_service.dart`
- [x] T008 [US1] 改寫 `awesome_mail_flutter/lib/data/protocols/pop3/pop3_handler.dart`
- [x] T009 [US1] 改寫 `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_core.dart`

## Phase 4: User Story 2 - 移除背景工作中的 polling 迴圈 (Priority: P1)

**Goal**: 讓 AI 任務佇列與 mailbox 同步流程不再靠 `while` + delay/polling 持續驅動

**Independent Test**: AI queue 與 mailbox 相關測試通過，新增任務與延後任務仍可準時執行

- [x] T010 [US2] 改寫 `awesome_mail_flutter/lib/data/services/ai_task_queue_service.dart` 的分頁與背景處理器
- [x] T011 [US2] 改寫 `awesome_mail_flutter/lib/presentation/blocs/mailbox/mailbox_bloc.dart`
- [x] T012 [US2] 改寫 `awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_sync_handlers.dart`

## Phase 5: User Story 3 - 審計結果可持續往下推進 (Priority: P2)

**Goal**: 更新審計報告，反映本批次已移除的 `while`/polling 類違規

**Independent Test**: `tdd-audit-report.md` 清楚列出本批次完成檔案與剩餘問題

- [x] T013 [US3] 更新 `tdd-audit-report.md`，同步批次 8 完成情況與剩餘清單

## Phase 6: Polish & Cross-Cutting Concerns

- [ ] T014 執行 backend 品質檢查、Flutter analyze、變更相關測試與 Flutter 全量測試
