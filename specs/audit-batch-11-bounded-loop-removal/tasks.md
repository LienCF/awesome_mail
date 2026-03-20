> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 11 有界迴圈與遍歷清理

**Input**: Design documents from `specs/audit-batch-11-bounded-loop-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次列入的 10 個檔案與 12 個 `while` 出現點

## Phase 2: Foundational

- [x] T002 [P] 補快取淘汰與歷史截斷行為測試
- [x] T003 [P] 補字串掃描、結構遍歷與 mock provider 抽取行為測試

## Phase 3: User Story 1 - 快取與歷史清理不再使用 `while` (Priority: P1)

**Goal**: 讓有界集合淘汰與截斷行為改成更直接的控制流

**Independent Test**: 相關 service / utility 測試通過

- [x] T004 [US1] 改寫 `awesome_mail_flutter/lib/shared/widgets/performance/image_cache.dart`
- [x] T005 [US1] 改寫 `awesome_mail_flutter/lib/data/services/batch_operations/batch_operation_service.dart`
- [x] T006 [US1] 改寫 `awesome_mail_flutter/lib/data/cache/cache_manager.dart`

## Phase 4: User Story 2 - 遍歷與清理不再使用 `while` (Priority: P1)

**Goal**: 讓 DOM / Widget / HTML 結構遍歷改成遞迴或 `for` 迭代

**Independent Test**: 相關 widget / provider 測試通過

- [x] T007 [US2] 改寫 `awesome_mail_flutter/lib/presentation/widgets/email/email_minimal_webview.dart`
- [x] T008 [US2] 改寫 `awesome_mail_flutter/lib/core/utils/overflow_debugger.dart`
- [x] T009 [US2] 改寫 `awesome_mail_flutter/lib/data/providers/foundation/structured_element_detector.dart`
- [x] T010 [US2] 改寫 `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_sanitizer.dart`

## Phase 5: User Story 3 - 字串掃描與 mock provider 不再使用 `while` (Priority: P1)

**Goal**: 讓字串切片、壞尾修剪與 regex 掃描用更清楚的非 `while` 流程表示

**Independent Test**: foundation provider 與 backend mock provider 測試通過

- [x] T011 [US3] 改寫 `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_summary.dart`
- [x] T012 [US3] 改寫 `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_core.dart`
- [x] T013 [US3] 改寫 `awesome-mail/src/services/ai-provider-mock.ts`

## Phase 6: Polish & Cross-Cutting Concerns

- [x] T014 更新 `tdd-audit-report.md` 與剩餘 `while` 類清單
- [ ] T015 執行 backend 品質檢查、Flutter analyze、變更相關測試與全量回歸
