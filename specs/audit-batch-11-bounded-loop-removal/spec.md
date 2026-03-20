# Spec: 批次 11 有界迴圈與遍歷清理

## 背景

批次 8 已移除高優先的 polling、延遲重試與背景處理器 `while` 控制流，但專案內仍有一批有界 `while` 迴圈殘留在快取淘汰、祖先遍歷、字串清理與測試用 mock provider 中。這些迴圈不一定造成 busy polling，但仍違反專案「避免 while loop」的開發規範，也讓控制流可讀性與可測試性下降。

本批次只處理局部、有界、可在單一模組內驗證的 `while` 迴圈。IMAP parser、Gmail 分頁同步與 job retry 等較高耦合流程，留待下一批獨立處理。

## 問題陳述

目前下列模組仍存在 `while` 迴圈，且可以用更清楚的遞迴、`for` 迭代或集合操作改寫：

- `awesome_mail_flutter/lib/shared/widgets/performance/image_cache.dart`
- `awesome_mail_flutter/lib/data/services/batch_operations/batch_operation_service.dart`
- `awesome_mail_flutter/lib/data/cache/cache_manager.dart`
- `awesome_mail_flutter/lib/presentation/widgets/email/email_minimal_webview.dart`
- `awesome_mail_flutter/lib/core/utils/overflow_debugger.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_summary.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/structured_element_detector.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_sanitizer.dart`
- `awesome_mail_flutter/lib/data/providers/foundation/_foundation_ai_provider_core.dart`
- `awesome-mail/src/services/ai-provider-mock.ts`

如果不處理，稽核報告中的 `while` 類違規仍無法歸零，也會讓後續 parser / sync 類批次難以聚焦。

## 使用者故事

### US1: 快取與歷史清理流程不再依賴 `while`

作為維護者，我們希望快取淘汰、歷史截斷等有界資料結構操作用更直接的控制流表示，讓行為更清楚且容易測試。

#### 驗收條件

1. `ImageCache` 的空間淘汰不使用 `while`。
2. `BatchOperationService` 的歷史截斷不使用 `while`。
3. `CacheManager` 的記憶體快取淘汰不使用 `while`。
4. 既有對應測試全部通過，且淘汰 / 截斷行為不變。

### US2: 遍歷與祖先查找不再依賴 `while`

作為維護者，我們希望 DOM/Widget/HTML 節點遍歷改成明確的遞迴或 `for` 迭代，降低狀態變數與 break 條件交錯的複雜度。

#### 驗收條件

1. `email_minimal_webview.dart` 的連結祖先查找腳本不使用 `while`。
2. `overflow_debugger.dart` 的 Widget 樹向上遍歷不使用 `while`。
3. `structured_element_detector.dart` 的父層檢查不使用 `while`。
4. `_foundation_ai_provider_sanitizer.dart` 的 sibling 清除流程不使用 `while`。

### US3: 字串切片、尾端修剪與 mock entity 抽取不再依賴 `while`

作為維護者，我們希望字串處理與測試用 provider 掃描邏輯改成更可預測的流程，避免隱式狀態機。

#### 驗收條件

1. `_foundation_ai_provider_summary.dart` 的分段與壞尾移除不使用 `while`。
2. `_foundation_ai_provider_core.dart` 的 lookahead 掃描不使用 `while`。
3. `ai-provider-mock.ts` 的 regex 掃描改成 `matchAll` 或等價非 `while` 流程。
4. 對應測試涵蓋既有行為且全部通過。

## 非目標

- 不處理 `gmail_repository.dart` 的 `do/while` 分頁流程。
- 不處理 `email_synchronizer.dart`、`base-job.ts` 的 retry 控制流。
- 不處理 `imap_response_parser.dart` 的 parser 狀態機迴圈。

## 成功指標

- 本批次列入的檔案中，`rg -n "\\bwhile\\s*\\("` 不再命中。
- backend 與 Flutter 相關測試、分析器與型別檢查通過。
- `tdd-audit-report.md` 更新後，剩餘 `while` 類違規只留下 parser / sync 類批次。
