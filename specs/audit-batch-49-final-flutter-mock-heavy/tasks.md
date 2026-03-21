> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 49 Flutter 最後一組 mock-heavy 清理

**Input**: Design documents from `specs/audit-batch-49-final-flutter-mock-heavy/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 11 支 Flutter mock-heavy 單檔測試

## Phase 2: Foundational

- [x] T002 [P] 盤點既有 `test/support/fakes/*`、page harness 與 network fake 可重用的替身
- [x] T003 [P] 先跑 red，確認移除 mock framework 後的依賴缺口

## Phase 3: User Story 1 - 清空 Flutter 剩餘 mock-heavy 測試 (Priority: P1)

**Goal**: 讓 Flutter 測試樹最後 11 支 mock-heavy 單檔改由 hand-written fake / recorder / harness 驅動

**Independent Test**: batch 49 targeted tests、Flutter 全量搜尋驗證、`flutter analyze --fatal-infos` 與 `flutter test` 通過

- [x] T004 [US1] 改寫 `voiceover_nav_test.dart`、`api_client_cooldown_test.dart`、`api_client_test.dart`
- [x] T005 [US1] 改寫 `metrics_service_cache_test.dart`、`email_repository_test.dart`
- [x] T006 [US1] 改寫 `ai_reply_suggestions_page_test.dart`、`ai_summary_page_test.dart`
- [x] T007 [US1] 改寫 `automation_page_impl_test.dart`、`templates_page_impl_dialog_test.dart`、`templates_page_test.dart`
- [x] T008 [US1] 改寫 `message_banner_streaming_test.dart`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T009 執行 batch 49 targeted tests、Flutter 全量搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T010 執行 Flutter 全量 `flutter test`
- [x] T011 更新 `tdd-audit-report.md` 與剩餘批次快照
