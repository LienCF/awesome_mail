> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Spec: 批次 60 尾端測試可測試性清理

## 背景

batch 59 完成後，backend 與 Flutter 還殘留少量不符合 Detroit School 偏好的尾端測試。這些檔案主要分成三類：以 spy/mock framework 操作全域物件的 logger / database init 測試、重複且低價值的舊測試殘留、以及 Flutter foundation client 對 testing-only API 的直接依賴。

## 目標

1. 讓 backend logger 與 database init 測試改由 hand-written fake 與顯式注入點驅動。
2. 刪除重複、只測 fake 自身、或屬於備份殘留的測試檔。
3. 收斂 Flutter foundation client 的 testing-only 依賴，改由既有 fake framework 驅動驗證。
4. 完成 targeted tests、搜尋驗證與跨堆疊靜態檢查。

## 非目標

1. 不擴大重寫仍在其他後續批次中的大型 Flutter mock-heavy 模組。
2. 不更動 production API 行為，除非測試可測試性收斂需要最小注入點。

## 驗收標準

1. 這批範圍內不再出現 `vi.spyOn`、`vi.mock`、`vi.fn`、`FoundationModelsFramework.mock()`、`foundation_models_framework/testing.dart`、`.bak` 測試殘留。
2. backend targeted tests 與 Flutter targeted tests 全部通過。
3. repo 重新掃描後，batch 60 納入範圍已不再被列為 mock-heavy / guard-only 違規。
