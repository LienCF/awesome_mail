# Apple Intelligence 內容簡化策略優化 - 測試計劃

## 文件資訊
- **版本**: 1.0.0
- **建立日期**: 2025-10-31
- **狀態**: Draft
- **關聯文件**: requirements.md, design.md, tasks.md

## 目錄
1. [測試策略](#1-測試策略)
2. [測試資料集](#2-測試資料集)
3. [單元測試](#3-單元測試)
4. [整合測試](#4-整合測試)
5. [效能測試](#5-效能測試)
6. [準確率驗證](#6-準確率驗證)
7. [A/B 測試](#7-ab-測試)
8. [驗收測試](#8-驗收測試)

---

## 1. 測試策略

### 1.1 測試金字塔

```
        ▲
       ╱E2E╲                 10% - 端對端測試
      ╱─────╲
     ╱Integ.╲               20% - 整合測試
    ╱─────────╲
   ╱   Unit    ╲            70% - 單元測試
  ╱─────────────╲
 ╱_______________╲
```

**單元測試 (70%)**:
- 每個類別、函數的獨立測試
- Mock 外部依賴（AI API, 資料庫）
- 快速執行（<100ms per test）
- 覆蓋率目標：≥90%

**整合測試 (20%)**:
- 多個組件協作測試
- 使用真實 AI API（或 mock server）
- 驗證資料流程
- 關鍵路徑覆蓋

**端對端測試 (10%)**:
- 完整使用者情境
- 真實裝置測試
- 效能與穩定性驗證

### 1.2 測試層級對應

| 測試類型 | 測試內容 | 執行頻率 | 時長 |
|---------|---------|---------|------|
| **Unit** | 類別方法、演算法邏輯 | 每次提交 | <5min |
| **Integration** | 組件協作、資料流程 | 每次 PR | <15min |
| **Performance** | 延遲、吞吐量基準 | 每日/週 | <30min |
| **Accuracy** | Phishing 檢測率、摘要品質 | 每週 | <1hr |
| **E2E** | 完整使用者流程 | 發布前 | <2hr |

### 1.3 測試環境

**開發環境**:
- macOS 26.0+ (Tahoe)
- Xcode 16+
- Flutter 3.x
- Dart 3.x

**測試裝置**:
- MacBook Pro (Apple Silicon, 16GB RAM)
- iMac (Intel, 8GB RAM) - 驗證相容性
- 模擬器 - 快速迭代

**CI/CD 環境**:
- GitHub Actions
- 自動執行 unit + integration tests
- 每日執行 performance tests

---

## 2. 測試資料集

### 2.1 Phishing 郵件資料集

**來源**:
1. PhishTank（公開資料集）
2. APWG（反釣魚工作組）
3. 內部收集（使用者回報，匿名化）
4. 合成資料（AI 生成的釣魚郵件）

**結構**:
```dart
class PhishingTestCase {
  final String id;
  final Email email;
  final ThreatLevel expectedLevel; // Ground truth
  final List<String> expectedIndicators;
  final PhishingType type; // credential, brand_impersonation, etc.
  final DateTime createdDate;
  final bool isAIGenerated;
}
```

**數量與分佈**:
- **總數**: 150 個樣本
- **類型分佈**:
  - Credential Phishing: 40%
  - Brand Impersonation: 30%
  - Invoice Scam: 15%
  - CEO Fraud: 10%
  - Other: 5%
- **語言**:
  - 繁體中文: 50%
  - 英文: 50%
- **AI 生成**:
  - AI Generated: 30%
  - Traditional: 70%

**檔案位置**:
```
test_datasets/
├── phishing/
│   ├── credential_phishing/
│   │   ├── 001_paypal_fake.json
│   │   ├── 002_bank_scam.json
│   │   └── ...
│   ├── brand_impersonation/
│   ├── invoice_scam/
│   └── metadata.json
```

---

### 2.2 合法郵件資料集

**來源**:
1. 常見服務通知（Gmail, Apple, Amazon 等）
2. 企業郵件範本
3. 訂閱電子報
4. 交易確認郵件

**挑戰案例** (重要):
- 含連結的銀行通知（易誤判為 phishing）
- 緊急性語氣的合法通知（如「您的訂單即將取消」）
- 促銷郵件（大量 CTA 按鈕）
- 帳單/發票（包含金額和截止日期）

**數量與分佈**:
- **總數**: 250 個樣本
- **類型分佈**:
  - 交易通知: 30%
  - 促銷郵件: 25%
  - 訂閱電子報: 20%
  - 企業通知: 15%
  - 個人郵件: 10%

**檔案位置**:
```
test_datasets/
├── legitimate/
│   ├── transaction/
│   ├── promotional/
│   ├── newsletter/
│   ├── enterprise/
│   └── metadata.json
```

---

### 2.3 結構化郵件資料集

**用途**: 測試 HTML → Markdown 轉換

**範例**:
- 財務報表（複雜表格）
- 訂單確認（表格 + 列表）
- 會議邀請（時間表格）
- 產品比較（多欄表格）
- 步驟說明（多層列表）

**數量**:
- 包含表格: 50 個
- 包含列表: 40 個
- 混合結構: 30 個

**驗證標準**:
- 表格結構保留率 >95%
- 列表層次正確（最多 3 層）
- 關鍵數字準確無誤

---

### 2.4 長郵件資料集

**用途**: 測試遞迴摘要與動態路由

**類別**:
- **短郵件** (<6000 chars): 100 個
- **中郵件** (6000-24000 chars): 60 個
- **長郵件** (>24000 chars): 40 個

**驗證**:
- 路由決策正確率 >95%
- 摘要保留關鍵資訊
- 延遲符合預期

---

## 3. 單元測試

### 3.1 PromptTemplateLibrary 測試

**檔案**: `test/unit/data/providers/foundation/prompt_template_library_test.dart`

**測試案例**:

```dart
group('PromptTemplateLibrary', () {
  test('all templates have required placeholders', () { ... });
  test('compact security template <= 1200 tokens', () { ... });
  test('detailed security template <= 1500 tokens', () { ... });
  test('compact summary template <= 1000 tokens', () { ... });
  test('standard summary template <= 1200 tokens', () { ... });
  test('templates include decision tree keywords', () { ... });
  test('JSON schema is valid', () { ... });
});
```

**覆蓋率目標**: 100%（所有 template getters）

---

### 3.2 OptimizedPromptBuilder 測試

**檔案**: `test/unit/data/providers/foundation/optimized_prompt_builder_test.dart`

**測試案例**:

```dart
group('OptimizedPromptBuilder', () {
  group('buildCompactSecurityPrompt', () {
    test('replaces all placeholders', () { ... });
    test('includes rule hints when present', () { ... });
    test('includes extracted elements', () { ... });
    test('respects token budget', () { ... });
    test('truncates content at sentence boundary', () { ... });
    test('selects compact template for LOW risk', () { ... });
    test('selects detailed template for MEDIUM+ risk', () { ... });
  });

  group('buildCompactSummaryPrompt', () {
    test('includes extracted dates and amounts', () { ... });
    test('respects token budget', () { ... });
  });

  group('_formatSecurityHints', () {
    test('formats rule indicators', () { ... });
    test('lists suspicious domains', () { ... });
    test('includes punycode/userinfo/homoglyph flags', () { ... });
    test('summarizes amounts', () { ... });
  });

  group('_calculateContentBudget', () {
    test('returns at least 500 tokens', () { ... });
    test('accounts for template + hints + metadata', () { ... });
    test('adjusts for long subjects', () { ... });
  });

  group('_truncateContent', () {
    test('returns full content if within budget', () { ... });
    test('truncates at paragraph boundary', () { ... });
    test('truncates at sentence boundary as fallback', () { ... });
    test('adds ellipsis indicator', () { ... });
  });
});
```

**覆蓋率目標**: ≥95%

---

### 3.3 ContentRouter 測試

**檔案**: `test/unit/data/providers/foundation/content_router_test.dart`

**測試案例**:

```dart
group('ContentRouter', () {
  group('route', () {
    test('selects fast path for short emails (<6k chars)', () { ... });
    test('selects standard path for medium emails (6-24k)', () { ... });
    test('selects complex path for long emails (>24k)', () { ... });
    test('considers token count in addition to char count', () { ... });
    test('security analysis uses conservative thresholds', () { ... });
    test('includes metrics in decision', () { ... });
  });

  group('canDowngrade', () {
    test('allows downgrade from complex path', () { ... });
    test('does not allow downgrade from fast/standard', () { ... });
  });
});
```

**覆蓋率目標**: 100%

---

### 3.4 FastPathProcessor 測試

**檔案**: `test/unit/data/providers/foundation/fast_path_processor_test.dart`

**測試案例**:

```dart
group('FastPathProcessor', () {
  group('analyzeSecurityFast', () {
    test('merges rule and AI analysis', () { ... });
    test('rule HIGH → final HIGH (no downgrade)', () { ... });
    test('rule LOW + AI HIGH → cap at MEDIUM', () { ... });
    test('rule MEDIUM + AI LOW → use rule', () { ... });
    test('falls back to rule on AI failure', () { ... });
    test('completes within 1.5s for short emails', () { ... });
    test('includes both rule and AI indicators', () { ... });
    test('confidence lower when using rule fallback', () { ... });
  });

  group('summarizeFast', () {
    test('generates summary for short email', () { ... });
    test('includes extracted elements in prompt', () { ... });
    test('completes within 1s', () { ... });
  });

  group('_mergeThreatLevel', () {
    test('HIGH + LOW → HIGH', () { ... });
    test('LOW + HIGH → MEDIUM (cap)', () { ... });
    test('MEDIUM + HIGH → HIGH', () { ... });
    test('CRITICAL + any → CRITICAL', () { ... });
  });
});
```

**覆蓋率目標**: ≥90%

---

### 3.5 HtmlToMarkdownConverter 測試

**檔案**: `test/unit/data/providers/foundation/html_to_markdown_converter_test.dart`

**測試案例**:

```dart
group('HtmlToMarkdownConverter', () {
  group('Table Conversion', () {
    test('simple table with headers', () { ... });
    test('table without headers', () { ... });
    test('table with merged cells', () { ... });
    test('nested tables (flattens)', () { ... });
    test('empty table cells', () { ... });
    test('table with special characters', () { ... });
  });

  group('List Conversion', () {
    test('unordered list', () { ... });
    test('ordered list', () { ... });
    test('nested list (2 levels)', () { ... });
    test('nested list (3 levels max)', () { ... });
    test('mixed ul and ol', () { ... });
    test('list with inline formatting', () { ... });
  });

  group('Link Conversion', () {
    test('simple link', () { ... });
    test('link without text (skip)', () { ... });
    test('link with special characters in URL', () { ... });
    test('mailto links', () { ... });
  });

  group('Error Handling', () {
    test('malformed HTML', () { ... });
    test('empty input', () { ... });
    test('only whitespace', () { ... });
    test('script/style tags removed', () { ... });
  });
});
```

**覆蓋率目標**: ≥95%

---

### 3.6 ContentExtractor 測試

**檔案**: `test/unit/data/providers/foundation/content_extractor_test.dart`

**測試案例**:

```dart
group('ContentExtractor', () {
  group('URL Extraction', () {
    test('extracts all URLs from content', () { ... });
    test('handles http and https', () { ... });
    test('handles URLs with query params', () { ... });
    test('handles URLs with anchors', () { ... });
    test('extracts eTLD+1 correctly', () { ... });
  });

  group('Domain Analysis', () {
    test('detects punycode domains', () { ... });
    test('detects userinfo in URLs', () { ... });
    test('detects Cyrillic homoglyphs', () { ... });
    test('detects Greek homoglyphs', () { ... });
    test('detects brand impersonation patterns', () { ... });
    test('handles IDN domains', () { ... });
  });

  group('Date Extraction', () {
    test('extracts ISO 8601 dates', () { ... });
    test('extracts MM/DD/YYYY dates', () { ... });
    test('extracts DD Mon YYYY dates', () { ... });
    test('handles invalid dates gracefully', () { ... });
  });

  group('Amount Extraction', () {
    test('extracts USD amounts', () { ... });
    test('extracts TWD amounts', () { ... });
    test('extracts EUR amounts', () { ... });
    test('handles thousands separators', () { ... });
    test('handles decimal points', () { ... });
    test('normalizes currency symbols', () { ... });
  });

  group('Phone Number Extraction', () {
    test('extracts +886 format', () { ... });
    test('extracts (02) format', () { ... });
    test('extracts 09xx format', () { ... });
  });
});
```

**覆蓋率目標**: ≥90%

---

## 4. 整合測試

### 4.1 Dynamic Routing Integration

**檔案**: `test/integration/dynamic_routing_integration_test.dart`

**測試情境**:

```dart
group('Dynamic Routing Integration', () {
  test('short email uses fast path', () async {
    final email = loadTestEmail('legitimate/transaction/amazon_order.json');

    final stopwatch = Stopwatch()..start();
    final analysis = await provider.analyzeSecurityThreats(email);
    stopwatch.stop();

    expect(analysis, isNotNull);
    expect(stopwatch.elapsedMilliseconds, lessThan(1500)); // Fast path
  });

  test('medium email uses standard path', () async {
    final email = loadTestEmail('legitimate/newsletter/tech_news.json');

    final stopwatch = Stopwatch()..start();
    final summary = await provider.summarizeContent(email);
    stopwatch.stop();

    expect(summary, isNotNull);
    expect(stopwatch.elapsedMilliseconds, lessThan(4000)); // Standard path
  });

  test('long email uses complex path or fallback', () async {
    final email = loadTestEmail('legitimate/newsletter/long_report.json');

    final stopwatch = Stopwatch()..start();
    final summary = await provider.summarizeContent(email);
    stopwatch.stop();

    expect(summary, isNotNull);
    expect(stopwatch.elapsedMilliseconds, lessThan(8000)); // Complex path
  });

  test('falls back to standard on fast path failure', () async {
    // Simulate fast path failure
    final email = createEdgeCaseEmail();

    final analysis = await provider.analyzeSecurityThreats(email);

    expect(analysis, isNotNull); // Should not throw
  });
});
```

---

### 4.2 Prompt Optimization Integration

**檔案**: `test/integration/prompt_optimization_integration_test.dart`

**測試情境**:

```dart
group('Prompt Optimization Integration', () {
  test('optimized prompts fit within token budget', () async {
    final testEmails = loadAllTestEmails();

    for (final email in testEmails) {
      // Capture actual prompt
      String? capturedPrompt;
      mockClient.whenSendPrompt((prompt) {
        capturedPrompt = prompt;
      });

      await provider.analyzeSecurityThreats(email);

      final tokens = tokenEstimator.estimate(capturedPrompt!);
      expect(tokens, lessThanOrEqualTo(3196),
        reason: 'Email ${email.id} prompt exceeds budget');
    }
  });

  test('content budget increases after optimization', () async {
    final longEmail = loadTestEmail('legitimate/newsletter/long_tech.json');

    String? capturedPrompt;
    mockClient.whenSendPrompt((prompt) {
      capturedPrompt = prompt;
    });

    await provider.summarizeContent(longEmail);

    final bodyMatch = RegExp(r'Body:\s*(.+)', dotAll: true)
        .firstMatch(capturedPrompt!);
    final includedBody = bodyMatch?.group(1) ?? '';

    // Verify more content is included
    expect(includedBody.length, greaterThan(3000));
  });
});
```

---

### 4.3 HTML Enhancement Integration

**檔案**: `test/integration/html_enhancement_integration_test.dart`

**測試情境**:

```dart
group('HTML Enhancement Integration', () {
  test('table structure preserved in summary', () async {
    final email = loadTestEmail('structured/financial_report.json');

    final summary = await provider.summarizeContent(email);

    // Summary should mention key table data
    expect(summary.summary, contains('總金額'));
    expect(summary.keyPoints, anyElement(contains('\$')));
  });

  test('markdown tables readable by AI', () async {
    final email = loadTestEmail('structured/order_confirmation.json');

    final summary = await provider.summarizeContent(email);

    // Should correctly extract order items
    expect(summary.keyPoints.length, greaterThanOrEqualTo(2));
  });

  test('fallback to plain text on conversion error', () async {
    final email = loadTestEmail('structured/malformed_html.json');

    final summary = await provider.summarizeContent(email);

    expect(summary, isNotNull); // Should not fail
  });
});
```

---

### 4.4 Content Extraction Integration

**檔案**: `test/integration/content_extraction_integration_test.dart`

**測試情境**:

```dart
group('Content Extraction Integration', () {
  test('extracted URLs improve security analysis', () async {
    final phishingEmail = loadTestEmail('phishing/credential_phishing/001.json');

    final analysis = await provider.analyzeSecurityThreats(phishingEmail);

    // Should detect punycode/userinfo from extracted URLs
    expect(analysis.indicators, contains('punycode_domain'));
    expect(analysis.threatLevel.index, greaterThanOrEqualTo(ThreatLevel.high.index));
  });

  test('extracted amounts included in summary', () async {
    final transactionEmail = loadTestEmail('legitimate/transaction/payment.json');

    final summary = await provider.summarizeContent(transactionEmail);

    // Should mention exact amount
    expect(summary.keyPoints, anyElement(contains('\$1,234.56')));
  });

  test('extracted dates included in summary', () async {
    final deadlineEmail = loadTestEmail('legitimate/enterprise/project_deadline.json');

    final summary = await provider.summarizeContent(deadlineEmail);

    expect(summary.actionItems, anyElement(contains('2025-11-15')));
  });
});
```

---

## 5. 效能測試

### 5.1 延遲基準測試

**檔案**: `test/performance/latency_benchmark_test.dart`

**測試案例**:

```dart
group('Latency Benchmarks', () {
  late List<int> fastPathLatencies;
  late List<int> standardPathLatencies;
  late List<int> complexPathLatencies;

  setUpAll(() async {
    // Warm up
    await provider.prewarm();
  });

  test('Fast Path: p50 <800ms, p95 <1.5s', () async {
    fastPathLatencies = [];

    for (var i = 0; i < 100; i++) {
      final email = generateShortEmail();

      final stopwatch = Stopwatch()..start();
      await provider.analyzeSecurityThreats(email);
      fastPathLatencies.add(stopwatch.elapsedMilliseconds);
    }

    fastPathLatencies.sort();
    final p50 = fastPathLatencies[(fastPathLatencies.length * 0.5).floor()];
    final p95 = fastPathLatencies[(fastPathLatencies.length * 0.95).floor()];

    expect(p50, lessThan(800));
    expect(p95, lessThan(1500));

    print('Fast Path - p50: ${p50}ms, p95: ${p95}ms');
  });

  test('Standard Path: p50 <2.5s, p95 <4s', () async {
    standardPathLatencies = [];

    for (var i = 0; i < 50; i++) {
      final email = generateMediumEmail();

      final stopwatch = Stopwatch()..start();
      await provider.summarizeContent(email);
      standardPathLatencies.add(stopwatch.elapsedMilliseconds);
    }

    standardPathLatencies.sort();
    final p50 = standardPathLatencies[(standardPathLatencies.length * 0.5).floor()];
    final p95 = standardPathLatencies[(standardPathLatencies.length * 0.95).floor()];

    expect(p50, lessThan(2500));
    expect(p95, lessThan(4000));

    print('Standard Path - p50: ${p50}ms, p95: ${p95}ms');
  });

  test('Complex Path: p50 <6s, p95 <8s', () async {
    complexPathLatencies = [];

    for (var i = 0; i < 20; i++) {
      final email = generateLongEmail();

      final stopwatch = Stopwatch()..start();
      await provider.summarizeContent(email);
      complexPathLatencies.add(stopwatch.elapsedMilliseconds);
    }

    complexPathLatencies.sort();
    final p50 = complexPathLatencies[(complexPathLatencies.length * 0.5).floor()];
    final p95 = complexPathLatencies[(complexPathLatencies.length * 0.95).floor()];

    expect(p50, lessThan(6000));
    expect(p95, lessThan(8000));

    print('Complex Path - p50: ${p50}ms, p95: ${p95}ms');
  });
});
```

---

### 5.2 吞吐量測試

**檔案**: `test/performance/throughput_test.dart`

**測試案例**:

```dart
group('Throughput Tests', () {
  test('can process 10 short emails concurrently', () async {
    final emails = List.generate(10, (_) => generateShortEmail());

    final stopwatch = Stopwatch()..start();
    await Future.wait(
      emails.map((email) => provider.analyzeSecurityThreats(email)),
    );
    stopwatch.stop();

    final avgLatency = stopwatch.elapsedMilliseconds / 10;

    expect(avgLatency, lessThan(2000)); // Should benefit from concurrency
  });

  test('does not exceed concurrent request limit', () async {
    var concurrentRequests = 0;
    var maxConcurrent = 0;

    mockClient.whenSendPrompt((prompt) async {
      concurrentRequests++;
      maxConcurrent = max(maxConcurrent, concurrentRequests);

      await Future.delayed(Duration(milliseconds: 500));

      concurrentRequests--;
    });

    final emails = List.generate(10, (_) => generateShortEmail());
    await Future.wait(
      emails.map((email) => provider.analyzeSecurityThreats(email)),
    );

    expect(maxConcurrent, lessThanOrEqualTo(3)); // Apple Intelligence limit
  });
});
```

---

### 5.3 資源使用測試

**檔案**: `test/performance/resource_usage_test.dart`

**測試案例**:

```dart
group('Resource Usage Tests', () {
  test('token estimation cache reduces CPU usage', () async {
    final content = generateLongText(10000);

    // Uncached
    final stopwatch1 = Stopwatch()..start();
    tokenEstimator.estimate(content);
    final uncachedTime = stopwatch1.elapsedMicroseconds;

    // Cached
    final stopwatch2 = Stopwatch()..start();
    tokenEstimator.estimate(content);
    final cachedTime = stopwatch2.elapsedMicroseconds;

    expect(cachedTime, lessThan(uncachedTime * 0.1)); // >10x faster
  });

  test('memory usage stable after 100 emails', () async {
    final initialMemory = getCurrentMemoryUsage();

    for (var i = 0; i < 100; i++) {
      final email = generateRandomEmail();
      await provider.analyzeSecurityThreats(email);
    }

    final finalMemory = getCurrentMemoryUsage();
    final memoryIncrease = finalMemory - initialMemory;

    expect(memoryIncrease, lessThan(20 * 1024 * 1024)); // <20MB
  });
});
```

---

## 6. 準確率驗證

### 6.1 Phishing 檢測準確率

**檔案**: `test/accuracy/phishing_detection_test.dart`

**評估指標**:

```dart
class DetectionMetrics {
  int truePositives = 0;   // Phishing → detected
  int falsePositives = 0;  // Legitimate → detected
  int trueNegatives = 0;   // Legitimate → not detected
  int falseNegatives = 0;  // Phishing → not detected

  double get recall => truePositives / (truePositives + falseNegatives);
  double get precision => truePositives / (truePositives + falsePositives);
  double get fpr => falsePositives / (falsePositives + trueNegatives);
  double get f1Score => 2 * (precision * recall) / (precision + recall);
}
```

**測試**:

```dart
group('Phishing Detection Accuracy', () {
  test('achieves >=85% recall (True Positive Rate)', () async {
    final phishingDataset = await loadPhishingDataset(); // 150 samples
    final metrics = DetectionMetrics();

    for (final testCase in phishingDataset) {
      final analysis = await provider.analyzeSecurityThreats(testCase.email);

      if (analysis.threatLevel.index >= ThreatLevel.medium.index) {
        metrics.truePositives++;
      } else {
        metrics.falseNegatives++;
      }
    }

    expect(metrics.recall, greaterThanOrEqualTo(0.85),
      reason: 'Recall: ${(metrics.recall * 100).toStringAsFixed(1)}% (target: ≥85%)');

    print('Phishing Detection Recall: ${(metrics.recall * 100).toStringAsFixed(1)}%');
  });

  test('achieves <=12% False Positive Rate', () async {
    final legitDataset = await loadLegitimateDataset(); // 250 samples
    final metrics = DetectionMetrics();

    for (final testCase in legitDataset) {
      final analysis = await provider.analyzeSecurityThreats(testCase.email);

      if (analysis.threatLevel.index >= ThreatLevel.medium.index) {
        metrics.falsePositives++;
      } else {
        metrics.trueNegatives++;
      }
    }

    expect(metrics.fpr, lessThanOrEqualTo(0.12),
      reason: 'FPR: ${(metrics.fpr * 100).toStringAsFixed(1)}% (target: ≤12%)');

    print('False Positive Rate: ${(metrics.fpr * 100).toStringAsFixed(1)}%');
  });

  test('achieves >=86% F1 Score', () async {
    final allDataset = await loadAllSecurityDataset();
    final metrics = DetectionMetrics();

    for (final testCase in allDataset) {
      final analysis = await provider.analyzeSecurityThreats(testCase.email);
      final detected = analysis.threatLevel.index >= ThreatLevel.medium.index;

      if (testCase.expectedLevel.index >= ThreatLevel.medium.index) {
        // Ground truth: Phishing
        if (detected) {
          metrics.truePositives++;
        } else {
          metrics.falseNegatives++;
        }
      } else {
        // Ground truth: Legitimate
        if (detected) {
          metrics.falsePositives++;
        } else {
          metrics.trueNegatives++;
        }
      }
    }

    expect(metrics.f1Score, greaterThanOrEqualTo(0.86));

    print('Precision: ${(metrics.precision * 100).toStringAsFixed(1)}%');
    print('Recall: ${(metrics.recall * 100).toStringAsFixed(1)}%');
    print('F1 Score: ${(metrics.f1Score * 100).toStringAsFixed(1)}%');
  });
});
```

---

### 6.2 摘要品質評估

**檔案**: `test/accuracy/summary_quality_test.dart`

**評估方法**:

1. **自動化評估** (ROUGE, BERTScore)
2. **人工評估** (5 點量表)

**測試**:

```dart
group('Summary Quality Assessment', () {
  test('ROUGE-L score >=0.4', () async {
    final testCases = await loadSummaryTestCases(); // With reference summaries

    var totalRougeL = 0.0;

    for (final testCase in testCases) {
      final summary = await provider.summarizeContent(testCase.email);

      final rougeL = calculateRougeL(
        candidate: summary.summary,
        reference: testCase.referenceSummary,
      );

      totalRougeL += rougeL;
    }

    final avgRougeL = totalRougeL / testCases.length;

    expect(avgRougeL, greaterThanOrEqualTo(0.4));

    print('Average ROUGE-L: ${avgRougeL.toStringAsFixed(3)}');
  });

  test('key points retention >=90%', () async {
    final testCases = await loadSummaryTestCases();

    var totalRetention = 0.0;

    for (final testCase in testCases) {
      final summary = await provider.summarizeContent(testCase.email);

      // Count how many reference key points are in summary
      var retained = 0;
      for (final refPoint in testCase.referenceKeyPoints) {
        if (summary.keyPoints.any((kp) => _isSimilar(kp, refPoint))) {
          retained++;
        }
      }

      totalRetention += retained / testCase.referenceKeyPoints.length;
    }

    final avgRetention = totalRetention / testCases.length;

    expect(avgRetention, greaterThanOrEqualTo(0.90));

    print('Key Points Retention: ${(avgRetention * 100).toStringAsFixed(1)}%');
  });

  test('preserves exact numbers and dates', () async {
    final testCases = await loadStructuredEmailTestCases();

    for (final testCase in testCases) {
      final summary = await provider.summarizeContent(testCase.email);

      // Extract numbers from original
      final originalNumbers = extractNumbers(testCase.email.body);

      // Check if important numbers are in summary
      for (final number in originalNumbers.where((n) => n.isImportant)) {
        expect(summary.summary + summary.keyPoints.join(' '),
          contains(number.value),
          reason: 'Missing important number: ${number.value}');
      }
    }
  });
});
```

---

## 7. A/B 測試

### 7.1 Prompt Template 比較

**目的**: 驗證精簡 prompt 不會嚴重降低準確率

**實驗設計**:

```dart
group('A/B Testing: Prompt Templates', () {
  late FoundationAIProvider optimizedProvider;
  late FoundationAIProvider baselineProvider;

  setUp(() {
    optimizedProvider = FoundationAIProvider(
      // Uses compact templates (1500 tokens)
    );

    baselineProvider = FoundationAIProvider(
      // Uses original templates (3000 tokens)
    );
  });

  test('optimized vs baseline accuracy delta <5%', () async {
    final testSet = await loadPhishingDataset();

    var optimizedCorrect = 0;
    var baselineCorrect = 0;

    for (final testCase in testSet) {
      final optimizedResult = await optimizedProvider.analyzeSecurityThreats(testCase.email);
      final baselineResult = await baselineProvider.analyzeSecurityThreats(testCase.email);

      if (_isCorrect(optimizedResult, testCase.expectedLevel)) {
        optimizedCorrect++;
      }

      if (_isCorrect(baselineResult, testCase.expectedLevel)) {
        baselineCorrect++;
      }
    }

    final optimizedAccuracy = optimizedCorrect / testSet.length;
    final baselineAccuracy = baselineCorrect / testSet.length;
    final delta = (baselineAccuracy - optimizedAccuracy).abs();

    expect(delta, lessThan(0.05),
      reason: 'Accuracy delta: ${(delta * 100).toStringAsFixed(1)}%');

    print('Optimized Accuracy: ${(optimizedAccuracy * 100).toStringAsFixed(1)}%');
    print('Baseline Accuracy: ${(baselineAccuracy * 100).toStringAsFixed(1)}%');
    print('Delta: ${(delta * 100).toStringAsFixed(1)}%');
  });

  test('optimized latency improvement >=50%', () async {
    final testEmail = generateMediumEmail();

    final optimizedLatencies = <int>[];
    final baselineLatencies = <int>[];

    for (var i = 0; i < 20; i++) {
      var stopwatch = Stopwatch()..start();
      await optimizedProvider.analyzeSecurityThreats(testEmail);
      optimizedLatencies.add(stopwatch.elapsedMilliseconds);

      stopwatch = Stopwatch()..start();
      await baselineProvider.analyzeSecurityThreats(testEmail);
      baselineLatencies.add(stopwatch.elapsedMilliseconds);
    }

    final optimizedAvg = optimizedLatencies.reduce((a, b) => a + b) / optimizedLatencies.length;
    final baselineAvg = baselineLatencies.reduce((a, b) => a + b) / baselineLatencies.length;
    final improvement = (baselineAvg - optimizedAvg) / baselineAvg;

    expect(improvement, greaterThanOrEqualTo(0.50));

    print('Optimized Avg Latency: ${optimizedAvg.toStringAsFixed(0)}ms');
    print('Baseline Avg Latency: ${baselineAvg.toStringAsFixed(0)}ms');
    print('Improvement: ${(improvement * 100).toStringAsFixed(1)}%');
  });
});
```

---

### 7.2 動態路由效果驗證

**測試**:

```dart
group('A/B Testing: Dynamic Routing', () {
  test('fast path vs standard path for short emails', () async {
    final shortEmails = List.generate(50, (_) => generateShortEmail());

    final fastPathLatencies = <int>[];
    final standardPathLatencies = <int>[];

    for (final email in shortEmails) {
      // Force fast path
      final stopwatch1 = Stopwatch()..start();
      await provider.analyzeSecurityFast(email);
      fastPathLatencies.add(stopwatch1.elapsedMilliseconds);

      // Force standard path
      final stopwatch2 = Stopwatch()..start();
      await provider.analyzeSecurityStandard(email);
      standardPathLatencies.add(stopwatch2.elapsedMilliseconds);
    }

    final fastAvg = fastPathLatencies.reduce((a, b) => a + b) / fastPathLatencies.length;
    final standardAvg = standardPathLatencies.reduce((a, b) => a + b) / standardPathLatencies.length;

    expect(fastAvg, lessThan(standardAvg * 0.5)); // At least 50% faster

    print('Fast Path Avg: ${fastAvg.toStringAsFixed(0)}ms');
    print('Standard Path Avg: ${standardAvg.toStringAsFixed(0)}ms');
  });
});
```

---

## 8. 驗收測試

### 8.1 Phase 1 驗收

**Checklist**:

```dart
group('Phase 1 Acceptance Tests', () {
  test('Prompt templates within token budget', () async {
    expect(tokenEstimator.estimate(templates.securityAnalysisCompact),
      lessThanOrEqualTo(1200));
    expect(tokenEstimator.estimate(templates.securityAnalysisDetailed),
      lessThanOrEqualTo(1500));
    expect(tokenEstimator.estimate(templates.summaryCompact),
      lessThanOrEqualTo(1000));
    expect(tokenEstimator.estimate(templates.summaryStandard),
      lessThanOrEqualTo(1200));
  });

  test('Content budget increased >=50%', () async {
    final longEmail = loadTestEmail('test_long_email.json');

    String? capturedPrompt;
    mockClient.whenSendPrompt((prompt) {
      capturedPrompt = prompt;
    });

    await optimizedProvider.analyzeSecurityThreats(longEmail);

    final bodyContent = extractBodyFromPrompt(capturedPrompt!);
    final tokens = tokenEstimator.estimate(bodyContent);

    expect(tokens, greaterThanOrEqualTo(1500)); // Previously ~1000
  });

  test('Phishing detection accuracy >=85%', () async {
    // (Already covered in accuracy tests)
  });

  test('All unit tests pass with >=90% coverage', () async {
    // Run via CI
  });
});
```

---

### 8.2 Phase 2-4 驗收

**類似結構，針對各 Phase 的需求驗證**

---

### 8.3 最終整合驗收

**檔案**: `test/acceptance/final_acceptance_test.dart`

```dart
group('Final System Acceptance', () {
  test('All success metrics met', () async {
    final metrics = await collectSystemMetrics();

    // Performance
    expect(metrics.avgLatency, lessThan(3000)); // <3s
    expect(metrics.shortEmailLatency, lessThan(1000)); // <1s

    // Accuracy
    expect(metrics.phishingDetectionRate, greaterThanOrEqualTo(0.85));
    expect(metrics.falsePositiveRate, lessThanOrEqualTo(0.12));

    // Quality
    expect(metrics.structureRetention, greaterThanOrEqualTo(0.90));
    expect(metrics.urlExtractionAccuracy, greaterThanOrEqualTo(0.98));
  });

  test('No regression in existing features', () async {
    // Run full test suite
    // Compare with baseline metrics
  });

  test('System stable under load', () async {
    // Process 100 emails
    // Check no memory leaks
    // Check no errors
  });
});
```

---

## 9. 測試報告

### 9.1 報告格式

**自動生成報告**（每次 CI 執行）:

```
=== AI Optimization Test Report ===

Date: 2025-10-31
Commit: abc123
Branch: feat/ai-optimization

## Unit Tests
Passed: 147 / 150
Failed: 3
Coverage: 92.3%

## Integration Tests
Passed: 28 / 30
Failed: 2

## Performance Tests
- Fast Path p95: 1.2s (target: <1.5s) PASS
- Standard Path p95: 3.8s (target: <4s) PASS
- Complex Path p95: 7.5s (target: <8s) PASS

## Accuracy Tests
- Phishing Detection: 87.3% (target: >=85%) PASS
- False Positive Rate: 10.2% (target: <=12%) PASS
- F1 Score: 88.1% (target: >=86%) PASS

## Overall: PASS
```

---

**文件結束**

所有規格文件已完成！您現在可以開始按照 tasks.md 的 TDD 流程進行實施。
