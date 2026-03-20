> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 20 HTTP client mock 收尾

**Input**: Design documents from `specs/audit-batch-20-http-client-mock-closure/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 確認本批次納入的 10 支 Flutter HTTP client mock-heavy 測試

## Phase 2: Foundational

- [x] T002 [P] 先以共用 HTTP 測試替身對一組協定層與一組 service / provider 測試做 red，確認移除 mock framework 後仍能驗證 request 行為

## Phase 3: User Story 1 - 剩餘 HTTP 類測試改用共用 HTTP 測試替身 (Priority: P1)

**Goal**: 讓所有剩餘直接 mock `http.Client` 的 Flutter 測試改以共用 HTTP 測試替身驅動

**Independent Test**: 10 支 batch 20 測試通過，且 `rg` 不再找到 `@GenerateMocks([http.Client])` 或 `MockHttpClient extends Mock implements http.Client`

- [x] T003 [US1] 改寫 CalDAV / CardDAV / JMAP / EWS 協定層測試
- [x] T004 [US1] 改寫 AccountConfigService / RemoteConfigService / UpdateService 測試
- [x] T005 [US1] 改寫 Outlook / Todoist / Notion provider 測試
- [x] T006 [US1] 刪除對應的 generated `.mocks.dart`

## Phase 4: User Story 2 - 批次 9 關帳 (Priority: P1)

**Goal**: 更新審計報告，移除最後一個待處理批次

**Independent Test**: `tdd-audit-report.md` 顯示已無待處理批次

- [x] T007 [US2] 更新 `tdd-audit-report.md`，記錄 batch 20 完成與 batch 9 關帳
- [x] T008 [US2] 更新 batch 20 `tasks.md` 勾選完成狀態

## Phase 5: Polish & Cross-Cutting Concerns

- [x] T009 執行 batch 20 相關測試、`flutter analyze --fatal-infos`、全量 `flutter test` 與最後的搜尋驗證
