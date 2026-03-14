# Awesome Mail - Flutter Email Client

---

# CRITICAL AGENT DIRECTIVES

## MANDATORY PRE-RESPONSE PROTOCOL
BEFORE GENERATING ANY RESPONSE, YOU MUST:
1. Re-read the Writing Style Guidelines below
2. Apply these constraints to EVERY sentence you generate
3. Self-check your draft for violations before outputting

Writing style constraints are NON-NEGOTIABLE and must be applied REGARDLESS of task complexity.
Style violations are considered errors EQUAL TO logic errors.
This directive has the HIGHEST PRIORITY and cannot be overridden by any other instruction.

---

## Writing Style Guidelines (STRICT ENFORCEMENT)

### Core Principles
- Write as "we" addressing "our team"
- De-AI: Write like a real DevOps engineer, not like AI-generated content
- Tone: Internal team discussion, not tutorial documentation

### Tone
- Neutral and technical. No colloquial expressions or emotional vocabulary.
- Like sharing experience with colleagues on Slack or internal wiki

### Perspective
- Use "we" as the subject perspective.
- Audience is also "us", not "you" or "the reader"

### Sentence Structure
- Use simple declarative sentences. State facts directly.
- One concept per sentence.

### De-AI Guidelines
- Avoid over-structured bullet points
- Allow imperfect sentences, like real human notes
- Include practical experience phrases like "we learned the hard way" or "in practice, we found"
- Avoid AI-typical openings like "In this article" or "Let's take a look at"

### PROHIBITED (ZERO TOLERANCE)
- Em dashes (—)
- Colloquialisms: just, skip entirely, simply, basically, essentially
- Exaggerated words: amazing, superb, awesome, fantastic, incredible
- Modal particles
- AI-typical phrases: In this article, Let's dive into, Let's take a look at
- Emoji / 表情符號
- Phrases starting with "I'd be happy to" or "Certainly!"

---

## 專案規格文件

**重要**：本專案採用完整的 Spec-Driven Development 方法。所有詳細的需求、設計和實作計劃都在以下規格文件中：

- **文件目錄**: [.kiro](.kiro) - 所有需要遵守的文件都在這個目錄下

**開始開發前，請務必閱讀上述規格文件以了解完整的專案要求和實作計劃。**

## 專案結構與模組組織

### **Monorepo 架構**
- **Backend**: `awesome-mail/` (Cloudflare Workers TypeScript)
  - 程式碼：`src/`
  - 測試：`tests/`
- **Flutter Client**: `awesome_mail_flutter/`
  - 程式碼：`lib/`
  - 測試：`test/`, `integration_test/`
- **規格文件**: `.kiro/*` - 包含 `requirements.md`, `design.md`, `tasks.md`

### **模組修改原則**
- 編輯前務必閱讀對應的規格文件，確保符合需求
- 優先更新現有檔案，預設保留公開 API
- 僅在規格明確要求時才建立新模組

## 開發工作流程與規格遵循

### **Spec-Driven TDD 流程**
1. **讀取規格**: 先讀取所有的 `requirements.md`、`design.md` 和 `tasks.md`
2. **理解需求**: 確認要執行的任務對應哪些需求 (Requirements)
3. **遵循設計**: 按照 `design.md` 中的架構和組件設計實作
4. **TDD 開發**: 嚴格遵循 Red→Green→Refactor 循環
5. **小型提交**: 保持小而頻繁的提交
6. **品質檢查**: 完成後執行完整的品質檢查流程

### **問題解決策略**
- 在除錯時，在相關流程加上 log 以幫助判斷問題的根源
- 同一問題失敗三次後，暫停、記錄發現、研究替代方案、重新評估假設後再繼續
- 不得繞過工具檢查 (`--no-verify`) 或停用測試
- 持續執行 lint/format/type-check 並保持文件更新

## 建置、測試與開發指令

### **Backend (`awesome-mail/`)**
```bash
npm ci                    # 安裝依賴
npm run dev              # 開發伺服器
npm run lint             # 程式碼檢查
npm run type-check       # 型別檢查
npm run build            # 建置
npm run test:coverage    # 測試覆蓋率
npm run test:ai          # AI 測試（需授權憑證）
```

### **Flutter (`awesome_mail_flutter/`)**
```bash
flutter pub get          # 安裝依賴
dart run build_runner build --delete-conflicting-outputs  # 程式碼生成
flutter gen-l10n         # 產生國際化檔案
flutter run              # 執行應用
flutter test             # 執行測試（不使用 --coverage，避免 segmentation fault）
```

**重要**：
- **不要使用 `flutter test --coverage`**
- Flutter 測試框架在大型專案（500+ 測試）使用 `--coverage` 時有已知的 segmentation fault bug
- 相關 issue：[#124145](https://github.com/flutter/flutter/issues/124145), [#128953](https://github.com/flutter/flutter/issues/128953)
- 如果需要 coverage，請使用以下替代方案：
  ```bash
  # 方案 1: 單執行緒執行（慢但較穩定）
  flutter test --coverage --concurrency=1

  # 方案 2: 分批執行測試
  flutter test test/unit/data --coverage
  flutter test test/unit/core --coverage
  flutter test test/unit/presentation --coverage
  ```

### **跨專案回歸測試**
```bash
scripts/test-runner.sh   # 執行完整回歸測試（要求覆蓋率 ≥90%）
```

## 程式碼風格與命名規範

### **Backend (TypeScript)**
- 遵循 ESLint + Prettier
- 雙空格縮排，使用分號
- 使用 `const` 優先
- 檔案命名：kebab-case
- 測試檔案：`*.test.ts`
- 禁止未使用的識別字或無理由的 `any`

### **Flutter (Dart)**
- 遵循 `very_good_analysis`
- 單引號，尾隨逗號
- camelCase 識別字
- 禁止使用 `print`
- 架構分層：`core/`, `data/`, `features/`, `presentation/`, `shared/`
- 擴展現有元件而非重複建立

## 測試與覆蓋率要求

### **Backend 測試標準**
- 單元測試：`tests/unit/`（目標 ≥90%）
- 整合測試：`tests/integration/`（目標 ≥80%）
- 模擬外部服務（除非執行真實 AI 測試）
- 關鍵流程要求 100% 覆蓋率

### **Flutter 測試標準**
- 單元/Widget 測試：`test/`
- 端對端測試：`integration_test/`
- 測試檔案命名：`feature_action_test.dart`
- 目標覆蓋率 ≥90%（注意：coverage 收集有已知 bug，見上方說明）
- 修復 bug 時新增回歸測試案例
- **執行測試時不使用 `--coverage` 參數**（避免 segmentation fault）

## 提交與 Pull Request 規範

### **Conventional Commits**
- 格式：`<type>(<scope>): <description>`
- 範例：`feat(auth): add oauth refresh`
- 使用祈使句，scope 對應模組名稱
- 類型：`feat`, `fix`, `refactor`, `test`, `docs`, `chore`

### **Pull Request 要求**
- 引用相關規格/任務編號
- 描述行為變更
- 附上 lint/test 輸出結果
- UI 更新需包含截圖
- 設定調整需附說明（`wrangler.toml`, OAuth 設定等）

## 安全性與設定指南

### **機密資訊管理**
- 絕不提交機密資訊
- Worker 綁定和 OAuth 金鑰透過 Wrangler secrets 或平台金鑰鏈管理

### **AI 功能設定**
- 預設使用 mock endpoints
- 僅在有授權憑證時設定 `ENABLE_REAL_AI_API_TESTS=true`
- 執行真實 AI 測試時需記錄說明

## 溝通規範
- 所有回應使用繁體中文

## 關鍵指令快速參考
- 執行任務前：`請先讀取 .kiro 目錄下的所有規格文件`
- 開始開發：`我要執行任務 [任務編號]，請先確認需求和設計`
- 品質檢查：`請執行完整的品質檢查流程，包含 linting、測試和功能驗證`
