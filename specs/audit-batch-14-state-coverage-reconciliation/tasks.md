> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 14 state coverage 對齊與缺測修補

**Input**: Design documents from `specs/audit-batch-14-state-coverage-reconciliation/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認 6 個 state / event 候選檔的真實 coverage 狀態，區分 5 個假陽性與 1 個直接缺測

## Phase 2: Foundational

- [x] T002 [P] 先執行 `mailbox_chip_state_test.dart` 的 red 驗證，確認目前缺少直接測試

## Phase 3: User Story 1 - state 缺測清單與真實 coverage 對齊 (Priority: P1)

**Goal**: 讓審計報告只保留真正沒有 coverage 的 Flutter 檔案

**Independent Test**: `tdd-audit-report.md` 不再將 5 個已覆蓋 state / event 檔列為缺測

- [x] T003 [US1] 更新 `tdd-audit-report.md`，移除 5 個 state / event 假陽性並下修 Flutter 缺測數

## Phase 4: User Story 2 - MailboxChipState 直接測試 (Priority: P1)

**Goal**: 讓 `MailboxChipState` 的 getter / copyWith / equality 由直接單元測試保護

**Independent Test**: `mailbox_chip_state_test.dart` 通過

- [x] T004 [US2] 新增 `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_chip_state_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T005 更新 batch 14 `tasks.md` 狀態
- [x] T006 執行 targeted tests、`flutter analyze --fatal-infos` 與全量 `flutter test`
