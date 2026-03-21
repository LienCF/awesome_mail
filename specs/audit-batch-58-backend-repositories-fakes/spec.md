> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Spec: 批次 58 backend repositories fake 收斂

## 背景

backend `tests/unit/repositories` 仍有 6 支測試依賴 `vi.fn`、`mockResolvedValue` 與 `.mock` 類互動驗證，違反 Detroit School 對真實資料狀態與 hand-written fake 的要求。這批要把 OAuth provider、subscription、sync 與 user repository 測試統一改成手寫 D1 / KV fake 驅動，並維持 backend 全量品質閘為綠燈。

## 目標

1. 清掉 `tests/unit/repositories` 6 支測試內的 mock framework 關鍵字。
2. repository 測試改成以 hand-written D1 / KV fake 驗證持久化結果、欄位映射與錯誤路徑。
3. targeted tests、搜尋驗證與 `npm run quality:check` 全部通過。

## 非目標

1. 不修改 repository 對外 API。
2. 不順便清理 integration、database 或零星 backend/Flutter 檔案。
3. 不重寫 production repository 邏輯，除非測試揭露真實缺陷。

## 驗收標準

1. `rg` 檢查 batch 58 範圍內不再出現 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`。
2. `npx vitest run` 執行 batch 58 的 6 支 repository 測試全部通過。
3. `awesome-mail` 的 `npm run quality:check` 通過，且沒有新增 lint / type-check / coverage 問題。
