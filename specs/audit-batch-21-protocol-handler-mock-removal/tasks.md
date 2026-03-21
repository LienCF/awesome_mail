> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 21 protocol handler mock 清理

**Input**: Design documents from `specs/audit-batch-21-protocol-handler-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 6 支 Flutter protocol handler 測試與 6 個 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 先讓 `carddav_handler_test.dart`、`exchange_handler_test.dart`、`jmap_handler_test.dart` 切到手寫 fake 介面並製造 red，確認移除 generated mocks 後仍能描述相同行為

## Phase 3: User Story 1 - protocol handler 測試改用手寫測試替身 (Priority: P1)

**Goal**: 讓 CardDAV / Exchange / JMAP handler 測試改以手寫 fake client 驅動

**Independent Test**: 3 支 handler 測試通過，且不再 import `mockito` 或對應 `.mocks.dart`

- [x] T003 [US1] 以手寫 fake 改寫 `carddav_handler_test.dart`
- [x] T004 [US1] 以手寫 fake 改寫 `exchange_handler_test.dart`
- [x] T005 [US1] 以手寫 fake 改寫 `jmap_handler_test.dart`

## Phase 4: User Story 2 - 清除未使用 socket generated mocks (Priority: P1)

**Goal**: 讓 IMAP / POP3 / SMTP handler 測試移除未使用的 mock framework 依賴

**Independent Test**: 3 支 handler 測試通過，且不再出現 `@GenerateMocks` 或 `.mocks.dart` 依賴

- [x] T006 [US2] 清理 `imap_handler_test.dart`
- [x] T007 [US2] 清理 `pop3_handler_test.dart`
- [x] T008 [US2] 清理 `smtp_handler_test.dart`
- [x] T009 [US2] 刪除 6 個對應 generated `.mocks.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T010 執行本批次 6 支測試、`flutter analyze --fatal-infos` 與搜尋驗證
- [x] T011 更新 `tdd-audit-report.md` 與 batch 21 `tasks.md`
