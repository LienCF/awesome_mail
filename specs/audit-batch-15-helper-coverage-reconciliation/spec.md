# Spec: 批次 15 helper coverage 對齊

## 背景

批次 14 已經校正一組 state / event 類缺測假陽性，但重新檢查 `tdd-audit-report.md` 後，還有另一組明顯的 helper 類檔案被誤列為缺測。這些檔案其實已經有對應測試檔，只是審計盤點沒有正確對上：

- repository helper：
  - `_email_query_operations.dart`
  - `_email_merge_helpers.dart`
  - `_email_save_operations.dart`
  - `_email_delete_operations.dart`
- foundation AI helper：
  - `_foundation_ai_provider_prompt_utils.dart`
  - `_foundation_ai_provider_sanitizer.dart`
  - `_foundation_ai_provider_security.dart`
  - `_foundation_ai_provider_core.dart`
  - `_foundation_ai_provider_summary.dart`

如果不把這批噪音清掉，後續缺測批次的估算仍會偏高，難以看出真正還沒補測的頁面、widget 與 handler 類檔案。

## 問題陳述

目前審計報告把 9 個已存在對應測試的 helper 檔案列為缺測，造成兩個問題：

1. Flutter 缺測總數高估。
2. 後續批次排序會被假陽性干擾，降低真正缺測項目的可見度。

## 使用者故事

### US1: helper 類缺測名單與真實測試對齊

作為維護者，我們希望 helper 類檔案只在真的沒有測試時才列入缺測，讓報告能正確反映剩餘工作量。

#### 驗收條件

1. 上述 9 個 helper 檔從缺測清單移除。
2. Flutter 缺測總數依這次校正下修。
3. 相關對應測試重新執行並通過。

## 非目標

- 不處理 `app_router.dart`、debug pages、settings sections 等真正可能缺測的 UI 類檔案。
- 不新增 production 程式碼。
- 不處理 batch 9 mock-heavy 測試清理。

## 成功指標

- 9 個 helper 假陽性從 `tdd-audit-report.md` 移除。
- 相關 targeted tests 通過。
- 報告中的 Flutter 缺測數下修到新的正確值。
