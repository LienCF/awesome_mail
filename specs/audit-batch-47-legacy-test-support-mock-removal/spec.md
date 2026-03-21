# Spec: 批次 47 legacy 測試基礎設施 mock 清理

## 背景

Flutter 剩餘的 mock-heavy 檔案已經收斂成零星單檔，其中一組集中在舊測試基礎設施與直接依賴它的 home/router 測試。這組包含 `test/support/mocks/*`、`test/support/test_app_shell.dart`、`test/test_helpers.dart`，以及直接使用這些支援檔的 `app_router_test.dart` 與 `macos_home_page_ai_test.dart`。目前主要違規來自 `mocktail`、`mockito` 與 `MockCubit`。

## 目標

1. 將下列 6 個檔案改成不依賴 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 或 `MockCubit`
   - `awesome_mail_flutter/test/support/mocks/mock_services.dart`
   - `awesome_mail_flutter/test/support/mocks/mock_attachment_cubit.dart`
   - `awesome_mail_flutter/test/support/test_app_shell.dart`
   - `awesome_mail_flutter/test/test_helpers.dart`
   - `awesome_mail_flutter/test/widget/core/routing/app_router_test.dart`
   - `awesome_mail_flutter/test/presentation/pages/home/macos_home_page_ai_test.dart`
2. 以 hand-written fake / recorder 取代 legacy 測試基礎設施中的 service、bloc 與 cubit mock
3. 保留 router 與 MacOS home AI 測試對事件派送、state 同步與 compose/drawer 行為的驗證力
4. 通過 batch 47 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不擴大到其餘 `test/presentation/blocs/*`、`test/presentation/pages/*`、`test/core/*` 單檔
- 不修改 `AppRouter`、`MacOSHomePage`、`TestHelpers` 的對外行為，除非改寫過程揭露真實缺陷
- 不進入 backend mock-heavy 測試

## 驗收條件

- 上述 6 個檔案不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit`、`.mocks.dart`
- batch 47 相關 targeted tests 與依賴 `TestAppShell` 的 home regression tests 全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
