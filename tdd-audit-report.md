# TDD Compliance Audit Report - 全平台完整版

審計日期：2026-03-07
範圍：全平台 - Backend TypeScript (`awesome-mail/src/`) + Flutter (`awesome_mail_flutter/lib/`) + CI Workflows
方法：全面靜態分析（flutter analyze、eslint、tsc）+ 測試執行驗證

---

## 執行結果

| 平台 | 測試數 | 結果 |
|------|--------|------|
| Backend TypeScript | 1529 通過 + 19 skipIf | 全數通過 |
| Flutter 單元測試 | 6461 | 全數通過 |
| Flutter analyze | 0 issues | 清除 |
| Backend lint/type-check | 0 errors | 清除 |

---

## 修復摘要

### 批次 1：Flutter lib/ 直接 lint 修復（4 項）

| # | 檔案 | 問題 | 修復 |
|---|------|------|------|
| 1 | `lib/core/services/auth_service.dart` | avoid_unused_constructor_parameters（biometricService、deviceIdService） | 移除未使用參數，重新執行 build_runner |
| 2 | `lib/domain/entities/email_address.dart:31` | unintended_html_in_doc_comment | 將 `<john@example.com>` 改為 HTML entity |
| 3 | `lib/presentation/services/menu_service.dart:10,13` | directives_ordering | 重新排序 import |
| 4 | `lib/presentation/widgets/email/security/external_content_controller.dart:82` | unnecessary_brace_in_string_interps | 移除 `${keyword}-` 的不必要大括號 |

### 批次 2：Flutter 測試檔案 lint 修復（38 項）

| # | 檔案 | 問題 | 修復 |
|---|------|------|------|
| 5 | `test/unit/core/services/auth_service_test.dart` | directives_ordering + 舊參數 | 修正 import 順序，移除 biometricService/deviceIdService |
| 6 | `test/unit/core/services/auth_service_oauth_test.dart` | 舊建構子參數 | 移除 biometricService/deviceIdService |
| 7 | `test/unit/core/services/menu_service_test.dart` | directives_ordering | 修正 import 排序 |
| 8 | `test/unit/core/services/calendar_service_test.dart:129` | unnecessary_lambdas | 改用 constructor tearoff `CalendarService.new` |
| 9 | `test/unit/data/repositories/gmail_repository_test.dart` | avoid_redundant_argument_values（6 處） | 移除預設值參數 |
| 10 | `test/unit/data/services/batch_operations/batch_operation_service_simple_test.dart` | no_leading_underscores + prefer_const | 重命名 `_makeEmail` → `makeEmail`，加 const |
| 11 | `test/unit/data/services/email_sync_service_test.dart` | avoid_redundant_argument_values（13 處） | 移除 null 預設值參數 |
| 12 | `test/unit/presentation/services/service_factory_test.dart` | discarded_futures + unnecessary_lambdas | setUp 改 async，tearDown 改 tearoff |
| 13 | `test/unit/shared/widgets/animation/awesome_animation_controller_test.dart` | prefer_int_literals + unawaited_futures + redundant | 修正所有問題 |

### 批次 3：Emoji 清理

| # | 檔案 | 修復 |
|---|------|------|
| 14 | `lib/data/database/app_database.dart` | 移除 4 處 migration log 中的 ✅ |
| 15 | `lib/data/services/security/security_service.dart` | 移除 ⚠️，改為 WARNING: 文字前綴 |
| 16 | `lib/data/services/sync_metrics_collector.dart` | 移除所有 emoji（✅⚠️⚡🐌📊❌ℹ️） |
| 17 | `lib/data/services/full_content_download_service.dart` | 移除 4 處 log 中的 ✅ |
| 18 | `lib/data/repositories/gmail_repository.dart` | 移除 2 處 ⚡ |
| 19 | `lib/data/services/email_sync_service.dart` | 移除 1 處 ⚡ |
| 20 | `.github/workflows/gemini-scheduled-triage.yml` | 移除 echo 中的 ✅🎯 |

### 批次 4：後端 P1-P2 修復（前次審計遺留）

| # | 任務 | 結果 |
|---|------|------|
| 21 | 拆分 ai-service.ts → ai-provider-types/openai/anthropic/openrouter/mock | 完成 |
| 22 | 將 subscriptions.ts 內嵌的 StripeService → services/stripe-service.ts | 完成 |
| 23 | 將 subscriptions.ts 內嵌的 UsageTracker → services/usage-tracker.ts | 完成 |
| 24 | 移除 request-guard.ts 的 @ts-ignore | 完成 |
| 25 | 補充 environment.ts 測試（100% 覆蓋率） | 完成 |
| 26 | 改善 logger.test.ts 測試品質 | 完成 |

---

## 已知剩餘事項（P2 - Detroit School TDD）

以下為 Detroit School TDD 違規，因需要大規模重構，列為後續改善項目：

| # | 測試檔案 | 問題 |
|---|---------|------|
| 1 | `tests/unit/services/auth-service*.test.ts` (3 檔) | vi.mock 內部模組（UserRepository、OAuthProviderRepository、jwt、crypto） |
| 2 | `tests/unit/services/user-service.test.ts` | vi.mock 內部模組 |
| 3 | `tests/unit/services/subscription-service.test.ts` | vi.mock 內部模組 |
| 4 | `tests/unit/services/sync-service*.test.ts` (2 檔) | vi.mock 內部模組 |

這些測試在外部 mock 框架中使用了真實的 D1/KV 邊界 mock（符合 Detroit School），但對內部 service 也做了 mock（不符合）。修復方向：建立記憶體版本的 D1 Database，用真實 Repository 取代 vi.mock。

---

## 正面發現

1. **Flutter analyze 全數清除**（42 個問題 → 0）
2. **所有測試通過**：Flutter 6461 個、後端 1529 個
3. **生產碼無 emoji**（lib/ 和 src/ 全面清除）
4. **Backend lint/type-check 全數通過**
5. **environment.ts 覆蓋率從 60% 提升至 100%**
6. **ai-service.ts 從 2040 行拆分為 6 個模組（最大 666 行）**
