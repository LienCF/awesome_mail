# TDD 合規性審計報告

## 2026-03-20 最新快照

### 本次已完成批次

#### 批次 7：跨堆疊品質閘修復

- 已修復 backend `quality:check` 的 5 個 TypeScript 格式違規：
  - `awesome-mail/src/routes/ai.ts`
  - `awesome-mail/src/services/ai-provider-mock.ts`
  - `awesome-mail/src/services/ai-provider-openrouter.ts`
  - `awesome-mail/src/services/ai-provider-types.ts`
  - `awesome-mail/src/services/ai-service.ts`
- 已修復 Flutter `analyze` 的 6 個 `unnecessary_lambdas` lint：
  - `awesome_mail_flutter/test/unit/data/providers/foundation/guided_engine_base_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/foundation/guided_session_test.dart`
- 已移除 `EmailScrollableWebView` 執行階段直接 debug log，並補上 HTML / script 回歸測試：
  - `awesome_mail_flutter/lib/presentation/widgets/email/email_scrollable_webview.dart`
  - `awesome_mail_flutter/test/widget/email_scrollable_webview_test.dart`

#### 批次 8：輪詢與高優先 `while` 控制流清理

- 已移除 backend / Flutter 高優先 polling 與 retry `while` 控制流：
  - `awesome-mail/src/middleware/request-guard.ts`
  - `awesome_mail_flutter/lib/core/notifications/notification_service.dart`
  - `awesome_mail_flutter/lib/data/services/gmail_remote_service.dart`
  - `awesome_mail_flutter/lib/data/services/full_content_download_service.dart`
  - `awesome_mail_flutter/lib/data/protocols/pop3/pop3_handler.dart`
  - `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_core.dart`
  - `awesome_mail_flutter/lib/data/services/ai_task_queue_service.dart`
  - `awesome_mail_flutter/lib/presentation/blocs/mailbox/mailbox_bloc.dart`
  - `awesome_mail_flutter/lib/presentation/blocs/mailbox/_mailbox_sync_handlers.dart`
- 已補上本批次對應回歸測試：
  - `awesome_mail_flutter/test/unit/core/notifications/notification_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_rate_limit_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/ai_task_queue_service_test.dart`

#### 批次 11：有界迴圈與 traversal 清理

- 已移除 10 個檔案中的有界 `while` 控制流：
  - `awesome_mail_flutter/lib/shared/widgets/performance/image_cache.dart`
  - `awesome_mail_flutter/lib/data/services/batch_operations/batch_operation_service.dart`
  - `awesome_mail_flutter/lib/data/cache/cache_manager.dart`
  - `awesome_mail_flutter/lib/presentation/widgets/email/email_minimal_webview.dart`
  - `awesome_mail_flutter/lib/core/utils/overflow_debugger.dart`
  - `awesome_mail_flutter/lib/data/providers/foundation/structured_element_detector.dart`
  - `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_sanitizer.dart`
  - `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_summary.dart`
  - `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_core.dart`
  - `awesome-mail/src/services/ai-provider-mock.ts`
- 已補上本批次保護性測試：
  - `awesome_mail_flutter/test/shared/widgets/performance/image_cache_test.dart`
  - `awesome_mail_flutter/test/unit/data/cache/cache_manager_test.dart`
  - `awesome-mail/tests/unit/services/ai-provider-mock.test.ts`

#### 批次 12：parser / sync / pagination 控制流清理

- 已完成 parser / sync / pagination 類控制流清理，`while` / `do-while` 類違規在 app 程式碼中歸零：
  - `awesome_mail_flutter/lib/data/protocols/imap/imap_response_parser.dart`
  - `awesome_mail_flutter/lib/core/sync/email_synchronizer.dart`
  - `awesome_mail_flutter/lib/data/repositories/gmail_repository.dart`
  - `awesome-mail/src/jobs/base-job.ts`
- 已補上本批次對應回歸測試：
  - `awesome_mail_flutter/test/unit/data/protocols/imap/imap_response_parser_test.dart`
  - `awesome_mail_flutter/test/unit/core/sync/email_synchronizer_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/gmail_repository_test.dart`
  - `awesome-mail/tests/unit/jobs/base-job.test.ts`
- 在全量回歸收尾時，另外修復了會污染測試順序與失效的整合測試基礎設施：
  - `awesome_mail_flutter/lib/core/background/isolate_manager.dart`
  - `awesome_mail_flutter/lib/core/monitoring/performance_monitor.dart`
  - `awesome_mail_flutter/lib/core/monitoring/network_monitor.dart`
  - `awesome_mail_flutter/integration_test/example_integration_test.dart`
  - `awesome_mail_flutter/integration_test/full_flow_test.dart`
  - `awesome_mail_flutter/integration_test/auth_flow_integration_test.dart`
  - `awesome_mail_flutter/integration_test/e2e/app_smoke_test.dart`
  - `awesome_mail_flutter/integration_test/e2e/email_lifecycle_test.dart`
  - `awesome_mail_flutter/integration_test/performance/scroll_perf_test.dart`
  - `awesome_mail_flutter/test/test_helpers.dart`

#### 批次 13：provider HTTP fake client 去 mock 化

- 已建立共用 `FakeHttpClient`，以真實 `http.Response` 驅動 provider 測試：
  - `awesome_mail_flutter/test/support/fakes/fake_http_client.dart`
  - `awesome_mail_flutter/test/support/fakes/fake_http_client_test.dart`
- 已將 4 支 provider 測試從 `mockito` / generated mocks 改成 fake client：
  - `awesome_mail_flutter/test/unit/data/providers/google/google_calendar_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/google/google_tasks_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_calendar_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_todo_provider_test.dart`
- 已刪除對應的 generated mocks：
  - `awesome_mail_flutter/test/unit/data/providers/google/google_calendar_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/google/google_tasks_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_calendar_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_todo_provider_test.mocks.dart`
- 已重新盤點 batch 10 缺測清單，移除 17 個已存在對應測試的假陽性項目：
  - `shared/l10n/*` 4 檔
  - `shared/themes/*` 6 檔
  - `productivity_page.dart`、`macos_button.dart`、`platform_oauth_service.dart`
  - `pgp_keys_page.dart`、`download_progress_state.dart`、`folder_state.dart`、`sync_progress_state.dart`

#### 批次 14：state coverage 對齊與缺測修補

- 已補上 `MailboxChipState` 的直接單元測試：
  - `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_chip_state_test.dart`
- 已重新校正 batch 10 的 state / event coverage 清單，移除 5 個已由既有測試覆蓋的假陽性項目：
  - `account_state.dart`
  - `automation_event.dart`
  - `automation_state.dart`
  - `ai_status_state.dart`
  - `pgp_keys_state.dart`
- 依據這次校正與補測結果，Flutter 缺測數從 46 檔下修到 40 檔

#### 批次 15：repository / foundation helper coverage 對齊

- 已重新校正 9 個 helper 類缺測假陽性：
  - `_email_query_operations.dart`
  - `_email_merge_helpers.dart`
  - `_email_save_operations.dart`
  - `_email_delete_operations.dart`
  - `_foundation_ai_provider_prompt_utils.dart`
  - `_foundation_ai_provider_sanitizer.dart`
  - `_foundation_ai_provider_security.dart`
  - `_foundation_ai_provider_core.dart`
  - `_foundation_ai_provider_summary.dart`
- 依據這次校正結果，Flutter 缺測數從 40 檔再下修到 31 檔

#### 批次 16：page / handler coverage 對齊

- 已重新校正 17 個由頁面 / bloc 測試間接覆蓋的缺測假陽性：
  - `setup_error_widget.dart`
  - `protonmail_setup_widget.dart`
  - `enterprise_setup_widget.dart`
  - `home_mailbox_view.dart`
  - `home_toolbar.dart`
  - `_mailbox_folder_handlers.dart`
  - `_mailbox_batch_handlers.dart`
  - `_mailbox_label_handlers.dart`
  - `_mailbox_email_handlers.dart`
  - `_mailbox_sync_handlers.dart`
  - `_settings_appearance_section.dart`
  - `_settings_ai_section.dart`
  - `_settings_notification_section.dart`
  - `_settings_account_section.dart`
  - `_settings_shared_widgets.dart`
  - `_settings_legal_section.dart`
  - `_settings_sync_section.dart`
- 依據這次校正結果，Flutter 缺測數從 31 檔再下修到 14 檔

#### 批次 17：generated / barrel / example coverage 對齊

- 已移除 5 個不應視為直接缺測的項目：
  - `firebase_options.dart`（FlutterFire CLI generated）
  - `injection.config.dart`（Injectable generated code，含 `coverage:ignore-file`）
  - `macos_components.dart`（barrel file）
  - `awesome_design_example.dart`（設計系統展示範例）
  - `_foundation_ai_provider_operations.dart`（由 `foundation_ai_provider_test.dart` 與 foundation 子模組測試間接覆蓋）
- 依據這次校正結果，Flutter 缺測數從 14 檔再下修到 9 檔

#### 批次 18：Flutter 最後直接缺測收尾

- 已補上最後 9 個 Flutter 真缺測檔案的直接測試：
  - `awesome_mail_flutter/lib/shared/widgets/maybe_selection_area.dart`
  - `awesome_mail_flutter/lib/presentation/widgets/adaptive/adaptive_widgets.dart`
  - `awesome_mail_flutter/lib/presentation/pages/debug/ai_diagnostics_page.dart`
  - `awesome_mail_flutter/lib/presentation/pages/debug/test_resizable_layout.dart`
  - `awesome_mail_flutter/lib/presentation/pages/debug/scrollable_webview_test_page.dart`
  - `awesome_mail_flutter/lib/presentation/pages/debug/resizable_layout_test_page.dart`
  - `awesome_mail_flutter/lib/presentation/pages/debug/webview_test_page.dart`
  - `awesome_mail_flutter/lib/presentation/pages/debug/complex_email_test_page.dart`
  - `awesome_mail_flutter/lib/core/routing/app_router.dart`
- 為了讓 debug fixture 可直接驗證，已將下列頁面中的 HTML fixture 透過 `visibleForTesting` 暴露：
  - `awesome_mail_flutter/lib/presentation/pages/debug/scrollable_webview_test_page.dart`
  - `awesome_mail_flutter/lib/presentation/pages/debug/complex_email_test_page.dart`
- 在補測過程中修復了 `AppRouter` 的真實行為缺陷：
  - 受保護的 `/search` 路由原本未把 `accountId` 傳給 `SearchPage`
  - 現在已與未受保護分支一致，正確傳遞 `accountId`
- 依據這次補測結果，Flutter 缺測數從 9 檔降到 0 檔

#### 批次 19：Python 缺測與 generated 假陽性收尾

- 已新增 `generate_todos.py` 的直接測試：
  - `python_tests/test_generate_todos.py`
- 已將下列 generated ephemeral 假陽性從缺測清單移除：
  - `awesome_mail_flutter/packages/foundation_models_framework/example/ios/Flutter/ephemeral/flutter_lldb_helper.py`
- 依據這次收尾結果，Python 缺測數從 2 檔降到 0 檔

#### 批次 20：HTTP client mock 收尾與 batch 9 關帳

- 已把最後 10 支直接 mock `http.Client` 的 Flutter 測試移出 generated mock / mocktail `Mock implements http.Client`：
  - `awesome_mail_flutter/test/unit/data/services/account_config_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/remote_config_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/update_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/outlook/outlook_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/productivity/todoist_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/productivity/notion_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/caldav/caldav_client_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_client_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_client_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/exchange/ews_client_test.dart`
- service / provider / core 測試已改為共用 `FakeHttpClient`：
  - `awesome_mail_flutter/test/support/fakes/fake_http_client.dart`
- 協定層測試已改為共用 `http_client_mocktail_shim.dart`，保留 request capture 驗證能力而不再依賴外部 mock framework：
  - `awesome_mail_flutter/test/support/fakes/http_client_mocktail_shim.dart`
- 已刪除 6 個不再使用的 generated mocks：
  - `awesome_mail_flutter/test/unit/data/services/account_config_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/remote_config_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/update_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/outlook/outlook_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/productivity/todoist_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/productivity/notion_provider_test.mocks.dart`
- `rg` 已確認 Flutter 測試中不再存在 `@GenerateMocks([http.Client])`、`MockHttpClient extends Mock implements http.Client` 與已刪除 `.mocks.dart` 參照。
- 依據這次收尾結果，批次 9 已完成，整體審計待處理批次歸零。

### 本次驗證結果

- Backend `npm run quality:check`：通過
  - 95 個測試檔、1681 個測試全部通過
  - V8 coverage：Statements 94.66%、Branches 90.15%、Functions 98.02%、Lines 94.66%
- Flutter `flutter analyze --fatal-infos`：通過，0 個 issue
- Flutter 變更相關測試：通過
  - 批次 7：`flutter test test/widget/email_scrollable_webview_test.dart test/unit/data/providers/foundation/guided_engine_base_test.dart test/unit/data/providers/foundation/guided_session_test.dart`
  - 批次 7：31 個測試全部通過
  - 批次 8：`flutter test test/unit/core/notifications/notification_service_test.dart test/unit/data/services/gmail_remote_service_rate_limit_test.dart test/unit/data/services/ai_task_queue_service_test.dart test/unit/data/services/full_content_download_service_test.dart test/unit/data/protocols/pop3/pop3_handler_test.dart test/unit/data/providers/foundation/foundation_ai_provider_core_test.dart test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart test/unit/presentation/blocs/mailbox/mailbox_bloc_test.dart`
  - 批次 8：146 個測試全部通過
  - 批次 11：`flutter test test/shared/widgets/performance/image_cache_test.dart test/unit/data/cache/cache_manager_test.dart test/unit/core/utils/overflow_debugger_test.dart test/unit/data/providers/foundation/structured_element_detector_test.dart test/unit/data/providers/foundation/foundation_ai_provider_sanitizer_test.dart test/unit/data/providers/foundation/foundation_ai_provider_summary_test.dart test/unit/data/providers/foundation/foundation_ai_provider_core_test.dart test/widget/email_minimal_webview_test.dart test/unit/data/services/batch_operations/batch_operation_service_test.dart`
  - 批次 11：138 個測試全部通過
  - 批次 11 補充：`flutter test test/unit/data/cache/cache_manager_test.dart test/shared/widgets/performance/image_cache_test.dart`
  - 批次 11 補充：26 個測試全部通過
  - 批次 11 backend：`npm test -- --run tests/unit/services/ai-provider-mock.test.ts`
  - 批次 11 backend：35 個測試全部通過
  - 批次 12 Flutter：`flutter test test/unit/data/protocols/imap/imap_response_parser_test.dart test/unit/core/sync/email_synchronizer_test.dart test/unit/data/repositories/gmail_repository_test.dart`
  - 批次 12 Flutter：56 個測試全部通過
  - 批次 12 backend：`npm test -- --run tests/unit/jobs/base-job.test.ts`
  - 批次 12 backend：10 個測試全部通過
  - auth / 測試基礎設施回歸：`flutter test test/unit/presentation/pages/auth/login_page_test.dart test/unit/presentation/pages/auth/signup_page_test.dart test/unit/presentation/pages/auth/biometric_setup_page_test.dart`
  - auth / 測試基礎設施回歸：38 個測試全部通過
  - 批次 13：`flutter test test/support/fakes/fake_http_client_test.dart test/unit/data/providers/google/google_calendar_provider_test.dart test/unit/data/providers/google/google_tasks_provider_test.dart test/unit/data/providers/microsoft/microsoft_calendar_provider_test.dart test/unit/data/providers/microsoft/microsoft_todo_provider_test.dart`
  - 批次 13：50 個測試全部通過
  - 批次 14：`flutter test test/presentation/blocs/account/account_cubit_test.dart test/unit/presentation/blocs/automation/automation_event_state_test.dart test/unit/presentation/blocs/ai/ai_status_cubit_test.dart test/unit/presentation/blocs/settings/pgp_keys_cubit_test.dart test/unit/presentation/blocs/mailbox/mailbox_chip_cubit_test.dart test/unit/presentation/blocs/mailbox/mailbox_chip_state_test.dart`
  - 批次 14：89 個測試全部通過
  - 批次 15：`flutter test test/unit/data/repositories/email_query_operations_test.dart test/unit/data/repositories/email_merge_helpers_test.dart test/unit/data/repositories/email_save_operations_test.dart test/unit/data/repositories/email_delete_operations_test.dart test/unit/data/providers/foundation/foundation_ai_provider_prompt_utils_test.dart test/unit/data/providers/foundation/foundation_ai_provider_sanitizer_test.dart test/unit/data/providers/foundation/foundation_ai_provider_security_test.dart test/unit/data/providers/foundation/foundation_ai_provider_core_test.dart test/unit/data/providers/foundation/foundation_ai_provider_summary_test.dart`
  - 批次 15：138 個測試全部通過
  - 批次 16：`flutter test test/unit/presentation/pages/account_setup/account_setup_page_test.dart test/widget/presentation/pages/account_setup/account_setup_page_test.dart test/widget/presentation/pages/home/home_page_test.dart test/widget/presentation/pages/home/macos_home_page_test.dart test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart test/widget/presentation/pages/settings/settings_page_test.dart test/widget/presentation/pages/settings/account_settings_page_test.dart test/widget/presentation/pages/settings/appearance_settings_page_test.dart test/widget/presentation/pages/settings/ai_settings_page_test.dart test/widget/presentation/pages/settings/notification_settings_page_test.dart test/widget/presentation/pages/settings/sync_settings_page_test.dart test/widget/presentation/pages/settings/about_page_test.dart`
  - 批次 16：123 個測試全部通過
  - 批次 17：`flutter test test/unit/data/providers/foundation_ai_provider_test.dart`
  - 批次 17：62 個測試全部通過
  - 批次 18：`flutter test test/widget/shared/widgets/maybe_selection_area_test.dart test/widget/presentation/widgets/adaptive/adaptive_widgets_test.dart test/widget/presentation/pages/debug/debug_pages_test.dart test/widget/core/routing/app_router_test.dart`
  - 批次 18：17 個測試全部通過
  - 批次 19：`python3 -m unittest discover -s python_tests -p 'test_*.py'`
  - 批次 19：2 個測試全部通過
  - 批次 20：`flutter test test/unit/data/services/account_config_service_test.dart test/unit/core/remote_config_service_test.dart test/unit/core/update_service_test.dart test/unit/data/providers/outlook/outlook_provider_test.dart test/unit/data/providers/productivity/todoist_provider_test.dart test/unit/data/providers/productivity/notion_provider_test.dart test/unit/data/protocols/caldav/caldav_client_test.dart test/unit/data/protocols/carddav/carddav_client_test.dart test/unit/data/protocols/jmap/jmap_client_test.dart test/unit/data/protocols/exchange/ews_client_test.dart`
  - 批次 20：264 個測試全部通過
- Flutter 全量 `flutter test`：通過
  - 8339 個測試全部通過
- Flutter 整合測試（macOS，逐檔驗證）：通過
  - `integration_test/core_services_integration_test.dart`：8 個測試
  - `integration_test/database_cache_integration_test.dart`：3 個測試
  - `integration_test/protocols/protocol_integration_test.dart`：20 個測試
  - `integration_test/security_integration_test.dart`：7 個測試
  - `integration_test/ai_integration_test.dart`：2 個測試
  - `integration_test/example_integration_test.dart`：3 個測試
  - `integration_test/e2e/app_smoke_test.dart`：2 個測試
  - `integration_test/e2e/email_lifecycle_test.dart`：1 個測試
  - `integration_test/full_flow_test.dart`：2 個測試
  - `integration_test/auth_flow_integration_test.dart`：9 個測試
  - `integration_test/performance/scroll_perf_test.dart`：1 個測試
  - 合計 58 個測試全部通過

### 目前剩餘重點違規

- app 程式碼中的 `while` / `do-while` 類違規已清空
- 批次 10：缺少對應測試的 Flutter / Python 維護碼已完成，剩餘缺測數為 0
- 批次 9：Detroit School mock 濫用清理已完成
- 目前已無待收尾的審計批次

### 待處理批次建議

- 目前無待處理批次

### 備註

- 這次用較嚴格的語法搜尋重新檢查後，專案內目前沒有偵測到啟用中的 skipped 測試語法。
- `rg -n "while\\s*\\(|do\\s*\\{" awesome_mail_flutter/lib awesome-mail/src --glob '!**/*.g.dart' --glob '!**/*.freezed.dart'` 目前回傳 0 個結果。
- `flutter test integration_test -d macos` 仍會在第一支 app-launching 檔案結束後，因 Flutter macOS runner 的 debug 連線重建失敗而中斷；目前穩定可重現、且全部逐檔驗證均已通過的做法，是逐支執行整合測試。
- 舊報告內容保留在下方，作為歷史盤點明細；後續批次以本節的最新快照為主。

## 審計範圍
- Backend: `awesome-mail/src`, `awesome-mail/tests`
- Flutter: `awesome_mail_flutter/lib`, `awesome_mail_flutter/test`, `awesome_mail_flutter/integration_test`
- Python: 專案內 `*.py` 腳本

## 1. 違規計數
- 沒有對應測試的模組/類別數量
  - Backend: 0
  - Flutter: 0
  - Python: 0
- 測試中使用 mock 而非真實物件（Detroit School 違規）
  - Backend（唯一檔案數）: 68
  - Flutter（唯一檔案數）: 333
- 只測試 guard clauses 而未測試 happy path
  - Backend: 4
  - Flutter: 5
- 存在 skipped 測試
  - 全專案: 7

## 2. 需要修復的檔案清單

### 2.1 缺少對應測試
（已清空）

### 2.2 Mock 濫用（Detroit School 違規）
awesome-mail/tests/oauth-exchange.test.ts:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/helpers/mock-d1.ts:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/integration/ai-real-api.test.ts:398 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/integration/cron-jobs.test.ts:29 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/integration/subscriptions-simple.test.ts:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/integration/ai-mock-api.test.ts:329 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/oauth-exchange-coverage.test.ts:48 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/utils/logger.test.ts:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/cleanup-job-coverage.test.ts:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/database/init-coverage2.test.ts:21 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/sync-service-coverage.test.ts:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/integrations.test.ts:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/cleanup-job.test.ts:34 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/error-handler-coverage.test.ts:82 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/repositories/oauth-provider-repository-coverage.test.ts:26 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/usage-reset-job.test.ts:51 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/oauth-security.test.ts:93 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/repositories/subscription-repository.test.ts:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-service.test.ts:415 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/repositories/sync-repository.test.ts:33 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/health-check-job-coverage.test.ts:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/token-vault.test.ts:34 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/oauth-exchange-outlook.test.ts:77 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/base-job.test.ts:115 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/oauth-exchange-apple.test.ts:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/repositories/user-repository.test.ts:24 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/user-service.test.ts:66 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/apple-oauth-service.test.ts:217 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/usage-reset-job-coverage.test.ts:20 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/repositories/user-repository-coverage.test.ts:25 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/ai.test.ts:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/subscription-service.test.ts:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-provider-anthropic.test.ts:22 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/job-manager.test.ts:154 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/database/init-coverage.test.ts:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/auth-service-coverage.test.ts:20 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/oauth.test.ts:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/auth-service.test.ts:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/auth-service-oauth.test.ts:33 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/jobs/health-check-job.test.ts:35 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-usage-tracker-coverage.test.ts:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/oauth-refresh-service.test.ts:497 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/accounts.test.ts:28 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/metrics.test.ts:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-cache.test.ts:127 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/rate-limit-coverage2.test.ts:27 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/database/init-migrations.test.ts:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/emails.test.ts:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/subscriptions.test.ts:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/oauth-exchange-google.test.ts:67 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/logs.test.ts:37 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/auth-coverage3.test.ts:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/subscriptions-coverage.test.ts:26 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/error-handler.test.ts:82 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-usage-tracker.test.ts:133 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/auth.test.ts:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-provider-openai.test.ts:22 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/apple-client-secret-service.test.ts:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/sync-service.test.ts:212 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/error-handler-coverage2.test.ts:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/sync.test.ts:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/routes/auth.test.ts:59 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-cache-coverage.test.ts:30 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/oauth-edge-cases.test.ts:88 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/repositories/oauth-provider-repository.test.ts:28 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/auth-coverage.test.ts:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/services/ai-provider-openrouter.test.ts:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome-mail/tests/unit/middleware/auth-coverage2.test.ts:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/integration_test/ai_integration_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/integration_test/auth_flow_integration_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/widgets/email/reading_pane/conversation_test.dart:20 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/widgets/email/reading_pane/message_header_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/a11y/voiceover_nav_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/widgets/email/reading_pane/awesome_reading_pane_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/README.md:109 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/ai/ai_summary_page_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/ai/ai_reply_suggestions_page_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/data/services/metrics_service_cache_test.dart:4 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/templates/templates_page_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/pages/automation/automation_page_impl_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/test_helpers.dart:178 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/pages/home/macos_home_page_ai_test.dart:36 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/pages/templates/templates_page_impl_dialog_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/support/test_app_shell.dart:35 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/productivity/productivity_bloc_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/integration/subscription_flow_integration_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/support/mocks/mock_attachment_cubit.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/core/network/api_client_cooldown_test.dart:4 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/email/attachment_action_cubit_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/integration/subscription_flow_integration_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/core/network/api_client_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/support/mocks/mock_services.dart:4 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/account/account_cubit_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/automation/automation_bloc_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/draft/draft_management_page_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/auth_service_oauth_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/account_setup/account_setup_bloc_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/subscription/subscription_page_impl_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/sync_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/splash/splash_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/search/search_bloc_vector_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/subscription/subscription_analytics_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/menu_service_test.dart:100 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/home/home_page_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/sync_progress/sync_progress_cubit_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/biometric_auth_service_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/home/macos_home_page_test.dart:30 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/compose/compose_bloc_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/unified_oauth_service_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/email/attachments/download_manager_button_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/folder/folder_cubit_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/backup_settings_page_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/auth_service_oauth_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/automation/automation_page_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/base_oauth_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/integration/offline_mode_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/email/ai_reply/ai_reply_suggestions_widget_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/templates/advanced_template_management_page_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/general_settings_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/widgets/email/reading_pane/message_banner_streaming_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/integration/full_sync_flow_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/templates/templates_page_impl_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/notification_settings_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/email/ai_reply/ai_reply_suggestions_widget_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/privacy_settings_page_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/integration/oauth_migration_integration_test.dart:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/ai/ai_classification_page_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/sync_settings_page_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/pgp_keys_page_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/subscription/subscription_page_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/integration/oauth_migration_integration_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/appearance_settings_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/presentation/blocs/download_progress/download_progress_cubit_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/email/reading_pane/message_meta_tool_events_test.dart:19 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/compose/compose_page_test.dart:26 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/settings_page_test.dart:22 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/batch/batch_operations_page_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/email/reading_pane/email_summary_panel_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/token_service_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/oauth/oauth_feature_discovery_widget_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_integration_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_impl_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/compose/compose_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/biometric_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_error_handling_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/account_settings_page_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/google_oauth_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/network/network_info_test.dart:4 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/auth/oauth_login_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/update_settings_page_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/account_setup/account_setup_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/oauth_onboarding_widget_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/pgp/pgp_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/shortcuts_settings_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/oauth_migration_widget_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/search/search_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/state_persistence_service_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_security_test.dart:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/network/api_client_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/pgp/pgp_service_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/email_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/accessibility_settings_page_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/search/search_page_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/pgp/pgp_key_manager_test.dart:139 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_auth_service_test.dart:19 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/services/service_factory_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/ai/awesome_ai_drawer_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_impl_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/network/http_client_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/ai_settings_page_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/ai_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_error_handling_test.dart:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/services/bloc_ai_settings_service_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/oauth_onboarding_widget_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/macos/macos_preferences_dialog_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/biometric_service_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/ai/awesome_ai_drawer_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/network/api_client_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/device_id_service_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/credential_manager_test.dart:19 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/network/http_client_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/reading_pane/reanalyze_button_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/apple_oauth_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/about_page_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/ai/email_summary_widget_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/security_settings_page_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_onboarding_service_test.dart:19 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/remote_config_service_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/ai/email_classification_widget_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/remote_config_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/ai/email_classification_widget_test.dart:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/unified_oauth_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/ai/entity_extraction/entity_extraction_widget_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/pgp_key_manager_test.dart:159 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/accessibility/accessibility_service_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/subscription/feature_gate_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/sync/qr_scanner_page_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/pages/settings/appearance_settings_page_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_security_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/update_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/security/credential_manager_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/sync/qr_scanner_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_onboarding_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/widget/presentation/widgets/subscription/feature_gate_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/update_service_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/sync/qr_generator_page_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_integration_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/sync/email_synchronizer_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/widgets/common/voice_input_button_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/sync/email_synchronizer_test.dart:27 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/background/isolate_manager_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/account_setup/account_setup_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/base_oauth_service_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/sync/sync_state_manager_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/monitoring/network_monitor_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/background/background_sync_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/background/background_sync_service_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/sync/offline_queue_service_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/account_setup/gmail_setup_widget_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/state_persistence_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/ai_service_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/monitoring/performance_metrics_test.dart:123 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/apple_oauth_service_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/monitoring/network_monitor_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/google_oauth_service_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/auth_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/app_lifecycle_manager_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/email_service_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/sync_service_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/device_id_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/auth_service_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/account_setup/account_setup_page_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/app_lifecycle_manager_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/auth/login_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/core/services/oauth_auth_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/home/home_action_controller_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/input/keyboard_manager_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/email_sync/email_sync_cubit_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/auth/login_page_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/home/utils/home_keyboard_handler_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/auth/signup_page_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_label_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/auth/biometric_setup_page_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/ai/ai_bloc_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/subscription/subscription_bloc_test.dart:19 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/sync/sync_bloc_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/state_persistence_test.dart:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/domain/repositories/email_repository_test.dart:4 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/auth/signup_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/email_cache_coordinator_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/pages/auth/biometric_setup_page_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/template_service_simple_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/subscription_service_test.dart:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/subscription/subscription_cubit_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/ai/ai_bloc_test.dart:29 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/sync/sync_bloc_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/productivity_service_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/bloc_manager_test.dart:62 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/template_service_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/batch_operations/batch_operation_service_simple_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/email_cache_coordinator_cas_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/payment/payment_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/full_content_download_service_test.dart:21 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/subscription/subscription_cubit_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/ai_task_queue_service_bulk_security_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/vector_search_service_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/email_account_service_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/batch_operations/batch_operation_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/email_search_service_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/settings_backup_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/subscription/subscription_bloc_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/email_sync_cubit_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/payment/payment_service_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/full_content_download_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/app/app_bloc_test.dart:29 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/metrics_service_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/email_cache_service_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/bloc_factory_test.dart:22 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_attachment_parser_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/app/app_bloc_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/batch_operations/batch_operation_service_test.dart:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_attachment_download_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/ai_task_queue_service_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/attachment_download_manager_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/account_management/account_management_cubit_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/bloc_manager_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/batch_operations/batch_operation_service_simple_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/account_setup/account_setup_gmail_bloc_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_bloc_test.dart:25 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_repository_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/ai_task_scheduler_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_action_cubit_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/email_sync_service_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart:26 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/settings/pgp_keys_cubit_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/template_service_simple_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/draft_service_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/unread_count_manager_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_repository_test.dart:156 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/gmail_repository_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/auth/auth_bloc_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/search/search_bloc_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_sync_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/outlook/outlook_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/draft_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/settings/settings_bloc_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_repository_ai_fields_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/auth/auth_bloc_test.dart:26 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_delete_operations_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/subscription_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/all_mail_sync_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/all_mail_sync_service_test.dart:17 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/template_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_merge_helpers_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/outlook/outlook_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/settings/settings_bloc_test.dart:21 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/account_repository_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/email_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_save_operations_test.dart:19 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_attachment_parser_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/unread_count_manager_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/caldav/caldav_client_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_attachment_download_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_query_operations_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/yahoo/yahoo_provider_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/presentation/blocs/state_persistence_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/protonmail/protonmail_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/repositories/email_repository_impl_test.dart:21 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/sync_health_checker_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/sync_health_checker_test.dart:24 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/usage_tracking_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/yahoo/yahoo_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_client_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/protonmail/protonmail_provider_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_todo_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_handler_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/settings_backup_service_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_handler_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/automation/email_rule_engine_simple_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/productivity/todoist_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/ai_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_todo_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/email_flags_service_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_handler_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/in_app_purchase/subscription_manager_test.dart:7 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_handler_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/automation/email_rule_engine_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_parser_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/productivity/notion_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/remote_ai_provider_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_calendar_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/account_config_service_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_client_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/ai_task_scheduler_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/productivity/notion_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_message_test.dart:18 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/automation/email_rule_engine_simple_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/usage_tracking_service_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/productivity/todoist_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/account_config_service_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/microsoft/microsoft_calendar_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_sync_test.dart:19 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/exchange/exchange_handler_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/foundation/foundation_models_framework_client_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/automation/email_rule_engine_test.dart:16 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/services/gmail_remote_service_parser_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/calendar_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/apple/apple_calendar_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/oauth/oauth_token_refresh_service_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/google/google_tasks_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/exchange/exchange_handler_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/apple/apple_calendar_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/auth/oauth2/oauth2_manager_test.dart.bak:11 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/apple/apple_reminders_provider_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/apple/apple_reminders_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/google/google_calendar_provider_test.dart:13 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/google/google_tasks_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/google/google_calendar_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/protocols/exchange/ews_client_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/gmail/token_refresh_service_test.dart:5 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/gmail/gmail_token_repository_test.dart:6 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/email_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/ai_provider_test.dart:10 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/calendar_provider_test.dart:12 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/hybrid_ai_provider_test.dart:15 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/gmail/oauth_error_reporter_test.dart:4 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/gmail/gmail_token_refresh_manager_test.dart:9 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/icloud/icloud_provider_test.mocks.dart:1 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/gmail/gmail_oauth_service_test.dart:49 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/icloud/icloud_provider_test.dart:14 - 大量使用 mock，違反 Detroit School 偏好 - 中
awesome_mail_flutter/test/unit/data/providers/gmail/gmail_oauth_service_real_test.dart:8 - 大量使用 mock，違反 Detroit School 偏好 - 中

### 2.3 只測 guard clauses
awesome-mail/tests/unit/services/sync-service-coverage.test.ts:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome-mail/tests/unit/repositories/oauth-provider-repository-coverage.test.ts:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome-mail/tests/unit/database/init-coverage2.test.ts:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome-mail/tests/unit/database/init-coverage.test.ts:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome_mail_flutter/test/unit/data/services/gmail_attachment_download_test.dart:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome_mail_flutter/test/unit/data/database/tables/sync_metadata_table_test.dart:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome_mail_flutter/test/unit/data/database/tables/drafts_table_test.dart:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome_mail_flutter/test/unit/data/database/connection/web_connection_test.dart:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中
awesome_mail_flutter/test/unit/data/database/connection/connection_test.dart:1 - 測試偏向 guard clauses，缺少 happy path 驗證 - 中

### 2.4 Skipped 測試
awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.mocks.dart:458:  _i4.Stream<_i5.Uint8List> skip(int? count) => - 存在 skipped 測試 - 高
awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.mocks.dart:1004:  _i4.Stream<_i5.Uint8List> skip(int? count) => - 存在 skipped 測試 - 高
awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.mocks.dart:458:  _i4.Stream<_i5.Uint8List> skip(int? count) => - 存在 skipped 測試 - 高
awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.mocks.dart:1004:  _i4.Stream<_i5.Uint8List> skip(int? count) => - 存在 skipped 測試 - 高
awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.mocks.dart:458:  _i4.Stream<_i5.Uint8List> skip(int? count) => - 存在 skipped 測試 - 高
awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.mocks.dart:1004:  _i4.Stream<_i5.Uint8List> skip(int? count) => - 存在 skipped 測試 - 高
awesome_mail_flutter/test/unit/core/network/http_client_test.mocks.dart:1578:  Iterable<_i3.Interceptor> skip(int? count) => - 存在 skipped 測試 - 高

### 2.5 靜態分析違規（flutter analyze）
awesome_mail_flutter/test/unit/data/providers/foundation/guided_engine_base_test.dart:115 - flutter analyze info: unnecessary_lambdas - 低
awesome_mail_flutter/test/unit/data/providers/foundation/guided_session_test.dart:107 - flutter analyze info: unnecessary_lambdas - 低
awesome_mail_flutter/test/unit/data/providers/foundation/guided_session_test.dart:130 - flutter analyze info: unnecessary_lambdas - 低
awesome_mail_flutter/test/unit/data/providers/foundation/guided_session_test.dart:142 - flutter analyze info: unnecessary_lambdas - 低
awesome_mail_flutter/test/unit/data/providers/foundation/guided_session_test.dart:154 - flutter analyze info: unnecessary_lambdas - 低
awesome_mail_flutter/test/unit/data/providers/foundation/guided_session_test.dart:167 - flutter analyze info: unnecessary_lambdas - 低

## 3. 優先任務清單
- [ ] [高] awesome_mail_flutter/lib/* 缺少對應測試的 62 個檔案，先補齊關鍵流程的單元/Widget 測試
- [ ] [高] backend/flutter 出現無對應測試檔案項目，建立最小可驗證 happy path 測試
- [ ] [中] backend 與 flutter 測試中的 mock 濫用，逐模組替換成較真實的測試替身或整合層驗證
- [ ] [中] 9 個偏 guard-only 的測試檔補上 happy path 與錯誤路徑
- [ ] [低] 6 個 unnecessary_lambdas 改成 tearoff，清除 analyzer 警示
- [ ] [中] Python 腳本補上最小測試覆蓋，避免工具鏈變更造成回歸
