# Spec: 批次 28 account/auth/subscription bloc mock 清理

## 背景

批次 27 已清掉 `test/widget/presentation/pages` 的 mock-heavy page 測試，接下來 Flutter 剩餘最大的 mock-heavy 群組是 `awesome_mail_flutter/test/unit/presentation/blocs`。其中帳號、認證、訂閱與設定相關的 bloc / cubit 測試目前有 `13` 個檔案仍依賴 `mockito`、generated `.mocks.dart` 或大量 `when` / `verify`：

- `account_management/account_management_cubit_test.dart`
- `account_setup/account_setup_gmail_bloc_test.dart`
- `app/app_bloc_test.dart`
- `app/app_bloc_test.mocks.dart`
- `auth/auth_bloc_test.dart`
- `auth/auth_bloc_test.mocks.dart`
- `settings/pgp_keys_cubit_test.dart`
- `settings/settings_bloc_test.dart`
- `settings/settings_bloc_test.mocks.dart`
- `subscription/subscription_bloc_test.dart`
- `subscription/subscription_bloc_test.mocks.dart`
- `subscription/subscription_cubit_test.dart`
- `subscription/subscription_cubit_test.mocks.dart`

這批測試都圍繞帳號生命週期、登入 / 訂閱狀態、設定儲存與付費流程，依賴型態相近，適合在同一批次收斂成共用 hand-written fake。

## 問題陳述

這批 bloc / cubit 測試目前有四個問題：

1. 大量透過 `when`、`thenAnswer`、`verify` 驅動流程，測試重心偏向 mock 腳本，而不是 bloc 狀態轉換。
2. 同類型依賴如 `AuthService`、`SubscriptionService`、`PaymentService`、`StatePersistenceService`、`Logger` 在多個檔案中重複宣告 generated mocks，維護成本高。
3. generated `.mocks.dart` 讓這批單元測試的依賴層次不清楚，且每次介面異動都會引入額外重生成本。
4. `test/unit/presentation/blocs` 是目前最大的 Flutter mock-heavy 群組，若不先收斂這批，後續 bloc 群組會持續複製相同 boilerplate。

## 使用者故事

### US1: 以手寫 service fake 驅動 auth / app / settings bloc 測試

作為維護者，我們希望認證、app 初始化與設定相關 bloc 測試改以手寫 fake 驅動，直接驗證狀態轉換與事件處理。

#### 驗收條件

1. `app`、`auth`、`settings` 與帳號管理相關測試不再依賴 `mockito`、`@GenerateMocks` 或 generated `.mocks.dart`。
2. 測試以可讀的 fake service / fake stream 驅動，不再靠 `verify` 次數主導。
3. 測試驗證的是 bloc state 變化、事件處理與資料值，而不是 mock 框架行為。

### US2: 以手寫 fake 驅動 subscription / account setup 類 bloc 測試

作為維護者，我們希望訂閱與帳號設定相關 bloc / cubit 測試改用 hand-written fake，直接驗證升級、載入、錯誤處理與設定流程。

#### 驗收條件

1. `subscription` 與 `account_setup` 相關測試改用最小可用 fake service / cubit。
2. 測試保留 happy path、錯誤路徑與狀態轉換驗證。
3. 這批對應 `.mocks.dart` 依賴完全移除。

### US3: 清掉 account/auth/subscription/settings bloc 群組的 mock framework 依賴

作為維護者，我們希望 batch 28 範圍內的 bloc 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。

#### 驗收條件

1. 這批對應 `.mocks.dart` 已刪除。
2. batch 28 檔案與共用 fake 檔中已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 production bloc / cubit 公開 API。
- 不在本批次處理 `mailbox`、`sync`、`search`、`bloc_factory`、`bloc_manager`。
- 不擴大處理 backend mock-heavy 測試。

## 成功指標

- 這 13 個帳號 / 認證 / 訂閱 / 設定 bloc 測試改由 hand-written fake 驅動。
- batch 28 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- `test/unit/presentation/blocs` mock-heavy 群組在本批次完成後進一步下降。
