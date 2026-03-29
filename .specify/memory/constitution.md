# Awesome Mail Constitution

## Core Principles

### I. Detroit School TDD（不可妥協）

實作前必須先寫失敗的測試（Red → Green → Refactor）。
不允許跳過測試階段。不允許存在 skipped 測試。
每次變更後執行完整測試套件並回報確切通過數量。

### II. Tidy First

結構性變更與行為性變更分離，不可混合在同一個 commit。
- 結構性變更：重新排列程式碼但不改變行為
- 行為性變更：新增或修改實際功能

### III. Specification First

所有功能必須先有規格定義，再進行實作規劃和任務拆分。
流程：specify → clarify → plan → tasks → implement。

### IV. 語言規範

所有文件、註解使用台灣繁體中文，採用台灣慣用詞彙，避免中國大陸用語。
識別符號（變數、函式、類別）維持英文。
編輯現有檔案時，英文註解或文件內容一併改為繁體中文（台灣用語）。
常見台灣/中國用語對照（台灣 vs 中國）：全端 vs 全棧、音訊 vs 音頻、視訊 vs 視頻、二進位 vs 二進制、智慧 vs 智能、複製 vs 克隆、資訊 vs 信息、軟體 vs 軟件、硬體 vs 硬件、網路 vs 網絡、程式 vs 程序、位元組 vs 字節、伺服器 vs 服務器、記憶體 vs 內存。

### V. 程式碼品質

徹底消除重複。保持方法小且專注單一職責。
最小化狀態與副作用。使用最簡單可行的解決方案。
避免 while loop 或 polling，優先使用事件驅動、async/await。

## 技術約束

- 主要語言：[LANGUAGE]
- 測試框架：[TEST_FRAMEWORK]
- 避免過度工程化，只做直接需要的變更
- 不符合原則的程式碼應主動修復、改寫或重構
- 不需要保留向後相容性，可直接進行破壞性變更

## 開發工作流程

1. 使用 spec-kit 定義規格（/speckit.specify）
2. 透過 /speckit.clarify 釐清模糊之處
3. 用 /speckit.plan 建立實作計劃
4. 用 /speckit.tasks 產生任務清單
5. 用 /ralph-loop 執行 TDD 開發
6. 每完成一個任務項目就 commit

## Governance

Constitution 優先於所有其他慣例。修改需要文件化、審核、遷移計劃。
所有 PR/review 必須驗證合規性。複雜度必須有正當理由。

**Version**: 1.0.0 | **Ratified**: [DATE] | **Last Amended**: [DATE]
