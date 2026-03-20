# Spec: 批次 17 generated / barrel / example coverage 對齊

## 背景

批次 16 完成後，Flutter 缺測名單已縮到 14 檔。這份名單裡還混著一小批本質上不該當成「需要直接測試的 production module」的檔案：

- generated：
  - `firebase_options.dart`
  - `injection.config.dart`
- barrel / example：
  - `macos_components.dart`
  - `awesome_design_example.dart`
- internal operations：
  - `_foundation_ai_provider_operations.dart`

其中 generated / example / barrel 檔案本來就不適合用一般對應測試衡量，而 `_foundation_ai_provider_operations.dart` 則已透過 `foundation_ai_provider_test.dart` 與 foundation 子模組測試間接覆蓋。

## 問題陳述

若不把這批檔案從缺測清單移除，剩餘名單會混入不該補測的 generated / example / barrel 檔案，讓真正需要補測的 `app_router`、debug pages、自適應 widget 無法清楚浮現。

## 使用者故事

### US1: generated / barrel / example 類名單與真實測試策略對齊

作為維護者，我們希望 generated、example、barrel 與已被整體行為測試覆蓋的 internal operations 檔案，不再被誤列為缺測。

#### 驗收條件

1. 5 個檔案從缺測清單移除。
2. `foundation_ai_provider_test.dart` 重新執行並通過，作為 `_foundation_ai_provider_operations.dart` 的 coverage 依據。
3. Flutter 缺測總數再次下修。

## 非目標

- 不處理 `AdaptiveWidgets`、`MaybeSelectionArea`、`AppRouter` 與 debug pages 的真缺測。
- 不新增 production 程式碼。
- 不處理 Python 腳本缺測。

## 成功指標

- 5 個 generated / barrel / example / internal operations 假陽性從報告移除。
- `foundation_ai_provider_test.dart` 通過。
- `tdd-audit-report.md` 的剩餘 Flutter 缺測數反映最新結果。
