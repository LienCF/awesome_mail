# Spec: 批次 38 presentation pages mock 清理

## 背景

batch 37 已清空 test/unit/presentation/blocs 的 mailbox mock-heavy 測試。重新掃描後，Flutter 剩餘最大群組落在 test/unit/presentation/pages，目前命中的 14 個結果中有 5 個是 generated .mocks.dart，實際要改的是 9 支 page/controller 測試：

- awesome_mail_flutter/test/unit/presentation/pages/account_setup/account_setup_page_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/account_setup/gmail_setup_widget_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/auth/biometric_setup_page_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/auth/login_page_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/auth/signup_page_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/home/home_action_controller_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/home/utils/home_keyboard_handler_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/sync/qr_generator_page_test.dart
- awesome_mail_flutter/test/unit/presentation/pages/sync/qr_scanner_page_test.dart

這些測試目前混用 mockito、mocktail 與 MockBloc。專案內其實已經有 TestAuthBloc、TestSyncBloc、TestMailboxBloc、FakeBiometricService 等手寫替身，可進一步收斂成 page 測試可共用的 fake 組合。

## 問題陳述

1. auth / sync / home controller 測試仍綁在 verify(...) 與 generated mock，造成維護成本與重構阻力。
2. account setup 與 Gmail setup 測試各自內嵌依賴替身，沒有共用 recorder，後續頁面測試無法複用。
3. test/unit/presentation/pages 群組若不清掉，Flutter 剩餘 mock-heavy 最大群組就無法往前推進。

## 使用者故事

### US1: page 測試改用手寫 fake / recorder

作為維護者，我們希望 auth、sync、home、account setup 頁面測試改用 hand-written fake / recorder，直接驗證 state 與事件。

#### 驗收條件

1. 上述 9 支測試不再使用 mockito、mocktail、MockBloc 或 @GenerateMocks。
2. auth / sync / home 測試改以 recorded events、state 與畫面輸出驗證。
3. account setup / Gmail setup 測試可共用手寫 fake，而不是各自嵌一排 mock。

### US2: batch 38 範圍內的 generated mocks 清空

作為維護者，我們希望 test/unit/presentation/pages 在本批次後不再殘留 batch 38 範圍內的 generated .mocks.dart 與相關參照。

#### 驗收條件

1. batch 38 涵蓋的 .mocks.dart 檔案可刪除。
2. targeted tests、搜尋驗證與 flutter analyze --fatal-infos 通過。
3. test/unit/presentation/pages 群組在審計快照中清為 0。

## 非目標

- 不修改 production page / bloc 的公開 API。
- 不在本批次處理 test/widget/presentation/widgets 或 backend 測試。

## 成功指標

- 9 支 page/controller 測試改為 hand-written fake / recorder 驅動。
- test/unit/presentation/pages 群組完成後降為 0。
- batch 38 targeted tests、搜尋驗證與 flutter analyze --fatal-infos 通過。
