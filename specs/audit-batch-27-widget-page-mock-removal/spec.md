# Spec: 批次 27 widget page mock 清理

## 背景

批次 26 已清掉 `test/widget/presentation/pages/settings` 的 15 支 mock-heavy 測試，接下來 Flutter 在相同層級剩下的 mock-heavy 頁面測試主要集中在 `awesome_mail_flutter/test/widget/presentation/pages`，目前仍有 `16` 支 widget/page 測試依賴 `mocktail`、`mockito` 或 generated mocks：

- `account_setup/account_setup_page_test.dart`
- `ai/ai_classification_page_test.dart`
- `auth/oauth_login_page_test.dart`
- `automation/automation_page_test.dart`
- `batch/batch_operations_page_test.dart`
- `compose/compose_page_test.dart`
- `draft/draft_management_page_test.dart`
- `home/home_page_test.dart`
- `home/macos_home_page_test.dart`
- `search/search_page_test.dart`
- `splash/splash_page_test.dart`
- `subscription/subscription_analytics_page_test.dart`
- `subscription/subscription_page_impl_test.dart`
- `subscription/subscription_page_test.dart`
- `templates/advanced_template_management_page_test.dart`
- `templates/templates_page_impl_test.dart`

這些測試橫跨帳號設定、首頁、搜尋、訂閱、模板與撰寫頁面。它們普遍使用 `MockBloc`、`MockCubit`、`MockNavigatorObserver`、`MockServiceFactory` 或 generated `.mocks.dart` 來控制 state、導航與 service 回傳。

## 問題陳述

這批測試目前有四個問題：

1. page 測試大量仰賴 mock framework 的 `when`、`whenListen`、`verify`，測試焦點偏向互動腳本而不是畫面行為。
2. 多數頁面其實只需要固定 state、簡單事件紀錄、少量導覽結果與輕量 service 假物件，但目前重複宣告 `Mock` 類別。
3. `widget/presentation/pages` 仍是 Flutter mock-heavy 前幾大群組，代表 UI 頁面層還有一整段沒有轉成 Detroit School 風格測試。
4. 這批頁面之間共享不少依賴型態，如果不集中整理共用 fake，後續批次會持續複製相同的 mock boilerplate。

## 使用者故事

### US1: 以手寫 bloc/cubit/page harness 驅動單頁測試

作為維護者，我們希望單頁 page/widget 測試改以 hand-written bloc / cubit / state harness 驅動，直接驗證畫面渲染、互動與導航結果。

#### 驗收條件

1. 這批 page 測試不再依賴 `mocktail Mock`、`mockito`、`MockBloc` 或 generated mocks。
2. 測試以真實 `BlocProvider` / `Cubit` 假物件與可控 state 驅動畫面，不再靠 `whenListen` 或 `verify` 主導。
3. 導航驗證優先以實際 route 結果或可觀察狀態驗證，不靠 observer mock 次數。

### US2: 以手寫 service / factory fake 驅動複合頁面流程

作為維護者，我們希望 `ServiceFactory`、page controller、repository、分類/搜尋/模板相關 service 改用手寫 fake，直接驗證 page 行為與資料流。

#### 驗收條件

1. service / factory 依賴改成可讀的手寫 fake，支援最小必要功能。
2. 測試驗證的是 widget tree、狀態變化、按鈕互動與導航，不是 mock verify 次數。
3. 這批頁面對應的 generated `.mocks.dart` 依賴完全移除。

### US3: 清掉 widget page 群組的 mock framework 依賴

作為維護者，我們希望 batch 27 的 page 測試不再命中 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock` 規則。

#### 驗收條件

1. 這批對應 `.mocks.dart` 已刪除。
2. batch 27 檔案與共用 fake 檔中已無 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`。
3. targeted tests、`flutter analyze --fatal-infos`、搜尋驗證與 Flutter 全量回歸通過。

## 非目標

- 不修改 production page API、bloc/cubit 公開介面或路由行為。
- 不在本批次處理 `test/widget/presentation/widgets` 與 `test/unit/presentation/blocs`。
- 不擴大處理 backend mock-heavy 測試。

## 成功指標

- 這 16 支 widget/page 測試改由 hand-written bloc / cubit / service fake 驅動。
- batch 27 targeted tests 與 `flutter analyze --fatal-infos` 通過。
- `test/widget/presentation/pages` mock-heavy 群組在本批次完成後進一步下降。
