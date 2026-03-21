> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# Spec: 批次 59 backend integration fake 收斂

## 背景

backend 剩餘 mock-heavy 主體已集中在 `tests/integration` 的 10 支整合測試。這批要把 auth、AI、subscription、sync、cron 與 OAuth 類整合測試移出 `vi.fn` / interaction-style mock，改成以 hand-written env / KV / D1 / service fake 驅動，維持整合路徑的真實資料流驗證。

## 目標

1. 清掉 `tests/integration` 10 支測試內的 mock framework 關鍵字。
2. 整合測試改成以 hand-written env / persistence fake 驗證完整 request flow。
3. targeted tests、搜尋驗證與 `npm run quality:check` 全部通過。

## 非目標

1. 不處理 `tests/unit/database` 與零星 backend/Flutter 尾端檔案。
2. 不變更 production API 行為，除非整合測試揭露真實缺陷。

## 驗收標準

1. `rg` 檢查 batch 59 範圍內不再出現 `vi.fn`、`vi.mock`、`vi.spyOn`、`mockResolvedValue`、`mockRejectedValue`、`mockImplementation`、`.mock`、`Mocked<` 與 `as Mock`。
2. `npx vitest run` 執行 batch 59 的 10 支整合測試全部通過。
3. `awesome-mail` 的 `npm run quality:check` 通過，且沒有新增 lint / type-check / coverage 問題。
