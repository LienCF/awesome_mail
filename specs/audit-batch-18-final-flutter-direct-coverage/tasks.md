> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 18 Flutter 最後直接缺測收尾

**Input**: Design documents from `specs/audit-batch-18-final-flutter-direct-coverage/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認剩餘 9 個 Flutter 缺測檔案與對應測試策略
- [x] T002 以紅燈方式執行 4 個新測試檔路徑，確認目前尚未存在

## Phase 2: User Story 1 - Flutter 最後直接缺測檔案可被最小但真實的測試驗證 (Priority: P1)

**Goal**: 讓剩餘 9 個 Flutter 缺測檔案都有直接測試，並使 Flutter 缺測清單歸零**

**Independent Test**: 本批次 4 個新測試檔通過，且 `tdd-audit-report.md` 不再列出這 9 個 Flutter 檔案

- [x] T003 [US1] 新增 `test/widget/shared/widgets/maybe_selection_area_test.dart`
- [x] T004 [US1] 新增 `test/widget/presentation/widgets/adaptive/adaptive_widgets_test.dart`
- [x] T005 [US1] 新增 `test/widget/presentation/pages/debug/debug_pages_test.dart`
- [x] T006 [US1] 新增 `test/widget/core/routing/app_router_test.dart`
- [x] T007 [US1] 執行本批次 Flutter 測試並確認全部通過
- [x] T008 [US1] 更新 `tdd-audit-report.md`，移除 9 個 Flutter 真缺測並將剩餘數下修到 0

## Phase 3: Polish & Cross-Cutting Concerns

- [x] T009 執行 `flutter analyze --fatal-infos`
- [x] T010 更新 batch 18 `tasks.md` 狀態
