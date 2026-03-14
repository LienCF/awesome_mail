> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 批次 1：Backend Routes 單元測試補全

審計發現 Routes 模組 0% 測試覆蓋率，以下任務依檔案大小由小到大排序。

## 任務清單

- [x] T1: 為 `src/routes/metrics.ts` (38行) 撰寫單元測試 -6 個測試通過
- [x] T2: 為 `src/routes/logs.ts` (43行) 撰寫單元測試，修正 z.any() 為強型別 -9 個測試通過
- [x] T3: 為 `src/routes/integrations.ts` (124行) 撰寫單元測試 -15 個測試通過
- [x] T4: 為 `src/routes/accounts.ts` (141行) 撰寫單元測試 -10 個測試通過
- [x] T5: 為 `src/routes/emails.ts` (276行) 撰寫單元測試 -15 個測試通過
- [x] T6: 為 `src/routes/oauth.ts` (329行) 撰寫單元測試 -38 個測試通過
- [x] T7: 為 `src/routes/sync.ts` (485行) 撰寫單元測試 -40 個測試通過
- [x] T8: 為 `src/routes/auth.ts` (709行) 撰寫單元測試 -49 個測試通過
- [x] T9: 為 `src/routes/ai.ts` (720行) 撰寫單元測試 -41 個測試通過
- [x] T10: 為 `src/routes/subscriptions.ts` (794行) 撰寫單元測試 -30 個測試通過
