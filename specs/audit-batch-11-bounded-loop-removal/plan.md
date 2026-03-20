> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Plan: 批次 11 有界迴圈與遍歷清理

## 技術策略

1. 先為最容易回歸的 helper 或 service 補 red tests，明確鎖定淘汰、遍歷與字串掃描行為。
2. 使用遞迴、`for` 迭代、`removeRange`、`matchAll` 等方式取代有界 `while`，避免混入行為改動。
3. 每個子群組完成後跑對應測試；整批完成後再執行 backend / Flutter 驗證。

## 分批實作

### A. 快取與歷史截斷

- `image_cache.dart`
- `batch_operation_service.dart`
- `cache_manager.dart`

### B. 遍歷與結構清理

- `email_minimal_webview.dart`
- `overflow_debugger.dart`
- `structured_element_detector.dart`
- `_foundation_ai_provider_sanitizer.dart`

### C. 字串掃描與 mock provider

- `_foundation_ai_provider_summary.dart`
- `_foundation_ai_provider_core.dart`
- `ai-provider-mock.ts`

## 驗證策略

- Flutter:
  - 對應單元/元件測試
  - `flutter analyze`
- Backend:
  - 相關 unit tests
  - `npm run quality:check`
- 稽核:
  - 重新掃描本批次列入檔案的 `while`
  - 更新 `tdd-audit-report.md`
