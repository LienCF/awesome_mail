# Spec: 批次 26 settings page mock 清理

## 背景

批次 25 已清掉 `test/unit/data/services` 中一組 API / storage / cache / DB mock-heavy 測試，接下來 Flutter 最大的集中群組是 `awesome_mail_flutter/test/widget/presentation/pages/settings`，目前仍有 `15` 支 widget/page 測試依賴 `mocktail` 或 `mockito`：

- `about_page_test.dart`
- `accessibility_settings_page_test.dart`
- `account_settings_page_test.dart`
- `ai_settings_page_test.dart`
- `appearance_settings_page_test.dart`
- `backup_settings_page_test.dart`
- `general_settings_page_test.dart`
- `notification_settings_page_test.dart`
- `pgp_keys_page_test.dart`
- `privacy_settings_page_test.dart`
- `security_settings_page_test.dart`
- `settings_page_test.dart`
- `shortcuts_settings_page_test.dart`
- `sync_settings_page_test.dart`
- `update_settings_page_test.dart`

這批測試大多以 `MockBloc`、`MockCubit`、`Mock implements ServiceFactory`、`MockSettingsBackupService` 之類的測試替身驅動，但實際上它們大多只需要固定 state、少量事件紀錄與簡單 service 回傳。

## 問題陳述

這批測試目前有四個問題：

1. `SettingsBloc` / `SubscriptionBloc` / `SyncBloc` / `AIBloc` / `PGPKeysCubit` 的狀態控制，普遍被 `whenListen`、`when`、`verify` 主導，測試焦點落在 mock framework，而不是 UI 對 state 的反應。
2. `ServiceFactory`、`SettingsBackupService`、`BiometricService`、`PGPService` 這類依賴大多只需要極小的假物件，但目前仍用 `Mock implements ...` 重複宣告。
3. `appearance_settings_page_test.dart` 仍保留 generated mocks，與這批 widget 測試的整體方向不一致。
4. 這 15 支 settings page 測試持續讓 `test/widget/presentation/pages/settings` 群組維持最大 mock-heavy 子群。

## 使用者故事

### US1: 以手寫 bloc/cubit 替身驅動 settings page 測試

作為維護者，我們希望 settings page 測試改以 hand-written bloc / cubit / state harness 驅動，直接驗證畫面渲染、互動和事件派送。

#### 驗收條件

1. 這批 widget/page 測試不再依賴 `mocktail Mock`、`MockBloc` 或 generated mocks。
2. 測試以真實 `BlocProvider` / `Cubit` 假物件與 state stream 驅動畫面，不再靠 `whenListen` 或 `verify` 控制。
3. bloc / cubit / service 測試替身集中在共用 `test/support/fakes/` 或合理的測試內 helper，不重複散落。

### US2: 以手寫 service / factory fake 驅動 settings 互動流程

作為維護者，我們希望 `ServiceFactory`、`SettingsBackupService`、`BiometricService`、`PGPService` 等依賴改成手寫 fake，直接驗證 page 行為與資料流。

#### 驗收條件

1. service / factory 依賴改成可讀的手寫 fake，支援最小必要功能。
2. 測試驗證的是 widget tree、導航、按鈕互動與 state 變化，不是 mock verify 次數。
3. `appearance_settings_page_test.dart` 的 generated `.mocks.dart` 依賴完全移除。

### US3: 清掉 settings page 群組的 mock framework 依賴

作為維護者，我們希望 batch 26 的 `settings` page 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 規則。

#### 驗收條件

1. 這批對應 `.mocks.dart` 已刪除。
2. batch 26 檔案與共用 fake 檔中已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。
3. targeted tests、`flutter analyze --fatal-infos` 與搜尋驗證通過。

## 非目標

- 不修改 production page API 或 bloc/cubit 公開介面。
- 不在本批次處理 `test/widget/presentation/widgets` 或 `test/unit/presentation/blocs` 群組。
- 不擴大處理 backend mock-heavy 測試。

## 成功指標

- 這 15 支 settings page widget 測試改由 hand-written bloc / cubit / service fake 驅動。
- batch 26 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- `test/widget/presentation/pages/settings` 這個最大 mock-heavy 子群在本批次完成後顯著下降。
