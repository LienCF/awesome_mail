> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Tasks: 批次 7 跨堆疊品質閘修復

**Input**: Design documents from `specs/audit-batch-7-cross-stack-quality-gates/`
**Prerequisites**: `plan.md`, `spec.md`

## Phase 1: Setup

- [x] T001 整理目前審計結果並確認本批次只處理品質閘與直接 debug log 問題

## Phase 2: Foundational

- [x] T002 [P] 以 Prettier 修正 `awesome-mail/src/routes/ai.ts`、`awesome-mail/src/services/ai-provider-mock.ts`、`awesome-mail/src/services/ai-provider-openrouter.ts`、`awesome-mail/src/services/ai-provider-types.ts`、`awesome-mail/src/services/ai-service.ts`
- [x] T003 [P] 修正 `awesome_mail_flutter/test/unit/data/providers/foundation/guided_engine_base_test.dart` 與 `awesome_mail_flutter/test/unit/data/providers/foundation/guided_session_test.dart` 的 tearoff lint

## Phase 3: User Story 1 - 維護者可重新取得綠燈品質閘 (Priority: P1)

**Goal**: 讓 backend `quality:check` 與 Flutter `analyze` 回到綠燈

**Independent Test**: 執行 `npm run quality:check` 與 `flutter analyze`

- [x] T004 [US1] 驗證 `awesome-mail` 的 `npm run quality:check`
- [x] T005 [US1] 驗證 `awesome_mail_flutter` 的 `flutter analyze`

## Phase 4: User Story 2 - 郵件 WebView 不再輸出直接 debug log (Priority: P2)

**Goal**: 移除 `EmailScrollableWebView` HTML 文件中的 `console.log`，並補齊回歸測試

**Independent Test**: `awesome_mail_flutter/test/widget/email_scrollable_webview_test.dart` 能驗證 HTML 文件內容

- [x] T006 [US2] 先在 `awesome_mail_flutter/test/widget/email_scrollable_webview_test.dart` 補上 HTML 文件回歸測試
- [x] T007 [US2] 在 `awesome_mail_flutter/lib/presentation/widgets/email/email_scrollable_webview.dart` 抽出可測試的 HTML builder 並移除 `console.log`
- [x] T008 [US2] 執行 `flutter test test/widget/email_scrollable_webview_test.dart`

## Phase 5: User Story 3 - 審計結果可分批執行 (Priority: P3)

**Goal**: 更新審計報告，標出已完成批次與待處理批次

**Independent Test**: `tdd-audit-report.md` 能清楚區分本批次完成項目與下一批建議

- [x] T009 [US3] 更新 `tdd-audit-report.md`，加入本批次完成結果與下一批建議

## Phase 6: Polish & Cross-Cutting Concerns

- [x] T010 執行本批次所有相關驗證並整理結果
