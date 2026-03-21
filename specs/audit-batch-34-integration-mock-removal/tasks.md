> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 34 integration mock 清理

**Input**: Design documents from `specs/audit-batch-34-integration-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 integration 測試 `4` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 建立 integration 共用 fake：OAuth storage、offline queue 依賴、sync state recorder
- [x] T003 [P] 對 `subscription_flow_integration_test.dart` 或 `oauth_migration_integration_test.dart` 做 red，確認 fake 缺口

## Phase 3: User Story 1 - subscription 與 oauth integration flow 改用手寫 fake (Priority: P1)

**Goal**: 讓 subscription 與 OAuth integration flow 改以 hand-written fake 驅動

**Independent Test**: 相關 targeted tests 通過，且不再依賴 generated mocks 或 mock framework

- [x] T004 [US1] 改寫 `subscription_flow_integration_test.dart`
- [x] T005 [US1] 改寫 `oauth_migration_integration_test.dart`

## Phase 4: User Story 2 - offline queue 與 full sync integration 測試改用 in-memory fake (Priority: P1)

**Goal**: 讓 offline queue / full sync integration 測試改以 hand-written fake / in-memory 依賴驅動

**Independent Test**: 相關 targeted tests 通過，且 batch 34 檔案已無 `mockito`、`mocktail`

- [x] T006 [US2] 改寫 `offline_mode_test.dart`
- [x] T007 [US2] 改寫 `full_sync_flow_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T008 刪除 batch 34 對應 generated `.mocks.dart`
- [x] T009 執行 batch 34 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T010 更新 `tdd-audit-report.md` 與 batch 34 `tasks.md`
