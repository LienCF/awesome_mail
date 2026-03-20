# Spec: 批次 14 state coverage 對齊與缺測修補

## 背景

批次 13 完成 provider HTTP fake client 去 mock 化後，我們重新檢查 batch 10 的 Flutter 缺測名單，發現其中一小群 state / event 類別存在兩種不同情況：

- 部分檔案其實已經被既有測試覆蓋，但因為測試檔名不是一對一對應 source 檔，審計報告仍把它們列成缺測。
- `mailbox_chip_state.dart` 目前沒有直接針對 state getter / copyWith / equality 的單元測試。

這會讓缺測統計偏高，也讓後續批次無法聚焦在真正未覆蓋的風險點。

## 問題陳述

目前這批 state coverage 有兩個問題：

1. `tdd-audit-report.md` 將已存在 coverage 的 state / event 檔列為缺測，造成假陽性。
2. `MailboxChipState` 雖然在 cubit 測試中被使用，但缺少直接鎖定 state 行為的單元測試。

如果不處理，缺測批次會持續帶著噪音推進，也不利於後續用更小批次清理真正未測的 widget / helper / handler 檔案。

## 使用者故事

### US1: state 缺測清單與真實 coverage 對齊

作為維護者，我們希望審計報告只列出真正沒有對應測試的檔案，避免後續批次把時間花在已經有 coverage 的項目。

#### 驗收條件

1. `account_state.dart`、`automation_event.dart`、`automation_state.dart`、`ai_status_state.dart`、`pgp_keys_state.dart` 從缺測清單移除。
2. Flutter 缺測總數依據這次校正更新。
3. 報告中保留這次校正的依據與範圍。

### US2: MailboxChipState 具備直接單元測試

作為維護者，我們希望 `MailboxChipState` 的 getter、`copyWith` 與 equality 有明確單元測試，避免之後修改 state 時只靠 cubit 測試間接保護。

#### 驗收條件

1. 新增 `mailbox_chip_state_test.dart`。
2. 測試涵蓋 `selectedChip`、`copyWith` 與 equality / props。
3. `flutter analyze --fatal-infos` 與相關 Flutter 測試通過。

## 非目標

- 不處理其他 widget / page / handler 類缺測項目。
- 不改動 `MailboxChipCubit` 或 production 行為。
- 不處理 batch 9 其他 mock-heavy 測試群。

## 成功指標

- `MailboxChipState` 直接測試通過。
- `tdd-audit-report.md` 的 Flutter 缺測數與清單反映這次校正後的結果。
- `flutter analyze --fatal-infos` 通過。
