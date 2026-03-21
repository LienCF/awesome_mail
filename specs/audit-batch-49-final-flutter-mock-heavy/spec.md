# Spec: 批次 49 Flutter 最後一組 mock-heavy 清理

## 背景

batch 48 關帳後，Flutter 測試樹只剩 11 支 mock-heavy 檔案，分散在 `a11y`、`core/network`、`data/services`、`presentation`、`unit/domain` 與 `widget`。這是 Flutter 端最後一組 Detroit School mock 濫用，主要來自 `mocktail`、`mockito`、`@GenerateMocks`、`extends Mock` 與舊式 generated mocks。

## 目標

1. 將下列 11 支測試改成不依賴 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit` 或 `.mocks.dart`
   - `awesome_mail_flutter/test/a11y/voiceover_nav_test.dart`
   - `awesome_mail_flutter/test/core/network/api_client_cooldown_test.dart`
   - `awesome_mail_flutter/test/core/network/api_client_test.dart`
   - `awesome_mail_flutter/test/data/services/metrics_service_cache_test.dart`
   - `awesome_mail_flutter/test/presentation/ai/ai_reply_suggestions_page_test.dart`
   - `awesome_mail_flutter/test/presentation/ai/ai_summary_page_test.dart`
   - `awesome_mail_flutter/test/presentation/pages/automation/automation_page_impl_test.dart`
   - `awesome_mail_flutter/test/presentation/pages/templates/templates_page_impl_dialog_test.dart`
   - `awesome_mail_flutter/test/presentation/templates/templates_page_test.dart`
   - `awesome_mail_flutter/test/unit/domain/repositories/email_repository_test.dart`
   - `awesome_mail_flutter/test/widget/widgets/email/reading_pane/message_banner_streaming_test.dart`
2. 優先重用既有 `test/support/fakes/*` 與既有 page/widget harness，僅在必要時補最小 hand-written fake / recorder
3. 保留各測試對 UI 行為、網路互動、快取策略、語音導覽與資料存取邏輯的驗證力
4. 清空 Flutter 測試樹的 mock-heavy 關鍵字掃描結果，讓後續只剩 backend 批次

## 非目標

- 不修改 production 行為，除非改寫測試過程揭露真實缺陷且必須先補回歸測試
- 不擴大到 backend `awesome-mail/tests/*`
- 不處理 Flutter integration test runner 的既有限制

## 驗收條件

- 上述 11 支測試不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit`、`.mocks.dart`
- `rg -l 'mocktail|mockito|@GenerateMocks|extends Mock|\\.mocks\\.dart|MockBloc|MockCubit' awesome_mail_flutter/test -g '*.dart'` 回傳 0 個結果
- batch 49 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos` 全部通過
- `flutter test` 全量通過
- `tdd-audit-report.md` 更新本批次結果，並將 Flutter mock-heavy 剩餘數更新為 0
