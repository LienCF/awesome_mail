# Spec: 批次 48 presentation blocs 單檔 mock 清理

## 背景

Flutter 剩餘的 mock-heavy 檔案中，`awesome_mail_flutter/test/presentation/blocs` 還殘留 10 支單檔測試，分散使用 `mocktail`、`MockBloc` 與 `registerFallbackValue`。這一組都屬於 presentation bloc / cubit 測試，依賴型態高度相近，適合一起改成 hand-written fake / recorder。

## 目標

1. 將下列 10 支測試改成不依賴 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc` 或 `MockCubit`
   - `awesome_mail_flutter/test/presentation/blocs/account/account_cubit_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/account_setup/account_setup_bloc_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/automation/automation_bloc_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/compose/compose_bloc_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/download_progress/download_progress_cubit_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/email/attachment_action_cubit_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/folder/folder_cubit_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/productivity/productivity_bloc_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/search/search_bloc_vector_test.dart`
   - `awesome_mail_flutter/test/presentation/blocs/sync_progress/sync_progress_cubit_test.dart`
2. 優先重用既有 `test/support/fakes/*`，僅在現有 fake 無法支撐時才補最小必要的 hand-written fake / recorder
3. 保留 bloc / cubit 測試對狀態轉換、事件派送、依賴互動與錯誤處理的驗證力
4. 通過 batch 48 targeted tests、搜尋驗證與 `flutter analyze --fatal-infos`

## 非目標

- 不擴大到 `test/presentation/pages/*`、`test/presentation/ai/*`、`test/core/*`、`test/data/*` 的剩餘單檔
- 不修改 production bloc / cubit 行為，除非改寫過程揭露真實缺陷且必須補回歸測試
- 不進入 backend mock-heavy 測試

## 驗收條件

- 上述 10 支測試不再出現 `mockito`、`mocktail`、`@GenerateMocks`、`extends Mock`、`MockBloc`、`MockCubit`、`.mocks.dart`
- batch 48 相關 targeted tests 全部通過
- `flutter analyze --fatal-infos` 通過且無新增 issue
- `tdd-audit-report.md` 更新本批次結果與剩餘數量
