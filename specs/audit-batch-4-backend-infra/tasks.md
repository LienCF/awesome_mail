> **重要提醒**：請在執行每個項目之前，先讀取 CLAUDE.md，並在執行項目過程中完全遵守裡面的所有規範。

# 批次 4：Backend middleware/repositories 單元測試 + console.log 清理

## 任務清單

- [x] T1: 為 `src/middleware/security-headers.ts` (20行) 撰寫單元測試 -已完成
- [x] T2: 為 `src/middleware/cors.ts` (145行) 撰寫單元測試 -已完成
- [x] T3: 為 `src/repositories/sync-repository.ts` (127行) 撰寫單元測試 -已完成
- [x] T4: 為 `src/repositories/subscription-repository.ts` (303行) 撰寫單元測試 -已完成
- [x] T5: 清理 `src/database/init.ts` 中 console.log → 改用結構化 logger -已完成
- [x] T6: 清理 `src/database/migrations.ts` 中 console.log → 改用結構化 logger -已完成
- [x] T7: 清理 `src/jobs/*.ts` 中 console.log → 改用結構化 logger -已完成
- [x] T8: 清理 `src/index.ts`, `src/middleware/auth.ts`, `src/services/*.ts`, `src/routes/*.ts` 中 console.log → 改用結構化 logger -已完成
