> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 61 Flutter 最終 mock framework 歸零

**Input**: Design documents from `specs/audit-batch-61-flutter-final-mock-framework-zero/`
**Prerequisites**: `spec.md`

## Phase 1: Setup

- [x] T001 確認 package mock factory、auth integration 與 dev dependency 為本批次最後殘留範圍

## Phase 2: Foundational

- [x] T002 [P] 將 `foundation_models_framework` 的測試入口收斂為 `forTesting()`，移除 `testing.dart`

## Phase 3: User Story 1 - 清空 Flutter 最後 mock framework 足跡 (Priority: P1)

**Goal**: 讓 package 與整合測試改由 hand-written fake / 顯式 testing factory 驅動，不再依賴外部 mock framework

**Independent Test**: package targeted tests 與 auth flow integration test 通過

- [x] T003 [US1] 改寫 `packages/foundation_models_framework/test/foundation_models_framework_test.dart`
- [x] T004 [US1] 改寫 `integration_test/auth_flow_integration_test.dart`
- [x] T005 [US1] 刪除 `awesome_mail_flutter/pubspec.yaml` 中不再需要的 `mockito`、`mocktail`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T006 執行 package targeted tests 與 `integration_test/auth_flow_integration_test.dart`
- [x] T007 執行搜尋驗證，確認 mock framework 實際使用與 `.mocks.dart` 均為 0
- [x] T008 執行 `flutter analyze --fatal-infos` 與全量 `flutter test`
- [x] T009 更新 `tdd-audit-report.md` 與本批次任務狀態
