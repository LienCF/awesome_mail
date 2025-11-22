# Apple Intelligence 內容簡化策略優化 - 需求規格

## 文件資訊
- **版本**: 1.0.0
- **建立日期**: 2025-10-31
- **狀態**: Draft
- **負責人**: AI Optimization Team

## 1. 專案概述

### 1.1 背景

Awesome Mail Flutter 應用使用 Apple Intelligence (Foundation Models) 進行郵件的 AI 分析功能，包括：
- 安全威脅分析
- 內容摘要
- 實體擷取
- 回覆建議生成

然而，Apple Intelligence on-device model 存在嚴格的限制：
- **Context Window**: 4,096 tokens（包含輸入 + 輸出）
- **實際可用輸入空間**: 約 3,196 tokens（扣除輸出緩衝）

當前實作的主要問題：
1. **安全分析 Prompt Template 過於冗長**（~3000 tokens），導致內容預算僅 ~996 tokens
2. **缺乏針對不同長度郵件的優化策略**，所有郵件使用統一流程
3. **HTML 結構資訊遺失**，表格、列表被扁平化為純文字
4. **關鍵安全指標可能在摘要中遺失**，如 URL、金額等

### 1.2 目標

**主要目標**：
- 提升 AI 處理效能（平均延遲減少 60%）
- 增加內容預算（安全分析從 996 → 1500 tokens）
- 保留結構化資訊（表格、列表）
- 確保關鍵資訊不遺失

**次要目標**：
- 維持或提升準確率（Phishing 檢測 ≥85%）
- 降低 API 呼叫次數（-40%）
- 改善用戶體驗（短郵件 <1s 回應）

### 1.3 非目標

**不在此專案範圍內**：
- ❌ 訓練自定義 Model Adapters（延後至 Phase 2）
- ❌ 修改遠端 AI (Cloudflare Workers) 實作
- ❌ 重構整體 AI 架構（保持當前混合式架構）
- ❌ 增加新的 AI 功能（僅優化現有功能）

---

## 2. 需求分類

### 2.1 功能性需求

#### FR-1: Prompt Template 優化

**FR-1.1: 安全分析 Prompt 精簡**
- **需求**: 將安全分析 prompt template 從 ~3000 tokens 精簡至 ≤1500 tokens
- **優先級**: P0（最高）
- **接受標準**:
  - [ ] Template token 數 ≤1500
  - [ ] 內容預算 ≥1500 tokens
  - [ ] Phishing 檢測準確率 ≥85%
  - [ ] 誤報率 ≤12%

**FR-1.2: 摘要 Prompt 精簡**
- **需求**: 將摘要 prompt template 從 ~2000 tokens 精簡至 ≤1200 tokens
- **優先級**: P1
- **接受標準**:
  - [ ] Template token 數 ≤1200
  - [ ] 摘要品質評分 ≥4.0/5.0（人工評估）
  - [ ] 關鍵點保留率 ≥90%

**FR-1.3: 結構化輸出 (@Generable)**
- **需求**: 使用 Apple Foundation Models 的 @Generable 功能進行結構化輸出
- **優先級**: P1
- **接受標準**:
  - [ ] 所有 AI 回應使用 Swift struct 定義
  - [ ] JSON schema overhead 減少 ≥30%
  - [ ] 解析錯誤率 <1%

---

#### FR-2: 動態路由策略

**FR-2.1: Fast Path（短郵件優化）**
- **需求**: 對於長度 <6000 字元且 <2000 tokens 的郵件，使用單次 AI 呼叫處理
- **優先級**: P0
- **適用範圍**: 預估覆蓋 60% 的郵件
- **接受標準**:
  - [ ] 識別短郵件的準確率 >95%
  - [ ] 處理延遲 <1.5s（p95）
  - [ ] 準確率與 Standard Path 差異 <5%

**FR-2.2: Standard Path（中等郵件）**
- **需求**: 對於長度 6000-24000 字元的郵件，使用當前遞迴摘要策略
- **優先級**: P0
- **適用範圍**: 預估覆蓋 30% 的郵件
- **接受標準**:
  - [ ] 保持當前遞迴摘要邏輯
  - [ ] 使用優化後的 prompt template
  - [ ] 處理延遲 <4s（p95）

**FR-2.3: Complex Path（長郵件）**
- **需求**: 對於長度 >24000 字元的郵件，使用改良的處理策略
- **優先級**: P1
- **適用範圍**: 預估覆蓋 10% 的郵件
- **接受標準**:
  - [ ] 智能內容壓縮（保留關鍵資訊）
  - [ ] 支援 fallback 到遠端 AI（可選）
  - [ ] 處理延遲 <8s（p95）

**FR-2.4: 自動降級機制**
- **需求**: 當 Fast Path 處理失敗時，自動降級到 Standard Path
- **優先級**: P1
- **接受標準**:
  - [ ] 偵測失敗的準確率 >99%
  - [ ] 降級延遲增加 <500ms
  - [ ] 使用者無感知切換

---

#### FR-3: HTML 結構保留

**FR-3.1: HTML → Markdown 轉換**
- **需求**: 將 HTML 表格、列表轉換為 Markdown 格式（而非純文字）
- **優先級**: P1
- **接受標準**:
  - [ ] 表格轉換準確率 >95%
  - [ ] 列表層次保留（支援巢狀 3 層）
  - [ ] Token 增加 <20%（相比純文字）

**FR-3.2: 結構化元素識別**
- **需求**: 識別並標記重要的結構化元素（表格、列表、程式碼區塊）
- **優先級**: P2
- **接受標準**:
  - [ ] 識別準確率 >90%
  - [ ] 支援常見 email client 的 HTML 格式（Gmail, Outlook, Apple Mail）

**FR-3.3: Fallback 機制**
- **需求**: 當 Markdown 轉換失敗時，保留原始 HTML 或回退到純文字
- **優先級**: P1
- **接受標準**:
  - [ ] 偵測轉換失敗 >99%
  - [ ] Fallback 不造成功能中斷
  - [ ] 記錄失敗案例供分析

---

#### FR-4: 智能內容抽取

**FR-4.1: 關鍵元素抽取器**
- **需求**: 從郵件中抽取關鍵元素（URLs, 日期, 金額, 電話號碼）
- **優先級**: P1
- **接受標準**:
  - [ ] URL 抽取準確率 >98%
  - [ ] 日期識別準確率 >90%（支援多種格式）
  - [ ] 金額識別準確率 >95%（支援多幣種）
  - [ ] 電話號碼識別準確率 >85%（支援國際格式）

**FR-4.2: 域名分析**
- **需求**: 對抽取的 URL 進行域名分析（eTLD+1, punycode 檢測等）
- **優先級**: P0（安全關鍵）
- **接受標準**:
  - [ ] eTLD+1 抽取準確率 >99%
  - [ ] Punycode 檢測準確率 100%
  - [ ] Homoglyph 檢測準確率 >95%

**FR-4.3: 安全 Hints 生成**
- **需求**: 將抽取的資訊作為 hints 提供給 AI 安全分析
- **優先級**: P0
- **接受標準**:
  - [ ] Hints 格式化為簡潔文字（<200 tokens）
  - [ ] 提升安全分析準確率 ≥5%
  - [ ] 不增加整體延遲 >100ms

---

### 2.2 非功能性需求

#### NFR-1: 效能需求

**NFR-1.1: 延遲要求**
- **短郵件**（<6000 字元）：p50 <800ms, p95 <1.5s
- **中郵件**（6000-24000 字元）：p50 <2.5s, p95 <4s
- **長郵件**（>24000 字元）：p50 <6s, p95 <8s
- **整體平均**：相比當前實作減少 ≥60%

**NFR-1.2: 吞吐量要求**
- 支援併發處理 ≥3 個郵件（受 Foundation Models 併發限制）
- 處理隊列不阻塞 UI 操作

**NFR-1.3: 資源使用**
- CPU 使用率增加 <10%（相比當前）
- 記憶體使用增加 <20MB
- 電池消耗減少 ≥30%（因 API 呼叫減少）

---

#### NFR-2: 準確率需求

**NFR-2.1: Phishing 檢測**
- True Positive Rate (Recall): ≥85%
- False Positive Rate: ≤12%
- Precision: ≥88%
- F1 Score: ≥86%

**NFR-2.2: 摘要品質**
- 人工評估平均分數: ≥4.0/5.0
- 關鍵點保留率: ≥90%
- 行動項目識別率: ≥85%

**NFR-2.3: 實體抽取**
- URL 準確率: >98%
- 日期準確率: >90%
- 金額準確率: >95%

---

#### NFR-3: 可維護性需求

**NFR-3.1: 程式碼品質**
- 遵循 `very_good_analysis` linting 規則
- 測試覆蓋率 ≥90%
- 所有 public API 需有文件註解

**NFR-3.2: 可測試性**
- 所有核心邏輯可單獨測試（無 Apple Intelligence 依賴）
- 支援 mock AI responses for unit testing
- 提供測試工具（prompt token 計算器、內容壓縮驗證器等）

**NFR-3.3: 可觀測性**
- 記錄關鍵效能指標（延遲、token 使用量、API 呼叫次數）
- 記錄錯誤與降級事件
- 支援匯出分析資料（用於 A/B 測試）

---

#### NFR-4: 相容性需求

**NFR-4.1: 平台支援**
- macOS 26.0+ (Tahoe)
- iOS 26.0+（未來支援）
- 支援 Apple Silicon 和 Intel Mac

**NFR-4.2: Apple Intelligence 版本**
- Foundation Models framework 1.0+
- 支援 150k vocabulary tokenizer
- 相容未來 API 變更（使用 version check）

**NFR-4.3: 向後相容**
- 保持現有 AI provider 介面不變
- 遠端 AI fallback 機制正常運作
- 不影響其他模組（Email Repository, Sync Service 等）

---

## 3. 用戶故事

### US-1: 短郵件快速分析
**身份**: 郵件使用者
**需求**: 查看簡短郵件的安全分析結果
**目的**: 快速判斷郵件是否安全，無需等待

**驗收標準**:
- [ ] 打開郵件後，安全分析在 1 秒內完成
- [ ] 顯示清晰的威脅等級（LOW/MEDIUM/HIGH/CRITICAL）
- [ ] 提供簡明的風險指標說明

---

### US-2: 長郵件結構化摘要
**身份**: 郵件使用者
**需求**: 閱讀包含表格的長郵件（如財務報表、訂單確認）
**目的**: 快速理解表格內容，無需滾動查看完整 HTML

**驗收標準**:
- [ ] 摘要包含表格的關鍵資訊（如總金額、項目數量）
- [ ] 表格結構保持可讀性（Markdown 格式）
- [ ] 關鍵數字準確無誤

---

### US-3: Phishing 郵件準確偵測
**身份**: 郵件使用者
**需求**: 收到可疑的 phishing 郵件
**目的**: 立即得到警告，避免點擊惡意連結

**驗收標準**:
- [ ] 偵測到 HIGH/CRITICAL 威脅時顯示明顯警告
- [ ] 指出具體的風險指標（如「userinfo@host URL」）
- [ ] 提供安全建議（如「不要點擊任何連結」）

---

### US-4: 合法郵件誤報最小化
**身份**: 郵件使用者
**需求**: 收到來自銀行/企業的合法通知
**目的**: 不被誤導為 phishing，正常處理郵件

**驗收標準**:
- [ ] 誤報率 <12%
- [ ] 提供信心分數（如「85% 確信為 MEDIUM 風險」）
- [ ] 允許使用者回報誤報（未來功能）

---

## 4. 技術約束

### 4.1 Apple Intelligence 限制
- ✅ Context Window: 4,096 tokens（硬限制，不可突破）
- ✅ 併發請求限制: 通常 ≤3（裝置效能相關）
- ✅ 輸出長度: 建議 ≤900 tokens（保留給模型回應）
- ✅ Tokenizer: 150k vocabulary（繁體中文 ~0.8 tokens/char）

### 4.2 效能約束
- ✅ Time-to-First-Token: ~0.6ms/token（Apple 官方數據）
- ✅ Generation Speed: ~30 tokens/s
- ✅ 預期單次呼叫延遲: 600ms（TTFT）+ 輸出時間

### 4.3 資料約束
- ✅ Email 平均長度: 3,000 字元（~1,200 tokens）
- ✅ Email 長度分佈:
  - 60%: <6,000 字元
  - 30%: 6,000-24,000 字元
  - 10%: >24,000 字元

---

## 5. 成功指標

### 5.1 效能指標

| 指標 | 當前 | 目標 | 測量方法 |
|------|------|------|---------|
| 平均延遲 | 5-8s | <3s | p50 latency |
| 短郵件延遲 | 5s | <1s | p95 latency (<6k chars) |
| 長郵件延遲 | 8-12s | <6s | p95 latency (>24k chars) |
| API 呼叫次數 | 基準 | -40% | 每封郵件平均呼叫數 |
| Token 使用效率 | 基準 | +200% | 內容 tokens / 總 tokens |

### 5.2 品質指標

| 指標 | 當前 | 目標 | 測量方法 |
|------|------|------|---------|
| Phishing 檢測率 | 88%* | ≥85% | True Positive Rate |
| 誤報率 | 8%* | ≤12% | False Positive Rate |
| 結構保留率 | 0% | ≥90% | 表格/列表正確轉換率 |
| URL 抽取準確率 | ~80%* | ≥98% | 抽取的 URL 正確率 |
| 摘要品質評分 | ~3.8/5* | ≥4.0/5 | 人工評估（5 點量表） |

*當前數值為預估，需實際測量

### 5.3 開發效率指標

| 指標 | 目標 |
|------|------|
| 測試覆蓋率 | ≥90% |
| 文件完整度 | 100%（所有 public API） |
| Linting 通過率 | 100% |
| 實作時程 | 8 週內完成 |

---

## 6. 風險與緩解

### 6.1 技術風險

**風險 R-1: Prompt 精簡導致準確率下降**
- **可能性**: 高
- **影響**: 高
- **緩解措施**:
  - ✅ A/B 測試逐步精簡，每步驗證準確率
  - ✅ 保留所有 HIGH risk indicators 定義
  - ✅ 實作 fallback 機制（低信心度使用完整 prompt）
  - ✅ 建立監控面板追蹤誤報率

**風險 R-2: 短內容單次呼叫遺失上下文**
- **可能性**: 中
- **影響**: 中
- **緩解措施**:
  - ✅ 使用保守閾值（6000 字元而非 12000）
  - ✅ 規則 hints 提供額外上下文
  - ✅ 自動降級機制（失敗時切換到遞迴策略）

**風險 R-3: Markdown 轉換錯誤**
- **可能性**: 中
- **影響**: 低
- **緩解措施**:
  - ✅ 使用成熟的 html package
  - ✅ Fallback 機制（解析失敗保留原 HTML）
  - ✅ 針對常見 email templates 全面測試

### 6.2 專案風險

**風險 R-4: Apple API 變更**
- **可能性**: 低（短期），中（長期）
- **影響**: 高
- **緩解措施**:
  - ✅ 使用 version check 確保相容性
  - ✅ 抽象化 Foundation Models 呼叫（易於替換）
  - ✅ 保持遠端 AI fallback 機制

**風險 R-5: 時程延誤**
- **可能性**: 中
- **影響**: 中
- **緩解措施**:
  - ✅ 採用 MVP 方法（優先實作 P0 功能）
  - ✅ 每週 review 進度
  - ✅ 預留 20% buffer time

---

## 7. 階段規劃

### Phase 1: Prompt Optimization（Week 1-2）
- **目標**: Template 從 3000 → 1500 tokens
- **P0 需求**: FR-1.1, FR-1.3
- **成功標準**: 內容預算 ≥1500 tokens, 準確率 ≥85%

### Phase 2: Dynamic Routing（Week 3-4）
- **目標**: 實作 Fast/Standard/Complex Path
- **P0 需求**: FR-2.1, FR-2.2, FR-2.4
- **成功標準**: 平均延遲 <3s, 短郵件 <1s

### Phase 3: HTML Enhancement（Week 5-6）
- **目標**: Markdown 轉換（表格、列表）
- **P1 需求**: FR-3.1, FR-3.3
- **成功標準**: 結構保留率 >90%

### Phase 4: Content Extraction（Week 7-8）
- **目標**: 智能內容抽取器
- **P1 需求**: FR-4.1, FR-4.2, FR-4.3
- **成功標準**: URL 準確率 >98%, 安全分析提升 +5%

---

## 8. 驗收標準

### 8.1 Phase 1 驗收

**必要條件**（所有必須滿足）:
- [ ] 安全分析 prompt template ≤1500 tokens
- [ ] 內容預算 ≥1500 tokens
- [ ] Phishing 檢測準確率 ≥85%（基於測試集）
- [ ] 所有測試通過（覆蓋率 ≥90%）
- [ ] Linting 無錯誤

**充分條件**（至少滿足 2 項）:
- [ ] 誤報率 ≤10%（優於目標 12%）
- [ ] 摘要 prompt 也精簡至 ≤1200 tokens
- [ ] 使用者回饋正面（測試用戶 ≥5 人）

### 8.2 Phase 2 驗收

**必要條件**:
- [ ] 短郵件（<6k chars）延遲 p95 <1.5s
- [ ] 整體平均延遲 <3s
- [ ] Fast Path 準確率與 Standard Path 差異 <5%
- [ ] 自動降級機制正常運作（測試失敗案例）

**充分條件**:
- [ ] API 呼叫次數減少 ≥40%
- [ ] CPU 使用率增加 <10%
- [ ] 無使用者察覺的功能降級

### 8.3 Phase 3 驗收

**必要條件**:
- [ ] 表格轉換準確率 >95%
- [ ] 列表層次保留（支援巢狀 3 層）
- [ ] Token 增加 <20%
- [ ] Fallback 機制正常運作

**充分條件**:
- [ ] 支援 ≥10 種常見 email templates
- [ ] 轉換失敗率 <1%
- [ ] 摘要品質評分提升 ≥0.3 分

### 8.4 Phase 4 驗收

**必要條件**:
- [ ] URL 抽取準確率 >98%
- [ ] Punycode 檢測準確率 100%
- [ ] 安全分析準確率提升 ≥5%（相對值）
- [ ] 延遲增加 <100ms

**充分條件**:
- [ ] 日期識別準確率 >95%
- [ ] 金額識別準確率 >98%
- [ ] Homoglyph 檢測準確率 >98%

### 8.5 整體專案驗收

**所有 Phase 完成後，需滿足**:
- [ ] 所有 P0 需求實作完成
- [ ] 至少 80% 的 P1 需求實作完成
- [ ] 所有成功指標達標（或有合理解釋）
- [ ] 完整的技術文件（design.md, API 文件）
- [ ] 使用者驗收測試通過（≥10 位測試用戶）
- [ ] 效能回歸測試通過（無明顯效能降低）
- [ ] 安全審查通過（無新增的安全漏洞）

---

## 9. 參考資料

### 9.1 Apple 官方文件
- [TN3193: Managing the on-device foundation model's context window](https://developer.apple.com/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window)
- [Foundation Models Framework](https://developer.apple.com/documentation/foundationmodels)
- [WWDC25 Session 248: Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/)
- [Apple Foundation Models 2025 Updates](https://machinelearning.apple.com/research/apple-foundation-models-2025-updates)

### 9.2 業界最佳實踐
- [Token Efficiency and Compression Techniques in LLMs (2025)](https://medium.com/@anicomanesh/token-efficiency-and-compression-techniques-in-large-language-models-navigating-context-length-05a61283412b)
- [10 Best Practices for Apple Foundation Models Framework](https://datawizz.ai/blog/apple-foundations-models-framework-10-best-practices-for-developing-ai-apps)
- [Phishing Threat Intelligence Report 2025](https://strongestlayer.com/)

### 9.3 內部文件
- `lib/data/providers/foundation/foundation_ai_provider.dart` - 當前實作
- `lib/data/services/simple_security_analyzer.dart` - 規則檢查
- `.kiro/design.md` - 整體架構設計

---

## 10. 附錄

### 10.1 術語表

| 術語 | 定義 |
|------|------|
| **Context Window** | LLM 可處理的最大 token 數（輸入 + 輸出） |
| **Token** | 模型處理的基本單位（約 4 字元英文或 0.8-1.2 字元中文） |
| **eTLD+1** | Effective Top-Level Domain + 1（如 `example.com`） |
| **Punycode** | 國際化域名編碼（如 `xn--`） |
| **Homoglyph** | 視覺上相似的字元（如 Cyrillic `а` vs Latin `a`） |
| **TTFT** | Time-to-First-Token（首個 token 生成延遲） |
| **@Generable** | Apple Foundation Models 的結構化輸出功能 |

### 10.2 測試資料集需求

**Phishing 郵件樣本**:
- [ ] 至少 100 個已標註的 phishing 郵件
- [ ] 涵蓋類型: credential phishing, brand impersonation, CEO fraud, invoice scam
- [ ] 時期: 2024-2025（包含 AI-generated phishing）
- [ ] 語言: 繁體中文 50%, 英文 50%

**合法郵件樣本**:
- [ ] 至少 200 個已標註的合法郵件
- [ ] 涵蓋類型: 交易通知, 促銷郵件, 訂閱電子報, 企業通知
- [ ] 包含挑戰案例: 含連結的銀行通知, 急迫性語氣的合法通知

**結構化郵件樣本**:
- [ ] 至少 50 個包含表格的郵件（財務報表, 訂單確認等）
- [ ] 至少 30 個包含多層列表的郵件
- [ ] 涵蓋主流 email client 格式（Gmail, Outlook, Apple Mail）

---

**文件結束**

下一步：請參閱 `design.md` 了解技術設計細節。
