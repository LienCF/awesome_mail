> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 47 legacy 測試基礎設施 mock 清理

**Input**: Design documents from `specs/audit-batch-47-legacy-test-support-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 6 個 legacy 測試基礎設施 / 直接依賴檔案

## Phase 2: Foundational

- [x] T002 [P] 建立 legacy 測試基礎設施所需的 hand-written fake / recorder
- [x] T003 [P] 先跑 red，確認 batch 47 改寫時的依賴缺口

## Phase 3: User Story 1 - legacy 測試基礎設施改用 hand-written fake (Priority: P1)

**Goal**: 讓 legacy 測試基礎設施與直接依賴它的 home/router 測試改由 hand-written fake 或 recorder 驅動

**Independent Test**: batch 47 targeted tests 與 home regression tests 通過，且不再依賴 mock framework

- [x] T004 [US1] 改寫 `mock_services.dart` 與 `mock_attachment_cubit.dart`
- [x] T005 [US1] 改寫 `test_app_shell.dart` 與 `test_helpers.dart`
- [x] T006 [US1] 改寫 `app_router_test.dart`
- [x] T007 [US1] 改寫 `macos_home_page_ai_test.dart`

## Phase 4: Polish & Cross-Cutting Concerns

- [x] T008 執行 batch 47 targeted tests、home regression tests、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T009 更新 `tdd-audit-report.md` 與剩餘批次快照
