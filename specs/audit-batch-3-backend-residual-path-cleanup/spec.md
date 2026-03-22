# 規格：backend 殘留 mock 路徑命名清理

## 背景

第二批完成後，backend 仍殘留少量以 `mock` 命名的檔案路徑與 helper API。雖然主要的 `Mock*` 類別已清除，這些舊命名仍讓測試支援層與模擬 AI provider 的語意不一致。

## 目標

1. 將 backend 仍以 `mock` 命名的檔案路徑改為 `simulated` 或 `test`
2. 同步更新匯入路徑與關聯 helper API 名稱
3. 保持 backend `quality:check` 全綠

## 使用情境與驗證

### US1：backend 測試支援檔使用一致命名

作為維護 backend 測試的開發者，我們需要 D1 helper、OAuth 模擬服務與 AI provider 的檔名、匯入與測試名稱都使用 `test` 或 `simulated` 語意，這樣程式結構才不會再殘留過時的 `mock` 路徑。

驗證方式：

- `awesome-mail/src` 與 `awesome-mail/tests` 的檔案路徑不再包含 `mock` 或 `Mock`
- `ai-service.ts`、OAuth setup helper、D1 helper 與對應測試都能以新檔名正常匯入

## 成功標準

- `rg --files awesome-mail/src awesome-mail/tests | rg "mock|Mock"` 無結果
- backend `npm run quality:check` 通過
