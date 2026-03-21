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

#### 批次 21：protocol handler generated mock 清理

- 已新增手寫 protocol handler fake client，取代 CardDAV / Exchange / JMAP handler 測試中的 generated mocks：
  - `awesome_mail_flutter/test/support/fakes/fake_protocol_handler_clients.dart`
- 已將下列 3 支 handler 測試改成以手寫 fake 驅動，直接驗證呼叫紀錄與參數轉送：
  - `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_handler_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/exchange/exchange_handler_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_handler_test.dart`
- 已清掉下列 3 支 handler 測試中未使用的 socket generated mock 依賴：
  - `awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.dart`
- 已刪除 6 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_handler_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/exchange/exchange_handler_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/imap/imap_handler_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_handler_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/pop3/pop3_handler_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/smtp/smtp_handler_test.mocks.dart`
- 依據這次重掃結果，Flutter mock-heavy 檔案數從 `297` 降到 `284`，batch 9 並未完成，仍需持續清理剩餘 `359` 個 mock-heavy 檔案（Flutter `284`、backend `75`）。

#### 批次 22：repository generated mock 清理

- 已將 `data/repositories` 10 支 mock-heavy 測試切到手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/unit/data/repositories/account_repository_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/email_repository_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/email_repository_impl_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/email_delete_operations_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/email_merge_helpers_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/email_query_operations_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/email_repository_ai_fields_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/email_save_operations_test.dart`
  - `awesome_mail_flutter/test/unit/data/repositories/gmail_repository_test.dart`
- 已新增 repository 共用測試替身，供 repository / helper / operations 測試共用：
  - `awesome_mail_flutter/test/support/fakes/repository_dependency_fakes.dart`
- 已刪除 `awesome_mail_flutter/test/unit/data/repositories/email_repository_test.mocks.dart`
- 在清理過程中移除了 `EmailRepositoryImpl.saveEmail` 的 `collection` 依賴，改用本地 metadata deep-equals helper：
  - `awesome_mail_flutter/lib/data/repositories/_email_merge_helpers.dart`
  - `awesome_mail_flutter/lib/data/repositories/_email_save_operations.dart`
  - `awesome_mail_flutter/lib/data/repositories/email_repository_impl.dart`
- `rg` 已確認 `awesome_mail_flutter/test/unit/data/repositories` 已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 依據這次重掃結果，Flutter mock-heavy 檔案數從 `284` 降到 `216`；backend 以同一掃描規則為 `74`，目前剩餘 `290` 個 mock-heavy 檔案（Flutter `216`、backend `74`）。

#### 批次 23：Gmail / sync data services mock 清理

- 已新增 Gmail remote service / sync 類共用測試替身：
  - `awesome_mail_flutter/test/support/fakes/fake_gmail_remote_service_dependencies.dart`
  - `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`
- 已將下列 12 支 `data/services` 測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_label_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_message_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_parser_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_sync_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_attachment_parser_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_attachment_download_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/all_mail_sync_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/full_content_download_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/email_sync_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/attachment_download_manager_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/email_cache_coordinator_test.dart`
- 已刪除 7 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_parser_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_remote_service_sync_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_attachment_parser_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/gmail_attachment_download_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/all_mail_sync_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/full_content_download_service_test.mocks.dart`
- `rg` 已確認 batch 23 相關測試與已刪除 `.mocks.dart` 參照已無 `mockito`、`mocktail`、`@GenerateMocks` 與殘留引用。
- 依據這次重掃結果，Flutter mock-heavy 檔案數從 `216` 降到 `179`；backend 以同一掃描規則為 `74`，目前剩餘 `253` 個 mock-heavy 檔案（Flutter `179`、backend `74`）。

#### 批次 24：core service infra mock 清理

- 已新增 core service infra 共用測試替身：
  - `awesome_mail_flutter/test/support/fakes/core_service_infra_fakes.dart`
- 已將下列 8 支 `core/services` 測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/unit/core/services/ai_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/app_lifecycle_manager_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/biometric_auth_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/device_id_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/email_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/state_persistence_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/sync_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/token_service_test.dart`
- 因為刪除 `ai_service_test.mocks.dart` 的相依關係，也一併將下列測試改成共用 fake：
  - `awesome_mail_flutter/test/unit/data/providers/remote_ai_provider_test.dart`
- 已刪除 6 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/core/services/ai_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/app_lifecycle_manager_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/device_id_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/email_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/state_persistence_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/sync_service_test.mocks.dart`
- `rg` 已確認 batch 24 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已無 `mockito`、`mocktail`、`@GenerateMocks` 與殘留引用。
- 依據這次重掃結果，Flutter mock-heavy 檔案數從 `179` 降到 `170`；backend 以同一掃描規則為 `74`，目前剩餘 `244` 個 mock-heavy 檔案（Flutter `170`、backend `74`）。

#### 批次 25：service storage/cache mock 清理

- 已擴充 `data/services` 共用測試替身，補足 API / storage / cache / database / logger 所需能力：
  - `awesome_mail_flutter/test/support/fakes/core_service_infra_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`
- 已將下列 10 支 `data/services` 測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/unit/data/services/email_account_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/metrics_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/usage_tracking_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/subscription_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/settings_backup_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/email_cache_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/email_cache_coordinator_cas_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/email_search_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/unread_count_manager_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/draft_service_test.dart`
- 已刪除 4 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/data/services/usage_tracking_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/subscription_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/unread_count_manager_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/draft_service_test.mocks.dart`
- `ServiceFakeAppDatabase` 已補上 search / unread / draft 相關能力，並在測試環境關閉 drift multiple database 警告。
- `rg` 已確認 batch 25 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已無 `mockito`、`mocktail`、`@GenerateMocks` 與殘留引用。
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數目前為 `169`；backend 以較完整的 Vitest/mock 關鍵字規則重掃後為 `88`，目前剩餘 `257` 個 mock-heavy 檔案（Flutter `169`、backend `88`）。

#### 批次 26：settings page mock 清理

- 已新增 settings page 共用測試替身：
  - `awesome_mail_flutter/test/support/fakes/settings_page_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/settings_page_bloc_fakes.dart`
- 已將下列 15 支 `widget/presentation/pages/settings` 測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/about_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/accessibility_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/account_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/ai_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/appearance_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/backup_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/general_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/notification_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/pgp_keys_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/privacy_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/security_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/shortcuts_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/sync_settings_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/update_settings_page_test.dart`
- 已刪除不再使用的 generated mock：
  - `awesome_mail_flutter/test/widget/presentation/pages/settings/appearance_settings_page_test.mocks.dart`
- `rg` 已確認 batch 26 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `169` 降到 `154`；backend 本輪未改動，沿用前輪較完整 Vitest/mock 關鍵字重掃基準 `88`，目前剩餘 `242` 個 mock-heavy 檔案（Flutter `154`、backend `88`）。

#### 批次 27：widget/page mock 清理

- 已新增 widget/page 共用測試替身：
  - `awesome_mail_flutter/test/support/fakes/page_widget_bloc_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/page_widget_service_fakes.dart`
- 已補強既有 fake，支援複雜 page 測試的 service 與 bloc 狀態驅動：
  - `awesome_mail_flutter/test/support/fakes/settings_page_bloc_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/fake_draft_service.dart`
- 已將下列 16 支 `widget/presentation/pages` 測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/widget/presentation/pages/account_setup/account_setup_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/ai/ai_classification_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/auth/oauth_login_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/automation/automation_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/batch/batch_operations_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/compose/compose_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/draft/draft_management_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/home/home_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/home/macos_home_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/search/search_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/splash/splash_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/subscription/subscription_analytics_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/subscription/subscription_page_impl_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/subscription/subscription_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/templates/advanced_template_management_page_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/templates/templates_page_impl_test.dart`
- 已刪除不再使用的 generated mock：
  - `awesome_mail_flutter/test/widget/presentation/pages/search/search_page_test.mocks.dart`
  - `awesome_mail_flutter/test/widget/presentation/pages/compose/compose_page_test.mocks.dart`
- 以關鍵字搜尋驗證 `awesome_mail_flutter/test/widget/presentation/pages`，已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `154` 降到 `138`；backend 本輪未改動，沿用前輪較完整 Vitest/mock 關鍵字重掃基準 `88`，目前剩餘 `226` 個 mock-heavy 檔案（Flutter `138`、backend `88`）。

#### 批次 28：account / auth / subscription bloc mock 清理

- 已新增 bloc / cubit 共用測試替身：
  - `awesome_mail_flutter/test/support/fakes/bloc_state_test_fakes.dart`
- 已將下列 8 支 bloc / cubit 測試改成手寫 fake / stub 驅動：
  - `awesome_mail_flutter/test/presentation/blocs/account/account_cubit_test.dart`
  - `awesome_mail_flutter/test/presentation/blocs/account_setup/account_setup_bloc_test.dart`
  - `awesome_mail_flutter/test/presentation/blocs/automation/automation_bloc_test.dart`
  - `awesome_mail_flutter/test/presentation/blocs/compose/compose_bloc_test.dart`
  - `awesome_mail_flutter/test/presentation/blocs/folder/folder_cubit_test.dart`
  - `awesome_mail_flutter/test/presentation/blocs/productivity/productivity_bloc_test.dart`
  - `awesome_mail_flutter/test/presentation/blocs/search/search_bloc_vector_test.dart`
  - `awesome_mail_flutter/test/presentation/blocs/sync_progress/sync_progress_cubit_test.dart`
- 已刪除不再使用的 generated mock：
  - `awesome_mail_flutter/test/presentation/blocs/account_setup/account_setup_bloc_test.mocks.dart`
  - `awesome_mail_flutter/test/presentation/blocs/automation/automation_bloc_test.mocks.dart`
  - `awesome_mail_flutter/test/presentation/blocs/compose/compose_bloc_test.mocks.dart`
  - `awesome_mail_flutter/test/presentation/blocs/folder/folder_cubit_test.mocks.dart`
  - `awesome_mail_flutter/test/presentation/blocs/productivity/productivity_bloc_test.mocks.dart`
  - `awesome_mail_flutter/test/presentation/blocs/search/search_bloc_vector_test.mocks.dart`
- `rg` 已確認 batch 28 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `138` 降到 `128`；backend 本輪未改動，沿用前輪較完整 Vitest/mock 關鍵字重掃基準 `88`，目前剩餘 `216` 個 mock-heavy 檔案（Flutter `128`、backend `88`）。

#### 批次 29：data service mock 清理

- 已擴充 data service 共用測試替身，補齊 cache / metrics / parser / sync 所需能力：
  - `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/core_service_infra_fakes.dart`
- 已將下列 7 支 `data/services` 測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/data/services/metrics_service_cache_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/ai_cache_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/ai_task_queue_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/batch_operations/batch_operation_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/email_processing_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/folder_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/vector_search_service_test.dart`
- 已刪除不再使用的 generated mock：
  - `awesome_mail_flutter/test/unit/data/services/email_processing_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/folder_service_test.mocks.dart`
- `rg` 已確認 batch 29 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `128` 降到 `121`；backend 本輪未改動，沿用前輪較完整 Vitest/mock 關鍵字重掃基準 `88`，目前剩餘 `209` 個 mock-heavy 檔案（Flutter `121`、backend `88`）。

#### 批次 30：provider adapter mock 清理

- 已新增並擴充 provider adapter 共用測試替身，覆蓋 AI / email / calendar provider 與 CalDAV / IMAP / SMTP / PGP / ProtonMail bridge 依賴：
  - `awesome_mail_flutter/test/support/fakes/provider_adapter_fakes.dart`
- 已將下列 7 支 provider / adapter 測試改成手寫 fake 驅動：
  - `awesome_mail_flutter/test/unit/data/providers/ai_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/calendar_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/email_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/apple/apple_calendar_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/apple/apple_reminders_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/icloud/icloud_provider_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/protonmail/protonmail_provider_test.dart`
- 因刪除 `ai_provider_test.mocks.dart` 的相依關係，也一併將下列測試改成共用 fake：
  - `awesome_mail_flutter/test/unit/data/providers/hybrid_ai_provider_test.dart`
- 已刪除 7 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/data/providers/ai_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/calendar_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/email_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/apple/apple_calendar_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/apple/apple_reminders_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/icloud/icloud_provider_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/providers/protonmail/protonmail_provider_test.mocks.dart`
- `rg` 已確認 batch 30 相關測試與共用 fake 檔已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `121` 降到 `113`；backend 以較完整 Vitest/mock 關鍵字重掃後為 `76`，目前剩餘 `189` 個 mock-heavy 檔案（Flutter `113`、backend `76`）。

#### 批次 31：provider tail mock 清理

- 已新增 provider tail 共用測試替身，覆蓋 `ApiClient`、`FlutterSecureStorage`、`Dio`、`GoogleSignInManager`、`FoundationModelsFramework`、token repository 與 refresh service：
  - `awesome_mail_flutter/test/support/fakes/provider_tail_fakes.dart`
- 已將下列 8 支 provider tail 測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/unit/data/providers/foundation/foundation_models_framework_client_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/gmail/gmail_oauth_service_real_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/gmail/gmail_token_refresh_manager_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/gmail/gmail_token_repository_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/gmail/oauth_error_reporter_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/gmail/token_refresh_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/oauth/oauth_token_refresh_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/providers/yahoo/yahoo_provider_test.dart`
- 已刪除不再使用的 generated mock：
  - `awesome_mail_flutter/test/unit/data/providers/yahoo/yahoo_provider_test.mocks.dart`
- `rg` 已確認 batch 31 相關測試與共用 fake 檔已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `113` 降到 `110`；backend 以同一規則重掃後為 `73`，目前剩餘 `183` 個 mock-heavy 檔案（Flutter `110`、backend `73`）。

#### 批次 32：core OAuth service mock 清理

- 已將 `test/unit/core/services` 的 12 支核心 OAuth / auth / menu 測試改成手寫 fake 或真實協調層驅動：
  - `awesome_mail_flutter/test/unit/core/services/auth_service_oauth_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/auth_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_auth_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_onboarding_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/apple_oauth_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/base_oauth_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/google_oauth_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_error_handling_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_integration_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_security_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/unified_oauth_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/services/menu_service_test.dart`
- 已擴充 auth / OAuth core 共用 fake：
  - `awesome_mail_flutter/test/support/fakes/oauth_core_service_fakes.dart`
- 已刪除 11 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/core/services/apple_oauth_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/auth_service_oauth_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/auth_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/base_oauth_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/google_oauth_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_auth_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_error_handling_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_integration_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_onboarding_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/oauth_security_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/services/unified_oauth_service_test.mocks.dart`
- 批次 32 targeted：`flutter test test/unit/core/services/auth_service_oauth_test.dart test/unit/core/services/auth_service_test.dart test/unit/core/services/oauth_auth_service_test.dart test/unit/core/services/oauth_onboarding_service_test.dart test/unit/core/services/apple_oauth_service_test.dart test/unit/core/services/base_oauth_service_test.dart test/unit/core/services/google_oauth_service_test.dart test/unit/core/services/oauth_error_handling_test.dart test/unit/core/services/oauth_integration_test.dart test/unit/core/services/oauth_security_test.dart test/unit/core/services/unified_oauth_service_test.dart test/unit/core/services/menu_service_test.dart`
- 批次 32 targeted：192 個測試全部通過
- 批次 32 搜尋驗證：batch 32 相關測試與共用 fake 檔已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`；`test/unit/core/services` 已無 `.mocks.dart`
- 批次 32：`flutter analyze --fatal-infos`
- 批次 32：0 個 issue

#### 批次 33：data services mock 清理

- 已將 `test/unit/data/services` 的 8 支 data service 測試改成手寫 fake、真實 in-memory DB 或 production service 協調層驅動：
  - `awesome_mail_flutter/test/unit/data/services/ai_task_queue_service_bulk_security_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/ai_task_queue_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/ai_task_scheduler_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/email_flags_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/in_app_purchase/subscription_manager_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/productivity_service_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/sync_health_checker_test.dart`
  - `awesome_mail_flutter/test/unit/data/services/vector_search_service_test.dart`
- 已擴充 data services 共用測試替身：
  - `awesome_mail_flutter/test/support/fakes/data_service_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`
- 已刪除 3 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/data/services/ai_task_scheduler_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/sync_health_checker_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/data/services/settings_backup_service_test.mocks.dart`
- 批次 33 targeted：`flutter test test/unit/data/services/ai_task_queue_service_bulk_security_test.dart test/unit/data/services/ai_task_queue_service_test.dart test/unit/data/services/ai_task_scheduler_test.dart test/unit/data/services/email_flags_service_test.dart test/unit/data/services/in_app_purchase/subscription_manager_test.dart test/unit/data/services/productivity_service_test.dart test/unit/data/services/sync_health_checker_test.dart test/unit/data/services/vector_search_service_test.dart`
- 批次 33 targeted：107 個測試全部通過
- 批次 33 搜尋驗證：batch 33 相關測試、共用 fake 與已刪除 `.mocks.dart` 參照已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 批次 33：`flutter analyze --fatal-infos`
- 批次 33：0 個 issue

#### 批次 34：integration mock 清理

- 已將 `test/integration` 的 4 支整合測試改成手寫 fake / in-memory 驅動：
  - `awesome_mail_flutter/test/integration/subscription_flow_integration_test.dart`
  - `awesome_mail_flutter/test/integration/oauth_migration_integration_test.dart`
  - `awesome_mail_flutter/test/integration/offline_mode_test.dart`
  - `awesome_mail_flutter/test/integration/full_sync_flow_test.dart`
- 已擴充 integration 共用測試替身：
  - `awesome_mail_flutter/test/support/fakes/presentation_bloc_service_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/repository_dependency_fakes.dart`
- 已刪除 2 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/integration/oauth_migration_integration_test.mocks.dart`
  - `awesome_mail_flutter/test/integration/subscription_flow_integration_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `110` 降到 `109`；backend 以同一規則重掃後為 `69`，目前剩餘 `178` 個 mock-heavy 檔案（Flutter `109`、backend `69`）。

#### 批次 35：presentation bloc foundation mock 清理

- 已將 `test/unit/presentation/blocs` 的 4 支基礎 bloc / cubit 測試改成手寫 recorder、fake 與 interface fake 驅動：
  - `awesome_mail_flutter/test/unit/presentation/blocs/bloc_factory_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/bloc_manager_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/email_sync/email_sync_cubit_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_action_cubit_test.dart`
- `BlocFactory` 測試現在以手寫 `GetIt` factory fake 驗證註冊與解析，不再依賴 `mocktail`
- `BlocManager`、`EmailSyncCubit`、`MailboxActionCubit` 測試已改成直接驗證 recorder / fake 的呼叫紀錄與狀態行為
- 已刪除 1 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/presentation/blocs/bloc_manager_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `109` 降到 `104`；backend 以較完整 Vitest/mock 關鍵字規則重掃後為 `76`，目前剩餘 `180` 個 mock-heavy 檔案（Flutter `104`、backend `76`）。

#### 批次 36：presentation bloc core mock 清理

- 已將 `test/unit/presentation/blocs` 的 5 支核心 bloc / cubit 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/unit/presentation/blocs/ai/ai_bloc_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/email_sync_cubit_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/search/search_bloc_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/state_persistence_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/sync/sync_bloc_test.dart`
- `AIBloc`、`AuthBloc`、`SearchBloc`、`SyncBloc` 與舊版 `EmailSyncCubit` 測試現在直接驗證 recorder / fake 的呼叫紀錄、持久化內容、queue enqueue 與 state 行為，不再依賴 mock framework
- 為了消除刪除 generated mock 後的殘留依賴，也一併把 `awesome_mail_flutter/integration_test/ai_integration_test.dart` 改成手寫 fake 驅動
- 已刪除 3 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/presentation/blocs/ai/ai_bloc_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/state_persistence_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/sync/sync_bloc_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `104` 降到 `96`；backend 以同一規則重掃後為 `76`，目前剩餘 `172` 個 mock-heavy 檔案（Flutter `96`、backend `76`）。

#### 批次 37：mailbox bloc mock 清理

- 已將 `test/unit/presentation/blocs/mailbox` 的 2 支 mailbox bloc 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_bloc_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart`
- 新增共用 mailbox 測試替身與 harness：
  - `awesome_mail_flutter/test/support/fakes/mailbox_bloc_dependency_fakes.dart`
- `MailboxBloc` 與 `MailboxHandlers` 測試現在直接驗證 repository / Gmail / queue / progress cubit 的 recorder 呼叫紀錄與 state 行為，不再依賴 mock framework
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `96` 降到 `94`；backend 以同一規則重掃後為 `73`，目前剩餘 `167` 個 mock-heavy 檔案（Flutter `94`、backend `73`）。

#### 批次 38：presentation pages mock 清理

- 已將 `test/unit/presentation/pages` 的 9 支 page / controller 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/unit/presentation/pages/account_setup/account_setup_page_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/account_setup/gmail_setup_widget_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/auth/biometric_setup_page_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/auth/login_page_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/auth/signup_page_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/home/home_action_controller_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/home/utils/home_keyboard_handler_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/sync/qr_generator_page_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/sync/qr_scanner_page_test.dart`
- 新增 page 測試共用 Gmail harness / recorder：
  - `awesome_mail_flutter/test/support/fakes/presentation_page_test_fakes.dart`
- auth、sync、home 與 account setup page 測試現在直接驗證 bloc `addedEvents`、service recorder、畫面狀態與 dialog/snackbar 輸出，不再依賴 `mockito`、`mocktail`、`MockBloc` 或 generated mocks
- 已刪除 5 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/presentation/pages/account_setup/account_setup_page_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/auth/biometric_setup_page_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/auth/login_page_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/auth/signup_page_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/pages/sync/qr_scanner_page_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `94` 降到 `80`；backend 維持 `73`，目前剩餘 `153` 個 mock-heavy 檔案（Flutter `80`、backend `73`）。

#### 批次 39：widget presentation widgets mock 清理

- 已將 `test/widget/presentation/widgets` 的 10 支 widget 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/widget/presentation/widgets/ai/awesome_ai_drawer_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/ai/email_summary_widget_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/ai/entity_extraction/entity_extraction_widget_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/email/attachments/download_manager_button_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/email/reading_pane/email_summary_panel_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/email/reading_pane/message_meta_tool_events_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/macos/macos_preferences_dialog_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/oauth_migration_widget_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/oauth_onboarding_widget_test.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/subscription/feature_gate_test.dart`
- 已新增 widget 測試共用 fake / recorder 組合：
  - `awesome_mail_flutter/test/support/fakes/widget_presentation_test_fakes.dart`
- AI、reading pane、OAuth、subscription 與 macOS widget 測試現在直接驗證 bloc `addedEvents`、service recorder、queue / cache fake 與 dialog / snackbar 畫面輸出，不再依賴 `mockito`、`mocktail`、`@GenerateMocks`、`MockBloc` 或 generated mocks
- 已刪除 3 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/widget/presentation/widgets/ai/awesome_ai_drawer_test.mocks.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/oauth_onboarding_widget_test.mocks.dart`
  - `awesome_mail_flutter/test/widget/presentation/widgets/subscription/feature_gate_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `80` 降到 `67`；backend 維持 `73`，目前剩餘 `140` 個 mock-heavy 檔案（Flutter `67`、backend `73`）。

#### 批次 40：unit presentation widgets mock 清理

- 已將 `test/unit/presentation/widgets` 的 7 支 unit widget 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/unit/presentation/widgets/ai/email_classification_widget_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/common/voice_input_button_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/email/ai_reply/ai_reply_suggestions_widget_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/oauth/oauth_feature_discovery_widget_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/reading_pane/reanalyze_button_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_impl_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_test.dart`
- 已擴充 widget / bloc / service 共用 fake，補足 voice input、OAuth onboarding 與 reading pane 所需的 in-memory 狀態：
  - `awesome_mail_flutter/test/support/fakes/widget_presentation_test_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/settings_page_bloc_fakes.dart`
  - `awesome_mail_flutter/test/support/fakes/service_layer_fakes.dart`
- 因為刪除 generated AIBloc mocks 之後，`test/presentation/widgets/email/reading_pane` 仍有殘留參照，已一併改成 `TestAIBloc`：
  - `awesome_mail_flutter/test/presentation/widgets/email/reading_pane/awesome_reading_pane_test.dart`
  - `awesome_mail_flutter/test/presentation/widgets/email/reading_pane/conversation_test.dart`
  - `awesome_mail_flutter/test/presentation/widgets/email/reading_pane/message_header_test.dart`
- 已刪除 4 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/presentation/widgets/ai/email_classification_widget_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/email/ai_reply/ai_reply_suggestions_widget_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_impl_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/presentation/widgets/sync/sync_status_widget_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `67` 降到 `56`；backend 維持 `73`，目前剩餘 `129` 個 mock-heavy 檔案（Flutter `56`、backend `73`）。

#### 批次 41：core security mock 清理

- 已將下列 3 支 core security 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/unit/core/security/biometric_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/security/credential_manager_test.dart`
  - `awesome_mail_flutter/test/unit/core/security/pgp/pgp_service_test.dart`
- 已新增 security 共用測試替身，取代 `LocalAuthentication`、`EncryptionService` 與 `PGPKeyManager` 的 generated mock：
  - `awesome_mail_flutter/test/support/fakes/security_test_fakes.dart`
- credential manager 測試已改為直接驗證 in-memory secure storage 的寫入結果、刪除紀錄與加解密輸入，而非驗證 mock invocation
- biometric 測試現在在每個測試前重置 `SharedPreferences` 狀態，避免啟用旗標在測試間洩漏
- 已刪除 3 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/core/security/biometric_service_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/security/credential_manager_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/security/pgp/pgp_service_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `56` 降到 `47`；backend 維持 `73`，目前剩餘 `120` 個 mock-heavy 檔案（Flutter `47`、backend `73`）。

#### 批次 42：core network mock 清理

- 已將下列 3 支 core network 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/unit/core/network/api_client_test.dart`
  - `awesome_mail_flutter/test/unit/core/network/http_client_test.dart`
  - `awesome_mail_flutter/test/unit/core/network/network_info_test.dart`
- 已新增 network 共用測試替身，提供 recorder 型 `HttpClient` 與 `Connectivity` fake：
  - `awesome_mail_flutter/test/support/fakes/network_test_fakes.dart`
- `HttpClient` 測試已改為搭配真 `Dio` 與既有 `RecordingDioAdapter`，直接驗證 request method、path、headers 與錯誤轉換
- `ApiClient` 測試已改為驗證實際 request URL、Authorization header、query string 與 `ApiException` 轉換，不再驗證 generated mock invocation
- 已刪除 2 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/core/network/api_client_test.mocks.dart`
  - `awesome_mail_flutter/test/unit/core/network/http_client_test.mocks.dart`
- 依本輪以同一規則重掃結果，Flutter mock-heavy 檔案數從 `47` 降到 `42`；backend 維持 `73`，目前剩餘 `115` 個 mock-heavy 檔案（Flutter `42`、backend `73`）。

#### 批次 43：core sync mock 清理

- 已新增 sync 共用測試替身，集中提供 synchronizer / offline queue / state manager 需要的 recorder 與 in-memory fake：
  - `awesome_mail_flutter/test/support/fakes/sync_test_fakes.dart`
- 已將下列 3 支 core sync 測試改成手寫 fake / recorder 驅動：
  - `awesome_mail_flutter/test/unit/core/sync/email_synchronizer_test.dart`
  - `awesome_mail_flutter/test/unit/core/sync/offline_queue_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/sync/sync_state_manager_test.dart`
- 已刪除 1 個不再使用的 generated `.mocks.dart`：
  - `awesome_mail_flutter/test/unit/core/sync/email_synchronizer_test.mocks.dart`
- `EmailSynchronizer` 測試已改為直接驗證同步方向、history capture 重試與去彈跳行為，不再依賴 mock invocation
- `OfflineQueueServiceImpl` 測試已改為直接驗證 queue 狀態、衝突解決、優先序與序列化結果
- `SyncStateManager` 測試已改為直接驗證記憶體快取、檔案快取、metadata repository 與失敗路徑
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `42` 降到 `38`；backend 沿用前輪較完整 Vitest/mock 關鍵字基準 `73`，目前剩餘 `111` 個 mock-heavy 檔案（Flutter `38`、backend `73`）。

#### 批次 44：protocol client mock 清理

- 已新增 protocol client 共用 HTTP recorder，集中提供 queued response、request record 與 close 狀態驗證：
  - `awesome_mail_flutter/test/support/fakes/protocol_client_http_fakes.dart`
- 已將下列 4 支 protocol client 測試改成手寫 recorder 驅動，直接驗證 URL、HTTP method、header、SOAP/XML/JSON/vCard/iCal body 與錯誤處理：
  - `awesome_mail_flutter/test/unit/data/protocols/caldav/caldav_client_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/carddav/carddav_client_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/exchange/ews_client_test.dart`
  - `awesome_mail_flutter/test/unit/data/protocols/jmap/jmap_client_test.dart`
- 在改寫過程中修復了 `CardDAVClient.getCapabilities()` 於 `disconnect()` 後會觸發 null-check crash 的真實缺陷，現在改為穩定拋出 `ProtocolException`：
  - `awesome_mail_flutter/lib/data/protocols/carddav/carddav_client.dart`
- `awesome_mail_flutter/test/unit/data/protocols` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `38` 降到 `34`；backend 沿用前輪較完整 Vitest/mock 關鍵字基準 `73`，目前剩餘 `107` 個 mock-heavy 檔案（Flutter `34`、backend `73`）。

#### 批次 45：core background mock 清理

- 已新增 background 共用 recorder / hand-written fake，集中覆蓋 `SyncService`、`IsolateManager` 與 `OfflineQueueService` 的互動觀測：
  - `awesome_mail_flutter/test/support/fakes/background_test_fakes.dart`
- 已將下列 2 支 background 測試改成手寫 recorder 驅動，直接驗證 task 排程、優先序、retry backoff、離線佇列處理、衝突同步與 isolate 生命周期：
  - `awesome_mail_flutter/test/unit/core/background/background_sync_service_test.dart`
  - `awesome_mail_flutter/test/unit/core/background/isolate_manager_test.dart`
- 已刪除 1 個不再需要的 generated mock：
  - `awesome_mail_flutter/test/unit/core/background/background_sync_service_test.mocks.dart`
- `awesome_mail_flutter/test/unit/core/background` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `34` 降到 `31`；backend 沿用前輪較完整 Vitest/mock 關鍵字基準 `73`，目前剩餘 `104` 個 mock-heavy 檔案（Flutter `31`、backend `73`）。

#### 批次 46：monitoring 與 presentation services mock 清理

- 已將下列 3 支測試改成手寫 fake / stub 驅動，不再依賴 `mockito` 或 `mocktail`：
  - `awesome_mail_flutter/test/unit/core/monitoring/network_monitor_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/services/service_factory_test.dart`
  - `awesome_mail_flutter/test/unit/presentation/services/bloc_ai_settings_service_test.dart`
- `network_monitor_test.dart` 已改用 hand-written `FakeConnectivity` 驅動，直接驗證 connectivity 事件流、請求統計、retry pattern 與報告產生
- `service_factory_test.dart` 已強化成驗證每個 getter 都會回傳 `getIt` 中已註冊的同一個實例，而不是只驗證型別
- `bloc_ai_settings_service_test.dart` 已改用 hand-written `SettingsBloc` stub，直接驗證不同 `SettingsState` 下的 provider mode 決策
- 已刪除 1 個不再需要的 generated mock：
  - `awesome_mail_flutter/test/unit/core/monitoring/network_monitor_test.mocks.dart`
- `awesome_mail_flutter/test/unit/core/monitoring` 與 `awesome_mail_flutter/test/unit/presentation/services` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `31` 降到 `27`；backend 沿用前輪較完整 Vitest/mock 關鍵字基準 `73`，目前剩餘 `100` 個 mock-heavy 檔案（Flutter `27`、backend `73`）。

#### 批次 47：legacy 測試基礎設施 mock 清理

- 已將下列 6 個 legacy 測試基礎設施與直接依賴檔案改成手寫 fake / recorder 驅動，不再依賴 `mockito`、`mocktail`、`MockBloc` 或 `MockCubit`：
  - `awesome_mail_flutter/test/support/mocks/mock_services.dart`
  - `awesome_mail_flutter/test/support/mocks/mock_attachment_cubit.dart`
  - `awesome_mail_flutter/test/support/test_app_shell.dart`
  - `awesome_mail_flutter/test/test_helpers.dart`
  - `awesome_mail_flutter/test/widget/core/routing/app_router_test.dart`
  - `awesome_mail_flutter/test/presentation/pages/home/macos_home_page_ai_test.dart`
- `mock_services.dart` 已改用手寫 recorder fake，覆蓋 draft、email、repository、cache、logger 與多個 bloc/cubit 測試依賴，讓 router/home 測試能直接驗證事件派送與狀態同步
- `test_app_shell.dart` 已移除 `registerFallbackValue`、`when` 與 `any`，改成直接註冊 hand-written fake singleton
- `app_router_test.dart` 與 `macos_home_page_ai_test.dart` 已改成直接檢查 recorder 收到的事件，不再靠 mock framework 驗證互動
- 改寫過程揭露 `HomeNavigationCubit` 在 `close()` 後仍可能因偏好設定非同步載入而 `emit` 的真實缺陷；已在 `lib/presentation/pages/home/blocs/home_navigation_cubit.dart` 補上 `isClosed` guard，並以 `test/unit/presentation/pages/home/home_navigation_cubit_test.dart` 新增回歸測試鎖住
- `awesome_mail_flutter/test/support/mocks`、`awesome_mail_flutter/test/support/test_app_shell.dart`、`awesome_mail_flutter/test/test_helpers.dart`、`awesome_mail_flutter/test/widget/core/routing/app_router_test.dart` 與 `awesome_mail_flutter/test/presentation/pages/home/macos_home_page_ai_test.dart` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit` 與 `.mocks.dart`
- 依本輪以同一 Flutter 掃描規則重掃結果，Flutter mock-heavy 檔案數從 `27` 降到 `21`；backend 沿用前輪較完整 Vitest/mock 關鍵字基準 `73`，目前剩餘 `94` 個 mock-heavy 檔案（Flutter `21`、backend `73`）。

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
- 批次 21：`flutter test test/unit/data/protocols/carddav/carddav_handler_test.dart test/unit/data/protocols/exchange/exchange_handler_test.dart test/unit/data/protocols/imap/imap_handler_test.dart test/unit/data/protocols/jmap/jmap_handler_test.dart test/unit/data/protocols/pop3/pop3_handler_test.dart test/unit/data/protocols/smtp/smtp_handler_test.dart`
- 批次 21：131 個測試全部通過
- 批次 21 搜尋驗證：protocol handler 測試與對應資料夾已無 `mockito`、`@GenerateMocks`、`.mocks.dart`
- 批次 22：`flutter test test/unit/data/repositories`
- 批次 22：112 個測試全部通過
- 批次 22 搜尋驗證：`awesome_mail_flutter/test/unit/data/repositories` 已無 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`
- 批次 23：`flutter test test/unit/data/services/gmail_remote_service_test.dart test/unit/data/services/gmail_remote_service_label_test.dart test/unit/data/services/gmail_remote_service_message_test.dart test/unit/data/services/gmail_remote_service_parser_test.dart test/unit/data/services/gmail_remote_service_sync_test.dart test/unit/data/services/gmail_attachment_parser_test.dart test/unit/data/services/gmail_attachment_download_test.dart test/unit/data/services/all_mail_sync_service_test.dart test/unit/data/services/full_content_download_service_test.dart test/unit/data/services/email_sync_service_test.dart test/unit/data/services/attachment_download_manager_test.dart test/unit/data/services/email_cache_coordinator_test.dart`
- 批次 23：154 個測試全部通過
- 批次 23 搜尋驗證：batch 23 相關測試與已刪除 `.mocks.dart` 參照已清空
- 批次 24：`flutter test test/unit/core/services/ai_service_test.dart test/unit/core/services/app_lifecycle_manager_test.dart test/unit/core/services/biometric_auth_service_test.dart test/unit/core/services/device_id_service_test.dart test/unit/core/services/email_service_test.dart test/unit/core/services/state_persistence_service_test.dart test/unit/core/services/sync_service_test.dart test/unit/core/services/token_service_test.dart`
- 批次 24：84 個測試全部通過
- 批次 24 補充：`flutter test test/unit/data/providers/remote_ai_provider_test.dart`
- 批次 24 補充：5 個測試全部通過
- 批次 24 搜尋驗證：batch 24 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已清空
- 批次 24：`flutter analyze --fatal-infos`
- 批次 24：0 個 issue
- 批次 25：`flutter test test/unit/data/services/email_account_service_test.dart test/unit/data/services/metrics_service_test.dart test/unit/data/services/usage_tracking_service_test.dart test/unit/data/services/subscription_service_test.dart test/unit/data/services/settings_backup_service_test.dart test/unit/data/services/email_cache_service_test.dart test/unit/data/services/email_cache_coordinator_cas_test.dart test/unit/data/services/email_search_service_test.dart test/unit/data/services/unread_count_manager_test.dart test/unit/data/services/draft_service_test.dart`
- 批次 25：110 個測試全部通過
- 批次 25 搜尋驗證：batch 25 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已清空
- 批次 25：`flutter analyze --fatal-infos`
- 批次 25：0 個 issue
- 批次 26：`flutter test test/widget/presentation/pages/settings/about_page_test.dart test/widget/presentation/pages/settings/accessibility_settings_page_test.dart test/widget/presentation/pages/settings/account_settings_page_test.dart test/widget/presentation/pages/settings/ai_settings_page_test.dart test/widget/presentation/pages/settings/appearance_settings_page_test.dart test/widget/presentation/pages/settings/backup_settings_page_test.dart test/widget/presentation/pages/settings/general_settings_page_test.dart test/widget/presentation/pages/settings/notification_settings_page_test.dart test/widget/presentation/pages/settings/pgp_keys_page_test.dart test/widget/presentation/pages/settings/privacy_settings_page_test.dart test/widget/presentation/pages/settings/security_settings_page_test.dart test/widget/presentation/pages/settings/settings_page_test.dart test/widget/presentation/pages/settings/shortcuts_settings_page_test.dart test/widget/presentation/pages/settings/sync_settings_page_test.dart test/widget/presentation/pages/settings/update_settings_page_test.dart`
- 批次 26：54 個測試全部通過
- 批次 26 搜尋驗證：batch 26 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已清空
- 批次 26：`flutter analyze --fatal-infos`
- 批次 26：0 個 issue
- 批次 27 targeted：16 支 page 測試共 138 個測試全部通過
- 批次 27 搜尋驗證：`awesome_mail_flutter/test/widget/presentation/pages` 已清空 mock framework / generated mock 關鍵字
- 批次 27：`flutter analyze --fatal-infos`
- 批次 27：0 個 issue
- 批次 28 targeted：8 支 bloc / cubit 測試共 127 個測試全部通過
- 批次 28 搜尋驗證：batch 28 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已清空
- 批次 28：`flutter analyze --fatal-infos`
- 批次 28：0 個 issue
- 批次 29 targeted：7 支 data service 測試共 98 個測試全部通過
- 批次 29 搜尋驗證：batch 29 相關測試、共用 fake 檔與已刪除 `.mocks.dart` 參照已清空
- 批次 29：`flutter analyze --fatal-infos`
- 批次 29：0 個 issue
- 批次 30 targeted：`flutter test test/unit/data/providers/ai_provider_test.dart test/unit/data/providers/calendar_provider_test.dart test/unit/data/providers/email_provider_test.dart test/unit/data/providers/hybrid_ai_provider_test.dart test/unit/data/providers/apple/apple_calendar_provider_test.dart test/unit/data/providers/apple/apple_reminders_provider_test.dart test/unit/data/providers/icloud/icloud_provider_test.dart test/unit/data/providers/protonmail/protonmail_provider_test.dart`
- 批次 30 targeted：104 個測試全部通過
- 批次 30 搜尋驗證：batch 30 相關測試與共用 fake 檔已清空 mock framework / generated mock 關鍵字
- 批次 30：`flutter analyze --fatal-infos`
- 批次 30：0 個 issue
- 批次 31 targeted：`flutter test test/unit/data/providers/foundation/foundation_models_framework_client_test.dart test/unit/data/providers/gmail/gmail_oauth_service_real_test.dart test/unit/data/providers/gmail/gmail_token_refresh_manager_test.dart test/unit/data/providers/gmail/gmail_token_repository_test.dart test/unit/data/providers/gmail/oauth_error_reporter_test.dart test/unit/data/providers/gmail/token_refresh_service_test.dart test/unit/data/providers/oauth/oauth_token_refresh_service_test.dart test/unit/data/providers/yahoo/yahoo_provider_test.dart`
- 批次 31 targeted：79 個測試全部通過
- 批次 31 搜尋驗證：batch 31 相關測試與共用 fake 檔已清空 mock framework / generated mock 關鍵字，`test/unit/data/providers` 已無 `.mocks.dart`
- 批次 31：`flutter analyze --fatal-infos`
- 批次 31：0 個 issue
- 批次 33 targeted：`flutter test test/unit/data/services/ai_task_queue_service_bulk_security_test.dart test/unit/data/services/ai_task_queue_service_test.dart test/unit/data/services/ai_task_scheduler_test.dart test/unit/data/services/email_flags_service_test.dart test/unit/data/services/in_app_purchase/subscription_manager_test.dart test/unit/data/services/productivity_service_test.dart test/unit/data/services/sync_health_checker_test.dart test/unit/data/services/vector_search_service_test.dart`
- 批次 33 targeted：107 個測試全部通過
- 批次 33 搜尋驗證：batch 33 相關測試、共用 fake 與已刪除 `.mocks.dart` 參照已清空
- 批次 33：`flutter analyze --fatal-infos`
- 批次 33：0 個 issue
- 批次 34 targeted：`flutter test test/integration/subscription_flow_integration_test.dart test/integration/oauth_migration_integration_test.dart test/integration/offline_mode_test.dart test/integration/full_sync_flow_test.dart`
- 批次 34 targeted：22 個測試全部通過
- 批次 34 搜尋驗證：batch 34 相關測試、共用 fake 與已刪除 `.mocks.dart` 參照已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 批次 34：`flutter analyze --fatal-infos`
- 批次 34：0 個 issue
- 批次 35 targeted：`flutter test test/unit/presentation/blocs/bloc_factory_test.dart test/unit/presentation/blocs/bloc_manager_test.dart test/unit/presentation/blocs/email_sync/email_sync_cubit_test.dart test/unit/presentation/blocs/mailbox/mailbox_action_cubit_test.dart`
- 批次 35 targeted：61 個測試全部通過
- 批次 35 搜尋驗證：batch 35 相關測試與已刪除 `.mocks.dart` 參照已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 批次 35：`flutter analyze --fatal-infos`
- 批次 35：0 個 issue
- 批次 36 targeted：`flutter test test/unit/presentation/blocs/ai/ai_bloc_test.dart test/unit/presentation/blocs/email_sync_cubit_test.dart test/unit/presentation/blocs/search/search_bloc_test.dart test/unit/presentation/blocs/state_persistence_test.dart test/unit/presentation/blocs/sync/sync_bloc_test.dart`
- 批次 36 targeted：54 個測試全部通過
- 批次 36 搜尋驗證：batch 36 相關測試與已刪除 `.mocks.dart` 參照已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 批次 36：`flutter analyze --fatal-infos`
- 批次 36：0 個 issue
- 批次 36 整合補充：`flutter test integration_test/ai_integration_test.dart -d macos`
- 批次 36 整合補充：2 個測試全部通過
- 批次 37 targeted：`flutter test test/unit/presentation/blocs/mailbox/mailbox_bloc_test.dart test/unit/presentation/blocs/mailbox/mailbox_handlers_test.dart`
- 批次 37 targeted：72 個測試全部通過
- 批次 37 搜尋驗證：batch 37 相關測試與共用 fake 檔已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 與 `.mocks.dart`
- 批次 37：`flutter analyze --fatal-infos`
- 批次 37：0 個 issue
- 批次 38 targeted：`flutter test test/unit/presentation/pages/account_setup/account_setup_page_test.dart test/unit/presentation/pages/account_setup/gmail_setup_widget_test.dart test/unit/presentation/pages/auth/biometric_setup_page_test.dart test/unit/presentation/pages/auth/login_page_test.dart test/unit/presentation/pages/auth/signup_page_test.dart test/unit/presentation/pages/home/home_action_controller_test.dart test/unit/presentation/pages/home/utils/home_keyboard_handler_test.dart test/unit/presentation/pages/sync/qr_generator_page_test.dart test/unit/presentation/pages/sync/qr_scanner_page_test.dart`
- 批次 38 targeted：85 個測試全部通過
- 批次 38 搜尋驗證：`awesome_mail_flutter/test/unit/presentation/pages` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 38：`flutter analyze --fatal-infos`
- 批次 38：0 個 issue
- 批次 39 targeted：`flutter test test/widget/presentation/widgets/ai/awesome_ai_drawer_test.dart test/widget/presentation/widgets/ai/email_summary_widget_test.dart test/widget/presentation/widgets/ai/entity_extraction/entity_extraction_widget_test.dart test/widget/presentation/widgets/email/attachments/download_manager_button_test.dart test/widget/presentation/widgets/email/reading_pane/email_summary_panel_test.dart test/widget/presentation/widgets/email/reading_pane/message_meta_tool_events_test.dart test/widget/presentation/widgets/macos/macos_preferences_dialog_test.dart test/widget/presentation/widgets/oauth_migration_widget_test.dart test/widget/presentation/widgets/oauth_onboarding_widget_test.dart test/widget/presentation/widgets/subscription/feature_gate_test.dart`
- 批次 39 targeted：70 個測試全部通過
- 批次 39 搜尋驗證：`awesome_mail_flutter/test/widget/presentation/widgets` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 39：`flutter analyze --fatal-infos`
- 批次 39：0 個 issue
- 批次 40 targeted：`flutter test test/unit/presentation/widgets/ai/email_classification_widget_test.dart test/unit/presentation/widgets/common/voice_input_button_test.dart test/unit/presentation/widgets/email/ai_reply/ai_reply_suggestions_widget_test.dart test/unit/presentation/widgets/oauth/oauth_feature_discovery_widget_test.dart test/unit/presentation/widgets/reading_pane/reanalyze_button_test.dart test/unit/presentation/widgets/sync/sync_status_widget_impl_test.dart test/unit/presentation/widgets/sync/sync_status_widget_test.dart test/presentation/widgets/email/reading_pane/awesome_reading_pane_test.dart test/presentation/widgets/email/reading_pane/conversation_test.dart test/presentation/widgets/email/reading_pane/message_header_test.dart`
- 批次 40 targeted：96 個測試全部通過
- 批次 40 搜尋驗證：`awesome_mail_flutter/test/unit/presentation/widgets` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 40：`flutter analyze --fatal-infos`
- 批次 40：0 個 issue
- 批次 41 targeted：`flutter test test/unit/core/security/biometric_service_test.dart test/unit/core/security/credential_manager_test.dart test/unit/core/security/pgp/pgp_service_test.dart`
- 批次 41 targeted：50 個測試全部通過
- 批次 41 搜尋驗證：`awesome_mail_flutter/test/unit/core/security` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 41：`flutter analyze --fatal-infos`
- 批次 41：0 個 issue
- 批次 42 targeted：`flutter test test/unit/core/network/api_client_test.dart test/unit/core/network/http_client_test.dart test/unit/core/network/network_info_test.dart`
- 批次 42 targeted：34 個測試全部通過
- 批次 42 搜尋驗證：`awesome_mail_flutter/test/unit/core/network` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 42：`flutter analyze --fatal-infos`
- 批次 42：0 個 issue
- 批次 43 targeted：`flutter test test/unit/core/sync/email_synchronizer_test.dart test/unit/core/sync/offline_queue_service_test.dart test/unit/core/sync/sync_state_manager_test.dart`
- 批次 43 targeted：109 個測試全部通過
- 批次 43 搜尋驗證：`awesome_mail_flutter/test/unit/core/sync` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 43：`flutter analyze --fatal-infos`
- 批次 43：0 個 issue
- 批次 44 targeted：`flutter test test/unit/data/protocols/caldav/caldav_client_test.dart test/unit/data/protocols/carddav/carddav_client_test.dart test/unit/data/protocols/exchange/ews_client_test.dart test/unit/data/protocols/jmap/jmap_client_test.dart`
- 批次 44 targeted：73 個測試全部通過
- 批次 44 搜尋驗證：`awesome_mail_flutter/test/unit/data/protocols` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 44：`flutter analyze --fatal-infos`
- 批次 44：0 個 issue
- 批次 45 targeted：`flutter test test/unit/core/background`
- 批次 45 targeted：151 個測試全部通過
- 批次 45 搜尋驗證：`awesome_mail_flutter/test/unit/core/background` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 45：`flutter analyze --fatal-infos`
- 批次 45：0 個 issue
- 批次 46 targeted：`flutter test test/unit/core/monitoring test/unit/presentation/services`
- 批次 46 targeted：224 個測試全部通過
- 批次 46 搜尋驗證：`awesome_mail_flutter/test/unit/core/monitoring` 與 `awesome_mail_flutter/test/unit/presentation/services` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 與 `.mocks.dart`
- 批次 46：`flutter analyze --fatal-infos`
- 批次 46：0 個 issue
- 批次 47 targeted + home regression：`flutter test test/widget/core/routing/app_router_test.dart test/presentation/pages/home/macos_home_page_ai_test.dart test/presentation/home/enhanced_macos_home_layout_test.dart test/presentation/home/enhanced_macos_home_splitview_drag_test.dart test/presentation/home/enhanced_macos_home_splitview_persistence_test.dart test/unit/presentation/pages/home/home_navigation_cubit_test.dart`
- 批次 47 targeted + home regression：25 個測試全部通過
- 批次 47 搜尋驗證：`awesome_mail_flutter/test/support/mocks`、`test/support/test_app_shell.dart`、`test/test_helpers.dart`、`test/widget/core/routing/app_router_test.dart` 與 `test/presentation/pages/home/macos_home_page_ai_test.dart` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit` 與 `.mocks.dart`
- 批次 47：`flutter analyze --fatal-infos`
- 批次 47：0 個 issue
- 批次 48 targeted：`flutter test test/presentation/blocs`
- 批次 48 targeted：146 個測試全部通過
- 批次 48 搜尋驗證：`awesome_mail_flutter/test/presentation/blocs` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit` 與 `.mocks.dart`
- 批次 48：`flutter analyze --fatal-infos`
- 批次 48：0 個 issue
- 批次 49 targeted：`flutter test test/a11y/voiceover_nav_test.dart test/core/network/api_client_cooldown_test.dart test/core/network/api_client_test.dart test/data/services/metrics_service_cache_test.dart test/presentation/ai/ai_reply_suggestions_page_test.dart test/presentation/ai/ai_summary_page_test.dart test/presentation/pages/automation/automation_page_impl_test.dart test/presentation/pages/templates/templates_page_impl_dialog_test.dart test/presentation/templates/templates_page_test.dart test/unit/domain/repositories/email_repository_test.dart test/widget/widgets/email/reading_pane/message_banner_streaming_test.dart`
- 批次 49 targeted：48 個測試全部通過
- 批次 49 搜尋驗證：`awesome_mail_flutter/test` 已清空 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit` 與 `.mocks.dart`
- 批次 49：`flutter analyze --fatal-infos`
- 批次 49：0 個 issue
#### 批次 50：backend service D1/KV fake 收斂

- 已以 hand-written recorder 重寫 backend 共用 D1/KV fake：
  - `awesome-mail/tests/helpers/mock-d1.ts`
- 已將下列 10 支 `tests/unit/services` 測試改成手寫 D1/KV fake、recorder 與 store 驗證驅動：
  - `awesome-mail/tests/unit/services/ai-cache-coverage.test.ts`
  - `awesome-mail/tests/unit/services/ai-cache.test.ts`
  - `awesome-mail/tests/unit/services/ai-usage-tracker-coverage.test.ts`
  - `awesome-mail/tests/unit/services/ai-usage-tracker.test.ts`
  - `awesome-mail/tests/unit/services/subscription-service.test.ts`
  - `awesome-mail/tests/unit/services/sync-service-coverage.test.ts`
  - `awesome-mail/tests/unit/services/sync-service.test.ts`
  - `awesome-mail/tests/unit/services/token-vault.test.ts`
  - `awesome-mail/tests/unit/services/usage-tracker.test.ts`
  - `awesome-mail/tests/unit/services/user-service.test.ts`
- `rg` 已確認 batch 50 相關 helper 與測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 50 targeted：`npx vitest run tests/unit/services/ai-cache-coverage.test.ts tests/unit/services/ai-cache.test.ts tests/unit/services/ai-usage-tracker-coverage.test.ts tests/unit/services/ai-usage-tracker.test.ts tests/unit/services/subscription-service.test.ts tests/unit/services/sync-service-coverage.test.ts tests/unit/services/sync-service.test.ts tests/unit/services/token-vault.test.ts tests/unit/services/usage-tracker.test.ts tests/unit/services/user-service.test.ts`
- 批次 50 targeted：10 個測試檔、223 個測試全部通過
- 批次 50：`awesome-mail` `npm run quality:check`
- 批次 50：通過，95 個測試檔、1660 個測試全部通過，coverage 為 Statements `94.05%`、Branches `90.05%`、Functions `97.36%`、Lines `94.05%`
#### 批次 51：backend service fetch / OAuth fake 收斂

- 已新增 fetch / AI provider 共用 hand-written test helpers：
  - `awesome-mail/tests/helpers/fetch-recorder.ts`
  - `awesome-mail/tests/helpers/ai-provider-fakes.ts`
- 已將下列 13 支 `tests/unit/services` fetch / OAuth 類測試改成 hand-written fetch recorder、真實 crypto 與手寫 fake 驅動：
  - `awesome-mail/tests/unit/services/ai-provider-anthropic.test.ts`
  - `awesome-mail/tests/unit/services/ai-provider-openai.test.ts`
  - `awesome-mail/tests/unit/services/ai-provider-openrouter.test.ts`
  - `awesome-mail/tests/unit/services/ai-service.test.ts`
  - `awesome-mail/tests/unit/services/apple-client-secret-service.test.ts`
  - `awesome-mail/tests/unit/services/apple-oauth-service.test.ts`
  - `awesome-mail/tests/unit/services/google-oauth-service.test.ts`
  - `awesome-mail/tests/unit/services/oauth-exchange-apple.test.ts`
  - `awesome-mail/tests/unit/services/oauth-exchange-coverage.test.ts`
  - `awesome-mail/tests/unit/services/oauth-exchange-google.test.ts`
  - `awesome-mail/tests/unit/services/oauth-exchange-outlook.test.ts`
  - `awesome-mail/tests/unit/services/oauth-refresh-service.test.ts`
  - `awesome-mail/tests/unit/services/oauth-validation-service.test.ts`
- `rg` 已確認 batch 51 相關 helper 與測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 51 targeted：`npx vitest run tests/unit/services/ai-provider-anthropic.test.ts tests/unit/services/ai-provider-openai.test.ts tests/unit/services/ai-provider-openrouter.test.ts tests/unit/services/ai-service.test.ts tests/unit/services/apple-client-secret-service.test.ts tests/unit/services/apple-oauth-service.test.ts tests/unit/services/google-oauth-service.test.ts tests/unit/services/oauth-exchange-apple.test.ts tests/unit/services/oauth-exchange-coverage.test.ts tests/unit/services/oauth-exchange-google.test.ts tests/unit/services/oauth-exchange-outlook.test.ts tests/unit/services/oauth-refresh-service.test.ts tests/unit/services/oauth-validation-service.test.ts`
- 批次 51 targeted：13 個測試檔、87 個測試全部通過
- 批次 51：`awesome-mail` `npm run quality:check`
- 批次 51：通過，95 個測試檔、1414 個測試全部通過，coverage 為 Statements `91.13%`、Branches `86.78%`、Functions `95.82%`、Lines `91.13%`
- Flutter 全量 `flutter test`：通過
  - 8119 個測試全部通過
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

#### 批次 52：backend AuthService fake 收斂

- 已新增 backend AuthService 共用 hand-written fake 與 OAuth setup helper：
  - `awesome-mail/tests/helpers/auth-service-fakes.ts`
- 已將下列 5 支 `tests/unit/services` AuthService / OAuth account flow 測試改成真實 JWT、真實密碼雜湊、hand-written repository fake 與 fetch recorder 驅動：
  - `awesome-mail/tests/unit/services/auth-service.test.ts`
  - `awesome-mail/tests/unit/services/auth-service-coverage.test.ts`
  - `awesome-mail/tests/unit/services/auth-service-oauth.test.ts`
  - `awesome-mail/tests/unit/services/oauth-edge-cases.test.ts`
  - `awesome-mail/tests/unit/services/oauth-security.test.ts`
- `rg` 已確認 batch 52 相關 helper 與測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 52 targeted：`npx vitest run tests/unit/services/auth-service.test.ts tests/unit/services/auth-service-coverage.test.ts tests/unit/services/auth-service-oauth.test.ts tests/unit/services/oauth-edge-cases.test.ts tests/unit/services/oauth-security.test.ts`
- 批次 52 targeted：5 個測試檔、70 個測試全部通過
- 批次 52：`awesome-mail` `npm run quality:check`
- 批次 52：通過，95 個測試檔、1380 個測試全部通過，coverage 為 Statements `90.82%`、Branches `86.33%`、Functions `95.82%`、Lines `90.82%`

#### 批次 53：backend route env fake 基礎收斂

- 已新增 backend route 共用 hand-written Env / KV / D1 / DO fake 與 route app helper：
  - `awesome-mail/tests/helpers/route-env-fakes.ts`
- 已將下列 4 支 `tests/unit/routes` 測試改成真實 JWT、hand-written Env fake 與 Hono app 驅動：
  - `awesome-mail/tests/unit/routes/metrics.test.ts`
  - `awesome-mail/tests/unit/routes/logs.test.ts`
  - `awesome-mail/tests/unit/routes/integrations.test.ts`
  - `awesome-mail/tests/unit/routes/accounts.test.ts`
- `rg` 已確認 batch 53 相關 helper 與測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 53 targeted：`npx vitest run tests/unit/routes/metrics.test.ts tests/unit/routes/logs.test.ts tests/unit/routes/integrations.test.ts tests/unit/routes/accounts.test.ts`
- 批次 53 targeted：4 個測試檔、40 個測試全部通過
- 批次 53：`awesome-mail` `npm run quality:check`
- 批次 53：通過，95 個測試檔、1380 個測試全部通過，coverage 為 Statements `90.82%`、Branches `86.32%`、Functions `95.82%`、Lines `90.82%`

#### 批次 54：backend route DB / KV fake 延伸收斂

- 已延伸 batch 53 的 backend route helper，沿用 hand-written Env / KV / D1 fake 來支撐 email、subscription 與 sync 類路由：
  - `awesome-mail/tests/helpers/route-env-fakes.ts`
- 已將下列 4 支 `tests/unit/routes` 測試改成真實 JWT、hand-written D1 / KV fake、真實 crypto 與 Hono app 驅動：
  - `awesome-mail/tests/unit/routes/emails.test.ts`
  - `awesome-mail/tests/unit/routes/subscriptions-coverage.test.ts`
  - `awesome-mail/tests/unit/routes/subscriptions.test.ts`
  - `awesome-mail/tests/unit/routes/sync.test.ts`
- `sync.test.ts` 已移除 `@/utils/crypto` module mock，改為以真實 `encryptData` / `decryptData` 驗證 QR transfer 流程
- `rg` 已確認 batch 54 相關 helper 與測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 54 targeted：`npx vitest run tests/unit/routes/emails.test.ts tests/unit/routes/subscriptions-coverage.test.ts tests/unit/routes/subscriptions.test.ts tests/unit/routes/sync.test.ts`
- 批次 54 targeted：4 個測試檔、83 個測試全部通過
- 批次 54：`awesome-mail` `npm run quality:check`
- 批次 54：通過，95 個測試檔、1376 個測試全部通過，coverage 為 Statements `90.82%`、Branches `86.42%`、Functions `95.82%`、Lines `90.82%`

#### 批次 55：backend route auth / oauth / ai fake 收斂

- 已補齊 backend route 最後一組 auth / oauth / ai hand-written fake 基礎設施：
  - `awesome-mail/tests/helpers/auth-route-fakes.ts`
  - `awesome-mail/src/routes/ai.ts`
- 已將下列 3 支大型 route 測試改成真實 JWT、hand-written D1 / KV / logger recorder / provider stub 驅動：
  - `awesome-mail/tests/unit/routes/oauth.test.ts`
  - `awesome-mail/tests/unit/routes/auth.test.ts`
  - `awesome-mail/tests/unit/routes/ai.test.ts`
- `ai.test.ts` 已移除 `vi.fn`、`vi.mock`、`vi.spyOn`，改以 `AIDbFake`、`LoggerRecorder` 與可注入的 `AIProvider` stub 覆蓋成功路徑、驗證失敗、provider fallback 與 logger 分支
- `rg` 已確認 batch 55 相關 helper、route 與測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 55 targeted：`npx vitest run tests/unit/routes/auth.test.ts tests/unit/routes/oauth.test.ts tests/unit/routes/ai.test.ts`
- 批次 55 targeted：3 個測試檔、151 個測試全部通過
- 批次 55：`awesome-mail` `npm run quality:check`
- 批次 55：通過，95 個測試檔、1375 個測試全部通過，coverage 為 Statements `90.72%`、Branches `86.18%`、Functions `95.62%`、Lines `90.72%`

#### 批次 56：backend jobs fake 收斂

- 已將 backend jobs 測試共用基礎設施改成 hand-written fake，集中提供可觀察的 D1 / KV / R2 / execution context：
  - `awesome-mail/tests/fixtures/job-test-data.ts`
- 已將下列 8 支 `tests/unit/jobs` 測試改成真實 scenario、hand-written fake 與排程時間驅動：
  - `awesome-mail/tests/unit/jobs/base-job.test.ts`
  - `awesome-mail/tests/unit/jobs/cleanup-job.test.ts`
  - `awesome-mail/tests/unit/jobs/cleanup-job-coverage.test.ts`
  - `awesome-mail/tests/unit/jobs/health-check-job.test.ts`
  - `awesome-mail/tests/unit/jobs/health-check-job-coverage.test.ts`
  - `awesome-mail/tests/unit/jobs/job-manager.test.ts`
  - `awesome-mail/tests/unit/jobs/usage-reset-job.test.ts`
  - `awesome-mail/tests/unit/jobs/usage-reset-job-coverage.test.ts`
- `JobDatabaseFake`、`JobKvNamespaceFake` 與 `JobR2BucketFake` 已支援 bind / query / object 存取紀錄，讓 jobs 測試直接驗證狀態轉移與持久化結果，而不是驗證 mock invocation
- `rg` 已確認 batch 56 的 fixture 與 8 支 jobs 測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 56 targeted：`npx vitest run tests/unit/jobs/base-job.test.ts tests/unit/jobs/cleanup-job.test.ts tests/unit/jobs/cleanup-job-coverage.test.ts tests/unit/jobs/health-check-job.test.ts tests/unit/jobs/health-check-job-coverage.test.ts tests/unit/jobs/job-manager.test.ts tests/unit/jobs/usage-reset-job.test.ts tests/unit/jobs/usage-reset-job-coverage.test.ts`
- 批次 56 targeted：8 個測試檔、134 個測試全部通過
- 批次 56：`awesome-mail` `npm run quality:check`
- 批次 56：通過，95 個測試檔、1375 個測試全部通過，coverage 為 Statements `90.72%`、Branches `86.12%`、Functions `95.62%`、Lines `90.72%`

#### 批次 57：backend middleware fake 收斂

- 已新增 middleware 共用 hand-written 測試替身，集中提供真 JWT、auth env 與 error context stub：
  - `awesome-mail/tests/helpers/middleware-fakes.ts`
- 已將下列 8 支 `tests/unit/middleware` 測試改成真 request/response、真 JWT 與 hand-written fake 驅動：
  - `awesome-mail/tests/unit/middleware/auth.test.ts`
  - `awesome-mail/tests/unit/middleware/auth-coverage.test.ts`
  - `awesome-mail/tests/unit/middleware/auth-coverage2.test.ts`
  - `awesome-mail/tests/unit/middleware/auth-coverage3.test.ts`
  - `awesome-mail/tests/unit/middleware/error-handler.test.ts`
  - `awesome-mail/tests/unit/middleware/error-handler-coverage.test.ts`
  - `awesome-mail/tests/unit/middleware/error-handler-coverage2.test.ts`
  - `awesome-mail/tests/unit/middleware/rate-limit-coverage2.test.ts`
- auth middleware 測試已移除 JWT module mock，改成以真實簽章 token、hand-written D1 / KV fake 驗證 payload、token version cache 與 optional auth 行為
- error-handler 與 rate-limit 補充測試已移除 console/context/KV mock，改成直接驗證 Hono app 回應與手寫 context / KV fake 的狀態
- `rg` 已確認 batch 57 的 helper 與 8 支 middleware 測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 57 targeted：`npx vitest run tests/unit/middleware/auth.test.ts tests/unit/middleware/auth-coverage.test.ts tests/unit/middleware/auth-coverage2.test.ts tests/unit/middleware/auth-coverage3.test.ts tests/unit/middleware/error-handler.test.ts tests/unit/middleware/error-handler-coverage.test.ts tests/unit/middleware/error-handler-coverage2.test.ts tests/unit/middleware/rate-limit-coverage2.test.ts`
- 批次 57 targeted：8 個測試檔、71 個測試全部通過
- 批次 57：`awesome-mail` `npm run quality:check`
- 批次 57：通過，95 個測試檔、1364 個測試全部通過，coverage 為 Statements `90.68%`、Branches `85.98%`、Functions `95.62%`、Lines `90.68%`

#### 批次 58：backend repositories fake 收斂

- 已新增 repositories 共用 hand-written 持久層測試替身，集中提供 in-memory D1 / KV 狀態與可排程的 run 結果：
  - `awesome-mail/tests/helpers/repository-test-fakes.ts`
- 已將下列 6 支 repository 測試改成 hand-written D1 / KV fake 驅動：
  - `awesome-mail/tests/unit/repositories/oauth-provider-repository.test.ts`
  - `awesome-mail/tests/unit/repositories/oauth-provider-repository-coverage.test.ts`
  - `awesome-mail/tests/unit/repositories/user-repository.test.ts`
  - `awesome-mail/tests/unit/repositories/user-repository-coverage.test.ts`
  - `awesome-mail/tests/unit/repositories/subscription-repository.test.ts`
  - `awesome-mail/tests/unit/repositories/sync-repository.test.ts`
- repository 測試現在直接驗證 in-memory persisted state、欄位映射、plan limits、usage reset 與 KV payload/TTL，而不是驗證 `prepare` / `bind` 的 mock 呼叫
- `rg` 已確認 batch 58 的 helper 與 6 支 repository 測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`
- 批次 58 targeted：`npx vitest run tests/unit/repositories/oauth-provider-repository.test.ts tests/unit/repositories/oauth-provider-repository-coverage.test.ts tests/unit/repositories/user-repository.test.ts tests/unit/repositories/user-repository-coverage.test.ts tests/unit/repositories/subscription-repository.test.ts tests/unit/repositories/sync-repository.test.ts`
- 批次 58 targeted：6 個測試檔、86 個測試全部通過
- 批次 58：`awesome-mail` `npm run quality:check`
- 批次 58：通過，95 個測試檔、1362 個測試全部通過，coverage 為 Statements `90.68%`、Branches `86.05%`、Functions `95.62%`、Lines `90.68%`

#### 批次 59：backend integration fake 收斂

- 已新增 integration 共用 hand-written route / auth / fetch 測試替身：
  - `awesome-mail/tests/helpers/integration-route-fakes.ts`
  - `awesome-mail/tests/helpers/auth-route-fakes.ts`
  - `awesome-mail/tests/helpers/fetch-recorder.ts`
- 已將下列整合測試改成 hand-written env / route fake 驅動：
  - `awesome-mail/tests/integration/auth.test.ts`
  - `awesome-mail/tests/integration/accounts.test.ts`
  - `awesome-mail/tests/integration/sync.test.ts`
  - `awesome-mail/tests/integration/subscriptions.test.ts`
  - `awesome-mail/tests/integration/subscriptions-simple.test.ts`
  - `awesome-mail/tests/integration/ai.test.ts`
  - `awesome-mail/tests/integration/ai-mock-api.test.ts`
  - `awesome-mail/tests/integration/ai-real-api.test.ts`
  - `awesome-mail/tests/integration/cron-jobs.test.ts`
  - `awesome-mail/tests/integration/oauth-comprehensive.test.ts`
- `rg` 已確認 batch 59 的 10 支整合測試已清空 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`Mocked<` 與 `as Mock`
- 批次 59 targeted：`npx vitest run tests/integration/auth.test.ts tests/integration/accounts.test.ts tests/integration/sync.test.ts tests/integration/subscriptions.test.ts tests/integration/subscriptions-simple.test.ts tests/integration/ai.test.ts tests/integration/ai-mock-api.test.ts tests/integration/ai-real-api.test.ts tests/integration/cron-jobs.test.ts tests/integration/oauth-comprehensive.test.ts`
- 批次 59 targeted：預設 Vitest integration suite 通過 `9` 個測試檔、`116` 個測試；`ai-real-api.test.ts` 仍依專案設定由 `npm run test:ai` 在有授權金鑰時執行，未納入預設 regression
- 批次 59：`awesome-mail` `npm run quality:check`
- 批次 59：通過，91 個測試檔、1292 個測試全部通過，coverage 為 Statements `90.59%`、Branches `85.82%`、Functions `95.26%`、Lines `90.59%`

#### 批次 60：尾端測試可測試性清理

- 已在 backend logger 與 database init 建立最小測試注入點，移除對全域 console / migrator 建構流程的 spy 依賴：
  - `awesome-mail/src/utils/logger.ts`
  - `awesome-mail/src/database/init.ts`
- 已將尾端 backend 測試改成 hand-written fake 驅動，並刪除重複低價值殘留測試：
  - `awesome-mail/tests/unit/utils/logger.test.ts`
  - `awesome-mail/tests/unit/database/init-migrations.test.ts`
  - 已刪除 `awesome-mail/tests/unit/database/init-coverage.test.ts`
  - 已刪除 `awesome-mail/tests/unit/database/init-coverage2.test.ts`
  - 已刪除 `awesome-mail/tests/oauth-exchange.test.ts`
  - 已刪除 `awesome-mail/tests/unit/subscriptions.test.ts`
- Flutter foundation client 測試已改成既有 fake framework 驅動，並刪除尾端備份檔：
  - `awesome_mail_flutter/lib/data/providers/foundation/foundation_models_framework_client.dart`
  - `awesome_mail_flutter/test/unit/data/providers/foundation/foundation_models_framework_client_test.dart`
  - 已刪除 `awesome_mail_flutter/test/unit/data/auth/oauth2/oauth2_manager_test.dart.bak`
- 批次 60 targeted：backend `2` 個測試檔、`12` 個測試全部通過
- 批次 60 targeted：Flutter foundation client `8` 個測試全部通過
- `rg` 已確認 batch 60 範圍內不再出現 `vi.spyOn`、`vi.mock`、`vi.fn`、`FoundationModelsFramework.mock()`、`foundation_models_framework/testing.dart` 與 `.bak` 測試殘留

#### 批次 61：Flutter 最終 mock framework 歸零

- `foundation_models_framework` package 已以顯式 testing factory 取代 mock-only API：
  - `awesome_mail_flutter/packages/foundation_models_framework/lib/foundation_models_framework.dart`
  - `awesome_mail_flutter/packages/foundation_models_framework/test/foundation_models_framework_test.dart`
  - 已刪除 `awesome_mail_flutter/packages/foundation_models_framework/lib/testing.dart`
- `auth_flow_integration_test.dart` 已移除 `mocktail`，改由 hand-written fake 與真實 `StatePersistenceService` 驅動：
  - `awesome_mail_flutter/integration_test/auth_flow_integration_test.dart`
- app 端已移除不再需要的 dev dependency：
  - `awesome_mail_flutter/pubspec.yaml`
  - `awesome_mail_flutter/pubspec.lock`
- 批次 61 targeted：package `foundation_models_framework_test.dart` `7` 個測試全部通過
- 批次 61 targeted：`integration_test/auth_flow_integration_test.dart` `9` 個測試全部通過
- Flutter 驗證：`flutter analyze --fatal-infos` 通過，`0` 個 issue
- Flutter 驗證：全量 `flutter test` `8119` 個測試全部通過
- 搜尋驗證：`awesome_mail_flutter/lib`、`test`、`integration_test`、package `lib` / `test` 與 `awesome-mail/src`、`tests` 內已無實際 `mockito` / `mocktail` / `@GenerateMocks` / `FoundationModelsFramework.mock()` / `foundation_models_framework/testing.dart` 使用；`find awesome_mail_flutter awesome-mail -name '*.mocks.dart'` 回傳 `0`

### 目前剩餘重點違規

- app 程式碼中的 `while` / `do-while` 類違規已清空
- 批次 10：缺少對應測試的 Flutter / Python 維護碼已完成，剩餘缺測數為 0
- 批次 9：Detroit School mock 濫用清理已完成
  - Flutter mock-heavy：`0`
  - Backend mock-heavy：`0`
  - 目前剩餘 `0` 個 mock-heavy 檔案
  - `awesome_mail_flutter` / `awesome-mail` 程式與測試目錄內，已無實際 `mockito`、`mocktail`、`@GenerateMocks`、`.mocks.dart`、`class ... extends Mock`、`FoundationModelsFramework.mock()`、`foundation_models_framework/testing.dart`
- 最新 batch 21 到 61 的 targeted tests、搜尋驗證、`flutter analyze --fatal-infos` 與 `awesome-mail` `npm run quality:check` 已全部通過

### 待處理批次建議

- 無。批次 8 到 61 的審計修復已全部完成。

### 備註

- 這次用較嚴格的語法搜尋重新檢查後，專案內目前沒有偵測到啟用中的 skipped 測試語法。
- `rg -n "while\\s*\\(|do\\s*\\{" awesome_mail_flutter/lib awesome-mail/src --glob '!**/*.g.dart' --glob '!**/*.freezed.dart'` 目前回傳 0 個結果。
- `awesome-mail/tests/integration/ai-real-api.test.ts` 仍依專案設定由 `npm run test:ai` 在有授權金鑰時執行，未納入預設 Vitest regression；本次沒有授權金鑰，因此未實跑該檔。
- `flutter test integration_test -d macos` 仍會在第一支 app-launching 檔案結束後，因 Flutter macOS runner 的 debug 連線重建失敗而中斷；目前穩定可重現、且全部逐檔驗證均已通過的做法，是逐支執行整合測試。
- 文件檔仍可能保留歷史 `mockito` / `@GenerateMocks` 關鍵字文字敘述，例如 `test/README.md`；本次清理目標是實際程式與測試目錄中的執行碼。
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
