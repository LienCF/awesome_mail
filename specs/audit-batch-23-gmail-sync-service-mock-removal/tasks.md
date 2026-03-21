> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 23 Gmail / sync data services mock 清理

**Input**: Design documents from `specs/audit-batch-23-gmail-sync-service-mock-removal/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 Gmail / sync 服務測試 `12` 檔與對應 generated `.mocks.dart`

## Phase 2: Foundational

- [x] T002 [P] 先對 `gmail_remote_service_test.dart` 做 red，建立不依賴 mock framework 的 HTTP / token / refresh fake
- [x] T003 [P] 建立 Gmail / sync service 共用測試替身，供 remote service 家族與 sync orchestration 測試共用

## Phase 3: User Story 1 - Gmail remote service 家族改用手寫 fake (Priority: P1)

**Goal**: 讓 Gmail remote service 與附件相關測試改以共用手寫 fake 驅動

**Independent Test**: Gmail remote service 家族 targeted tests 通過，且不再依賴 generated mocks

- [x] T004 [US1] 改寫 `gmail_remote_service_test.dart`
- [x] T005 [US1] 改寫 `gmail_remote_service_label_test.dart`
- [x] T006 [US1] 改寫 `gmail_remote_service_message_test.dart`
- [x] T007 [US1] 改寫 `gmail_remote_service_parser_test.dart`
- [x] T008 [US1] 改寫 `gmail_remote_service_sync_test.dart`
- [x] T009 [US1] 改寫 `gmail_attachment_parser_test.dart`
- [x] T010 [US1] 改寫 `gmail_attachment_download_test.dart`

## Phase 4: User Story 2 - sync / coordination 類服務改用手寫 fake (Priority: P1)

**Goal**: 讓 Gmail sync / orchestration 類服務測試改以手寫 fake / in-memory 物件驅動

**Independent Test**: sync / coordination targeted tests 通過，且不再出現 `mockito` 或 `mocktail Mock`

- [x] T011 [US2] 改寫 `all_mail_sync_service_test.dart`
- [x] T012 [US2] 改寫 `full_content_download_service_test.dart`
- [x] T013 [US2] 改寫 `email_sync_service_test.dart`
- [x] T014 [US2] 改寫 `attachment_download_manager_test.dart`
- [x] T015 [US2] 改寫 `email_cache_coordinator_test.dart`

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T016 刪除 batch 23 對應 generated `.mocks.dart`
- [x] T017 執行 batch 23 相關測試、搜尋驗證與 `flutter analyze --fatal-infos`
- [x] T018 更新 `tdd-audit-report.md` 與 batch 23 `tasks.md`
