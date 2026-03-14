# Apple Intelligence 內容簡化策略優化 - TDD 任務清單

## 文件資訊
- **版本**: 1.0.0
- **建立日期**: 2025-10-31
- **狀態**: Draft
- **關聯文件**: requirements.md, design.md

## 目錄
1. [TDD 開發流程](#1-tdd-開發流程)
2. [Phase 1: Prompt Template 優化](#2-phase-1-prompt-template-優化)
3. [Phase 2: Dynamic Routing](#3-phase-2-dynamic-routing)
4. [Phase 3: HTML Enhancement](#4-phase-3-html-enhancement)
5. [Phase 4: Content Extraction](#5-phase-4-content-extraction)

---

## 1. TDD 開發流程

### 1.1 基本原則

**遵循 Kent Beck TDD 循環**：

```
RED: 寫一個失敗的測試
    ↓
GREEN: 寫最少的代碼使測試通過
    ↓
REFACTOR: 重構代碼，保持測試通過
    ↓
(重複)
```

**核心規則**：
1. **先寫測試，再寫代碼**
2. **一次只寫一個測試**
3. **寫最少的代碼使測試通過**
4. **測試必須能執行並失敗**（驗證測試有效）
5. **重構前確保所有測試通過**
6. **每個功能獨立提交**（小型、頻繁提交）

### 1.2 任務標記說明

| 標記 | 含義 | 說明 |
|------|------|------|
| [RED] | RED | 寫失敗的測試 |
| [GREEN] | GREEN | 實作代碼使測試通過 |
| [REFACTOR] | REFACTOR | 重構（可選，視需要） |
| [完成] | DONE | 任務完成 |
| [提交] | COMMIT | 建議提交點 |

### 1.3 測試檔案組織

```
test/
├── unit/
│   └── data/
│       └── providers/
│           └── foundation/
│               ├── prompt_template_library_test.dart
│               ├── optimized_prompt_builder_test.dart
│               ├── content_router_test.dart
│               ├── fast_path_processor_test.dart
│               ├── html_to_markdown_converter_test.dart
│               ├── content_extractor_test.dart
│               └── enhanced_content_preprocessor_test.dart
│
└── integration/
    └── ai_optimization_integration_test.dart
```

---

## 2. Phase 1: Prompt Template 優化

**目標**: 將安全分析 prompt 從 3000 → 1500 tokens

**時程**: Week 1-2

### 2.1 建立基礎設施

#### Task 1.1: 創建 PromptTemplateLibrary 類別

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/prompt_template_library_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:awesome_mail_flutter/data/providers/foundation/prompt_template_library.dart';

void main() {
  group('PromptTemplateLibrary', () {
    late PromptTemplateLibrary library;

    setUp(() {
      library = PromptTemplateLibrary();
    });

    group('Security Analysis Templates', () {
      test('compact template exists', () {
        expect(library.securityAnalysisCompact, isNotEmpty);
      });

      test('compact template has required placeholders', () {
        final template = library.securityAnalysisCompact;

        expect(template, contains('{from}'));
        expect(template, contains('{subject}'));
        expect(template, contains('{hints}'));
        expect(template, contains('{body}'));
      });

      test('compact template includes decision tree', () {
        final template = library.securityAnalysisCompact;

        expect(template, contains('HIGH'));
        expect(template, contains('MEDIUM'));
        expect(template, contains('LOW'));
        expect(template, contains('userinfo@host'));
        expect(template, contains('punycode'));
      });

      test('detailed template exists', () {
        expect(library.securityAnalysisDetailed, isNotEmpty);
      });
    });

    group('Summary Templates', () {
      test('compact summary template exists', () {
        expect(library.summaryCompact, isNotEmpty);
      });

      test('compact summary template has required fields', () {
        final template = library.summaryCompact;

        expect(template, contains('{subject}'));
        expect(template, contains('{from}'));
        expect(template, contains('{body}'));
      });

      test('standard summary template exists', () {
        expect(library.summaryStandard, isNotEmpty);
      });
    });
  });
}
```

**執行測試**（應該失敗）:
```bash
flutter test test/unit/data/providers/foundation/prompt_template_library_test.dart
```

**GREEN: 實作代碼**

```dart
// lib/data/providers/foundation/prompt_template_library.dart

/// Prompt 模板庫
class PromptTemplateLibrary {
  /// 安全分析 - 精簡版（~1200 tokens）
  String get securityAnalysisCompact => '''
Analyze email security. Apply decision tree:

HIGH: userinfo@host | punycode | anchor≠href+(login|auth|verify)
MEDIUM: brand≠sender+urgency | suspicious_domain
LOW: default

Context:
From: {from}
Subject: {subject}

{hints}

Body:
{body}

Return JSON:
{
  "threatLevel": "low|medium|high|critical",
  "indicators": ["indicator1", "indicator2"],
  "confidence": 0.0-1.0,
  "reasoning": "brief explanation"
}
''';

  /// 安全分析 - 詳細版（~1500 tokens）
  String get securityAnalysisDetailed => '''
Email security analyst. Rule-based hints detected suspicious patterns.
Perform deep analysis to confirm or refute.

DECISION TREE:
├─ userinfo@host (user:pass@domain) → CRITICAL
├─ punycode domain (xn--) → HIGH
├─ anchor text ≠ href eTLD+1 + auth keywords → HIGH
├─ brand impersonation + urgency → MEDIUM
├─ suspicious TLD (.tk, .ml, .ga) + credential request → MEDIUM
└─ default → LOW

Metadata:
- From: {from}
- Subject: {subject}

Pre-detected indicators:
{hints}

Body:
{body}

Return structured analysis:
{
  "threatLevel": "low|medium|high|critical",
  "indicators": ["specific_indicator_1", "specific_indicator_2"],
  "confidence": 0.85,
  "reasoning": "Detected [X] which indicates [Y]. Combined with [Z], threat level is [LEVEL]."
}

Key points:
- Trust rule-based HIGH indicators (don't downgrade)
- Provide specific evidence for MEDIUM/HIGH/CRITICAL
- Confidence <0.7 requires human review
''';

  /// 摘要 - 精簡版（~1000 tokens）
  String get summaryCompact => '''
Summarize email concisely.

Subject: {subject}
From: {from}

Key elements:
{hints}

Body:
{body}

Return:
{
  "summary": "2-3 sentences",
  "keyPoints": ["point1", "point2", "point3"],
  "actionItems": ["action1", "action2"],
  "category": "transaction|promotional|notification|personal"
}

Guidelines:
- Focus on main message and purpose
- Extract dates, amounts, deadlines
- Identify required actions
''';

  /// 摘要 - 標準版（~1200 tokens）
  String get summaryStandard => '''
Generate structured email summary.

Metadata:
- Subject: {subject}
- From: {from}
- To: {to}

Extracted elements:
{hints}

Content:
{body}

Return JSON:
{
  "summary": "Clear, concise summary (max 200 chars)",
  "keyPoints": [
    "Most important point",
    "Second important point",
    "Third important point"
  ],
  "actionItems": [
    "Action required by user",
    "Another action if any"
  ],
  "category": "transaction|promotional|notification|personal|other",
  "sentiment": "positive|neutral|negative",
  "urgency": "low|medium|high"
}

Instructions:
1. Summary: Main message and sender's purpose
2. Key Points: Critical information (dates, amounts, deadlines)
3. Action Items: What recipient needs to do
4. Category: Best-fit classification
5. Preserve all numbers and dates exactly
6. Urgency: Based on language tone and deadlines
''';
}
```

**執行測試**（應該通過）:
```bash
flutter test test/unit/data/providers/foundation/prompt_template_library_test.dart
```

**COMMIT**: `feat(ai): add PromptTemplateLibrary with compact templates`

---

#### Task 1.2: Token 估算驗證

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/prompt_template_library_test.dart

import 'package:awesome_mail_flutter/core/utils/token_estimator.dart';

void main() {
  group('PromptTemplateLibrary', () {
    late PromptTemplateLibrary library;
    late TokenEstimator tokenEstimator;

    setUp(() {
      library = PromptTemplateLibrary();
      tokenEstimator = TokenEstimator();
    });

    group('Token Budget Validation', () {
      test('compact security template <= 1200 tokens', () {
        final template = library.securityAnalysisCompact;
        final tokens = tokenEstimator.estimate(template);

        expect(tokens, lessThanOrEqualTo(1200),
          reason: 'Compact security template must be <=1200 tokens, got $tokens');
      });

      test('detailed security template <= 1500 tokens', () {
        final template = library.securityAnalysisDetailed;
        final tokens = tokenEstimator.estimate(template);

        expect(tokens, lessThanOrEqualTo(1500),
          reason: 'Detailed security template must be <=1500 tokens, got $tokens');
      });

      test('compact summary template <= 1000 tokens', () {
        final template = library.summaryCompact;
        final tokens = tokenEstimator.estimate(template);

        expect(tokens, lessThanOrEqualTo(1000),
          reason: 'Compact summary template must be <=1000 tokens, got $tokens');
      });

      test('standard summary template <= 1200 tokens', () {
        final template = library.summaryStandard;
        final tokens = tokenEstimator.estimate(template);

        expect(tokens, lessThanOrEqualTo(1200),
          reason: 'Standard summary template must be <=1200 tokens, got $tokens');
      });
    });
  });
}
```

**執行測試**:
```bash
flutter test test/unit/data/providers/foundation/prompt_template_library_test.dart
```

**GREEN**: 如果測試失敗，調整 template 內容直到符合 token 限制

**REFACTOR**: 提取共用的片段，減少重複

**COMMIT**: `test(ai): validate prompt template token budgets`

---

### 2.2 實作 OptimizedPromptBuilder

#### Task 1.3: 建立 OptimizedPromptBuilder 基本結構

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/optimized_prompt_builder_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:awesome_mail_flutter/data/providers/foundation/optimized_prompt_builder.dart';
import 'package:awesome_mail_flutter/data/providers/foundation/prompt_template_library.dart';
import 'package:awesome_mail_flutter/core/utils/token_estimator.dart';
import 'package:awesome_mail_flutter/data/models/email.dart';

void main() {
  group('OptimizedPromptBuilder', () {
    late OptimizedPromptBuilder builder;
    late PromptTemplateLibrary templates;
    late TokenEstimator tokenEstimator;

    setUp(() {
      templates = PromptTemplateLibrary();
      tokenEstimator = TokenEstimator();
      builder = OptimizedPromptBuilder(
        templates: templates,
        tokenEstimator: tokenEstimator,
      );
    });

    group('buildCompactSecurityPrompt', () {
      test('replaces all placeholders', () {
        final email = Email(
          id: '1',
          subject: 'Test Subject',
          from: EmailAddress(email: 'sender@example.com', name: 'Sender'),
          to: [EmailAddress(email: 'recipient@example.com', name: 'Recipient')],
          body: 'Test body content',
          receivedDate: DateTime.now(),
        );

        final ruleHints = SimpleSecurityAnalysis(
          threatLevel: ThreatLevel.low,
          indicators: [],
        );

        final extracted = ExtractedElements(
          urls: [],
          domains: [],
          dates: [],
          amounts: [],
          phoneNumbers: [],
          imageCount: 0,
        );

        final prompt = builder.buildCompactSecurityPrompt(
          email: email,
          ruleHints: ruleHints,
          extractedElements: extracted,
        );

        expect(prompt, contains('sender@example.com'));
        expect(prompt, contains('Test Subject'));
        expect(prompt, contains('Test body content'));
        expect(prompt, isNot(contains('{from}')));
        expect(prompt, isNot(contains('{subject}')));
        expect(prompt, isNot(contains('{body}')));
      });

      test('includes rule hints when present', () {
        final email = Email(
          id: '1',
          subject: 'Urgent: Verify your account',
          from: EmailAddress(email: 'noreply@example.com', name: 'Example'),
          to: [],
          body: 'Click here: http://evil.com',
          receivedDate: DateTime.now(),
        );

        final ruleHints = SimpleSecurityAnalysis(
          threatLevel: ThreatLevel.high,
          indicators: ['punycode_domain', 'userinfo_in_url'],
        );

        final extracted = ExtractedElements(
          urls: [
            UrlInfo(
              url: 'http://user:pass@evil.com',
              anchorText: 'Click here',
              scheme: 'http',
              host: 'evil.com',
              eTldPlusOne: 'evil.com',
            ),
          ],
          domains: [
            DomainInfo(
              domain: 'evil.com',
              eTldPlusOne: 'evil.com',
              isPunycode: false,
              hasUserinfo: true,
              hasHomoglyph: false,
              suspiciousPatterns: [],
            ),
          ],
          dates: [],
          amounts: [],
          phoneNumbers: [],
          imageCount: 0,
        );

        final prompt = builder.buildCompactSecurityPrompt(
          email: email,
          ruleHints: ruleHints,
          extractedElements: extracted,
        );

        expect(prompt, contains('punycode_domain'));
        expect(prompt, contains('userinfo_in_url'));
        expect(prompt, contains('Suspicious domains'));
      });

      test('respects token budget', () {
        final longBody = 'Lorem ipsum ' * 1000; // Very long content

        final email = Email(
          id: '1',
          subject: 'Test',
          from: EmailAddress(email: 'test@example.com', name: 'Test'),
          to: [],
          body: longBody,
          receivedDate: DateTime.now(),
        );

        final ruleHints = SimpleSecurityAnalysis(
          threatLevel: ThreatLevel.low,
          indicators: [],
        );

        final extracted = ExtractedElements(
          urls: [],
          domains: [],
          dates: [],
          amounts: [],
          phoneNumbers: [],
          imageCount: 0,
        );

        final prompt = builder.buildCompactSecurityPrompt(
          email: email,
          ruleHints: ruleHints,
          extractedElements: extracted,
        );

        final totalTokens = tokenEstimator.estimate(prompt);

        expect(totalTokens, lessThanOrEqualTo(3196),
          reason: 'Total prompt must fit in context window');
      });
    });
  });
}
```

**執行測試**（應該失敗）:
```bash
flutter test test/unit/data/providers/foundation/optimized_prompt_builder_test.dart
```

**GREEN: 實作 OptimizedPromptBuilder**

```dart
// lib/data/providers/foundation/optimized_prompt_builder.dart

import 'dart:math';
import 'package:awesome_mail_flutter/data/providers/foundation/prompt_template_library.dart';
import 'package:awesome_mail_flutter/core/utils/token_estimator.dart';
import 'package:awesome_mail_flutter/data/models/email.dart';
import 'package:awesome_mail_flutter/data/services/simple_security_analyzer.dart';

/// Prompt 構建器
class OptimizedPromptBuilder {
  final PromptTemplateLibrary _templates;
  final TokenEstimator _tokenEstimator;

  const OptimizedPromptBuilder({
    required PromptTemplateLibrary templates,
    required TokenEstimator tokenEstimator,
  })  : _templates = templates,
        _tokenEstimator = tokenEstimator;

  /// 構建精簡安全分析 Prompt
  String buildCompactSecurityPrompt({
    required Email email,
    required SimpleSecurityAnalysis ruleHints,
    required ExtractedElements extractedElements,
  }) {
    // 1. 選擇模板
    final template = ruleHints.threatLevel >= ThreatLevel.medium
        ? _templates.securityAnalysisDetailed
        : _templates.securityAnalysisCompact;

    // 2. 格式化 hints
    final hints = _formatSecurityHints(ruleHints, extractedElements);

    // 3. 計算內容預算
    final contentBudget = _calculateContentBudget(template, hints, email);

    // 4. 截斷內容
    final truncatedBody = _truncateContent(email.body, contentBudget);

    // 5. 填充模板
    return template
        .replaceAll('{subject}', email.subject)
        .replaceAll('{from}', email.from.email)
        .replaceAll('{to}', email.to.map((e) => e.email).join(', '))
        .replaceAll('{hints}', hints)
        .replaceAll('{body}', truncatedBody);
  }

  /// 格式化安全 hints
  String _formatSecurityHints(
    SimpleSecurityAnalysis ruleAnalysis,
    ExtractedElements extracted,
  ) {
    final buffer = StringBuffer();

    // Rule-based indicators
    if (ruleAnalysis.indicators.isNotEmpty) {
      buffer.writeln('Detected: ${ruleAnalysis.indicators.join(", ")}');
    }

    // URLs summary
    if (extracted.urls.isNotEmpty) {
      buffer.writeln('URLs: ${extracted.urls.length}');

      // 列出可疑 URLs
      final suspicious = extracted.domains.where(
        (d) => d.isPunycode || d.hasUserinfo || d.hasHomoglyph,
      );

      if (suspicious.isNotEmpty) {
        buffer.writeln('Suspicious domains:');
        for (final domain in suspicious) {
          buffer.writeln('  - ${domain.domain}');
          if (domain.isPunycode) buffer.writeln('    (punycode)');
          if (domain.hasUserinfo) buffer.writeln('    (userinfo)');
          if (domain.hasHomoglyph) buffer.writeln('    (homoglyph)');
        }
      }
    }

    // Amounts summary
    if (extracted.amounts.isNotEmpty) {
      buffer.writeln(
        'Amounts: ${extracted.amounts.map((a) => a.rawText).join(", ")}',
      );
    }

    return buffer.toString();
  }

  /// 計算內容預算
  int _calculateContentBudget(String template, String hints, Email email) {
    const maxInput = 3196; // 4096 - 900 (output buffer)

    final templateTokens = _tokenEstimator.estimate(template);
    final hintsTokens = _tokenEstimator.estimate(hints);
    final metadataTokens = _estimateMetadataTokens(email);

    final available =
        maxInput - templateTokens - hintsTokens - metadataTokens;
    return max(500, available); // 最少保留 500 tokens
  }

  /// 估算 metadata tokens
  int _estimateMetadataTokens(Email email) {
    final metadata = '''
${email.subject}
${email.from.email}
${email.to.map((e) => e.email).join(', ')}
''';
    return _tokenEstimator.estimate(metadata);
  }

  /// 截斷內容
  String _truncateContent(String content, int budgetTokens) {
    final estimatedTokens = _tokenEstimator.estimate(content);

    if (estimatedTokens <= budgetTokens) {
      return content;
    }

    // 粗略估算需要保留的字元數
    final ratio = budgetTokens / estimatedTokens;
    final targetLength = (content.length * ratio * 0.9).floor(); // 保守 10%

    // 在句子邊界截斷
    final truncated = content.substring(0, min(targetLength, content.length));
    final lastPeriod = truncated.lastIndexOf(RegExp(r'[。.!?！？]\s*'));

    if (lastPeriod > targetLength * 0.7) {
      return '${truncated.substring(0, lastPeriod + 1)}…';
    }

    return '$truncated…';
  }
}
```

**執行測試**:
```bash
flutter test test/unit/data/providers/foundation/optimized_prompt_builder_test.dart
```

**COMMIT**: `feat(ai): implement OptimizedPromptBuilder`

---

#### Task 1.4: 整合到 FoundationAIProvider

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/foundation_ai_provider_test.dart

group('FoundationAIProvider with Optimized Prompts', () {
  test('uses compact prompt for low-risk emails', () async {
    // Setup
    final email = createLowRiskEmail();

    // Capture the actual prompt sent
    String? capturedPrompt;
    when(() => mockClient.sendPrompt(any())).thenAnswer((invocation) {
      capturedPrompt = invocation.positionalArguments[0] as String;
      return Future.value('{"threatLevel": "low", ...}');
    });

    // Execute
    await provider.analyzeSecurityThreats(email);

    // Verify: prompt includes decision tree keywords
    expect(capturedPrompt, contains('HIGH: userinfo@host'));
    expect(capturedPrompt, contains('MEDIUM: brand≠sender'));

    // Verify: prompt is compact
    final tokens = tokenEstimator.estimate(capturedPrompt!);
    expect(tokens, lessThan(3200)); // Fits in budget
  });

  test('content budget increases after prompt optimization', () async {
    final longEmail = createLongEmail(charCount: 10000);

    String? capturedPrompt;
    when(() => mockClient.sendPrompt(any())).thenAnswer((invocation) {
      capturedPrompt = invocation.positionalArguments[0] as String;
      return Future.value('{"threatLevel": "medium", ...}');
    });

    await provider.analyzeSecurityThreats(longEmail);

    // Extract body content from prompt
    final bodyMatch = RegExp(r'Body:\s*(.+)', dotAll: true)
        .firstMatch(capturedPrompt!);
    final includedBody = bodyMatch?.group(1) ?? '';

    // Verify: more content is included than before
    expect(includedBody.length, greaterThan(3000)); // Previously ~2000
  });
});
```

**GREEN: 修改 FoundationAIProvider 使用新的 PromptBuilder**

```dart
// lib/data/providers/foundation/foundation_ai_provider.dart

class FoundationAIProvider implements AIProvider {
  final FoundationModelClient _client;
  final SimpleSecurityAnalyzer _ruleAnalyzer;

  // [新增] 新增
  late final PromptTemplateLibrary _templates;
  late final OptimizedPromptBuilder _promptBuilder;

  FoundationAIProvider({
    required FoundationModelClient client,
    required SimpleSecurityAnalyzer ruleAnalyzer,
  })  : _client = client,
        _ruleAnalyzer = ruleAnalyzer {
    // 初始化新組件
    _templates = PromptTemplateLibrary();
    _promptBuilder = OptimizedPromptBuilder(
      templates: _templates,
      tokenEstimator: TokenEstimator(),
    );
  }

  @override
  Future<SecurityAnalysis> analyzeSecurityThreats(Email email) async {
    // 1. 規則快速檢查
    final ruleHints = _ruleAnalyzer.analyze(email);

    // 2. 預處理內容（暫時使用簡化版本，後續 Phase 會增強）
    final sanitized = _sanitizer.sanitizeEmailBody(email);

    // 3. 提取關鍵元素（暫時使用空對象，Phase 4 會實作）
    final extracted = ExtractedElements.empty();

    // 4. [新增] 使用優化的 Prompt Builder
    final prompt = _promptBuilder.buildCompactSecurityPrompt(
      email: email,
      ruleHints: ruleHints,
      extractedElements: extracted,
    );

    // 5. 發送到 AI
    final response = await _sendPrompt(prompt);

    // 6. 解析並合併結果
    return _parseAndMergeSecurityAnalysis(response, ruleHints);
  }
}
```

**執行測試**:
```bash
flutter test test/unit/data/providers/foundation/foundation_ai_provider_test.dart
```

**COMMIT**: `refactor(ai): integrate OptimizedPromptBuilder into FoundationAIProvider`

---

### 2.3 A/B 測試與驗證

#### Task 1.5: 建立準確率測試框架

**RED: 寫測試**

```dart
// test/integration/ai_prompt_optimization_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:awesome_mail_flutter/data/providers/foundation/foundation_ai_provider.dart';

void main() {
  group('Prompt Optimization Accuracy Validation', () {
    late FoundationAIProvider optimizedProvider;
    late List<Email> phishingDataset;
    late List<Email> legitimateDataset;

    setUpAll(() async {
      // Load test datasets
      phishingDataset = await loadPhishingTestSet();
      legitimateDataset = await loadLegitimateTestSet();

      optimizedProvider = FoundationAIProvider(
        client: FoundationModelClient(),
        ruleAnalyzer: SimpleSecurityAnalyzer(),
      );
    });

    test('achieves >=85% phishing detection rate', () async {
      var truePositives = 0;

      for (final email in phishingDataset) {
        final analysis = await optimizedProvider.analyzeSecurityThreats(email);

        if (analysis.threatLevel.index >= ThreatLevel.medium.index) {
          truePositives++;
        }
      }

      final recall = truePositives / phishingDataset.length;

      expect(recall, greaterThanOrEqualTo(0.85),
        reason: 'Phishing detection recall must be >=85%, got ${(recall * 100).toStringAsFixed(1)}%');
    }, skip: 'Requires test dataset');

    test('maintains <=12% false positive rate', () async {
      var falsePositives = 0;

      for (final email in legitimateDataset) {
        final analysis = await optimizedProvider.analyzeSecurityThreats(email);

        if (analysis.threatLevel.index >= ThreatLevel.medium.index) {
          falsePositives++;
        }
      }

      final fpr = falsePositives / legitimateDataset.length;

      expect(fpr, lessThanOrEqualTo(0.12),
        reason: 'False positive rate must be <=12%, got ${(fpr * 100).toStringAsFixed(1)}%');
    }, skip: 'Requires test dataset');
  });
}
```

**COMMIT**: `test(ai): add accuracy validation framework for prompt optimization`

---

### 2.4 Phase 1 驗收檢查清單

執行以下檢查以確保 Phase 1 完成：

- [ ] PromptTemplateLibrary 實作完成
- [ ] 所有 template token 數符合預算：
  - [ ] Compact security ≤1200 tokens
  - [ ] Detailed security ≤1500 tokens
  - [ ] Compact summary ≤1000 tokens
  - [ ] Standard summary ≤1200 tokens
- [ ] OptimizedPromptBuilder 實作完成
- [ ] 整合到 FoundationAIProvider
- [ ] 所有單元測試通過（覆蓋率 ≥90%）
- [ ] Linting 無錯誤
- [ ] ⏳ 準確率測試 ≥85%（需真實 AI 測試）
- [ ] ⏳ 誤報率 ≤12%（需真實 AI 測試）

**FINAL COMMIT**: `feat(ai): complete Phase 1 - Prompt Template Optimization`

---

## 3. Phase 2: Dynamic Routing

**目標**: 實作 Fast/Standard/Complex Path 動態路由

**時程**: Week 3-4

### 3.1 建立 ContentRouter

#### Task 2.1: 實作基本路由邏輯

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/content_router_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:awesome_mail_flutter/data/providers/foundation/content_router.dart';

void main() {
  group('ContentRouter', () {
    late ContentRouter router;
    late TokenEstimator tokenEstimator;

    setUp(() {
      tokenEstimator = TokenEstimator();
      router = ContentRouter(tokenEstimator: tokenEstimator);
    });

    group('route', () {
      test('selects fast path for short emails', () {
        final email = createEmail(charCount: 3000); // <6000 chars

        final decision = router.route(email, 'security_analysis');

        expect(decision.path, equals(ProcessingPath.fast));
        expect(decision.reason, contains('short'));
      });

      test('selects standard path for medium emails', () {
        final email = createEmail(charCount: 12000); // 6-24k chars

        final decision = router.route(email, 'security_analysis');

        expect(decision.path, equals(ProcessingPath.standard));
        expect(decision.reason, contains('standard'));
      });

      test('selects complex path for long emails', () {
        final email = createEmail(charCount: 30000); // >24k chars

        final decision = router.route(email, 'security_analysis');

        expect(decision.path, equals(ProcessingPath.complex));
        expect(decision.reason, contains('exceeds'));
      });

      test('considers token count in addition to char count', () {
        // 短字元但高 token 數（例如：很多符號）
        final email = createEmail(
          charCount: 5000,
          tokenCount: 2500, // 超過 fast path 限制
        );

        final decision = router.route(email, 'security_analysis');

        expect(decision.path, isNot(equals(ProcessingPath.fast)));
      });

      test('security analysis uses more conservative thresholds', () {
        final email = createEmail(charCount: 5500);

        // Security analysis 應該更保守
        final securityDecision = router.route(email, 'security_analysis');
        final summaryDecision = router.route(email, 'summarization');

        // 相同內容，安全分析可能選擇 standard，摘要選擇 fast
        expect(securityDecision.path.index,
               greaterThanOrEqualTo(summaryDecision.path.index));
      });

      test('includes metrics in decision', () {
        final email = createEmail(charCount: 3000);

        final decision = router.route(email, 'security_analysis');

        expect(decision.metrics, contains('charLength'));
        expect(decision.metrics, contains('tokenCount'));
        expect(decision.metrics, contains('expectedLatency'));
      });
    });

    group('canDowngrade', () {
      test('allows downgrade from complex path', () {
        expect(router.canDowngrade(ProcessingPath.complex), isTrue);
      });

      test('does not allow downgrade from fast path', () {
        expect(router.canDowngrade(ProcessingPath.fast), isFalse);
      });

      test('does not allow downgrade from standard path', () {
        expect(router.canDowngrade(ProcessingPath.standard), isFalse);
      });
    });
  });
}
```

**GREEN: 實作 ContentRouter**

```dart
// lib/data/providers/foundation/content_router.dart

/// 內容處理路徑
enum ProcessingPath {
  /// 快速路徑
  fast,
  /// 標準路徑
  standard,
  /// 複雜路徑
  complex,
}

/// 路由決策
class RoutingDecision {
  final ProcessingPath path;
  final String reason;
  final Map<String, dynamic> metrics;

  const RoutingDecision({
    required this.path,
    required this.reason,
    required this.metrics,
  });
}

/// 內容路由器
class ContentRouter {
  final TokenEstimator _tokenEstimator;

  // 閾值設定
  static const int _fastPathCharLimit = 6000;
  static const int _fastPathTokenLimit = 2000;
  static const int _complexPathCharLimit = 24000;
  static const int _complexPathTokenLimit = 8000;

  const ContentRouter({required TokenEstimator tokenEstimator})
      : _tokenEstimator = tokenEstimator;

  /// 決定處理路徑
  RoutingDecision route(Email email, String operation) {
    final charLength = email.body.length;
    final tokenCount = _tokenEstimator.estimate(email.body);

    // Fast Path
    if (_isFastPathEligible(charLength, tokenCount, operation)) {
      return RoutingDecision(
        path: ProcessingPath.fast,
        reason: 'Content is short enough for single-pass processing',
        metrics: {
          'charLength': charLength,
          'tokenCount': tokenCount,
          'expectedLatency': '~1s',
        },
      );
    }

    // Complex Path
    if (_isComplexPathRequired(charLength, tokenCount, operation)) {
      return RoutingDecision(
        path: ProcessingPath.complex,
        reason: 'Content exceeds standard processing limits',
        metrics: {
          'charLength': charLength,
          'tokenCount': tokenCount,
          'expectedLatency': '~6-8s',
        },
      );
    }

    // Standard Path (default)
    return RoutingDecision(
      path: ProcessingPath.standard,
      reason: 'Content fits standard recursive summarization',
      metrics: {
        'charLength': charLength,
        'tokenCount': tokenCount,
        'expectedLatency': '~2-4s',
      },
    );
  }

  bool _isFastPathEligible(int chars, int tokens, String operation) {
    if (chars >= _fastPathCharLimit || tokens >= _fastPathTokenLimit) {
      return false;
    }

    // Security analysis 更保守（需要完整上下文）
    if (operation == 'security_analysis') {
      return chars < (_fastPathCharLimit * 0.8).floor();
    }

    return true;
  }

  bool _isComplexPathRequired(int chars, int tokens, String operation) {
    return chars >= _complexPathCharLimit || tokens >= _complexPathTokenLimit;
  }

  bool canDowngrade(ProcessingPath current) {
    return current == ProcessingPath.complex;
  }
}
```

**COMMIT**: `feat(ai): implement ContentRouter for dynamic path selection`

---

#### Task 2.2: 實作 FastPathProcessor

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/fast_path_processor_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('FastPathProcessor', () {
    late FastPathProcessor processor;
    late MockFoundationModelClient mockClient;
    late SimpleSecurityAnalyzer ruleAnalyzer;
    late OptimizedPromptBuilder promptBuilder;

    setUp(() {
      mockClient = MockFoundationModelClient();
      ruleAnalyzer = SimpleSecurityAnalyzer();
      promptBuilder = OptimizedPromptBuilder(
        templates: PromptTemplateLibrary(),
        tokenEstimator: TokenEstimator(),
      );

      processor = FastPathProcessor(
        client: mockClient,
        promptBuilder: promptBuilder,
        extractor: ContentExtractor(),
        ruleAnalyzer: ruleAnalyzer,
      );
    });

    group('analyzeSecurityFast', () {
      test('merges rule and AI analysis', () async {
        final email = createPhishingEmail(
          hasPunycode: true, // Rule detects HIGH
        );

        when(() => mockClient.sendPrompt(any())).thenAnswer(
          (_) => Future.value('{"threatLevel": "medium", "indicators": [...]}'),
        );

        final analysis = await processor.analyzeSecurityFast(email);

        // Rule says HIGH, AI says MEDIUM → final should be HIGH
        expect(analysis.threatLevel, equals(ThreatLevel.high));
      });

      test('caps AI upgrade when rule says LOW', () async {
        final email = createLegitimateEmail(); // Rule detects LOW

        when(() => mockClient.sendPrompt(any())).thenAnswer(
          (_) => Future.value('{"threatLevel": "high", "indicators": [...]}'),
        );

        final analysis = await processor.analyzeSecurityFast(email);

        // Rule says LOW, AI says HIGH → cap at MEDIUM
        expect(analysis.threatLevel, lessThanOrEqualTo(ThreatLevel.medium));
      });

      test('falls back to rule analysis on AI failure', () async {
        final email = createPhishingEmail(hasPunycode: true);

        when(() => mockClient.sendPrompt(any())).thenThrow(
          Exception('AI unavailable'),
        );

        final analysis = await processor.analyzeSecurityFast(email);

        // Should still detect based on rules
        expect(analysis.threatLevel, greaterThanOrEqualTo(ThreatLevel.high));
      });

      test('completes within 1.5s for short emails', () async {
        final email = createEmail(charCount: 3000);

        when(() => mockClient.sendPrompt(any())).thenAnswer(
          (_) async {
            await Future.delayed(Duration(milliseconds: 600)); // Simulate TTFT
            return '{"threatLevel": "low", "indicators": []}';
          },
        );

        final stopwatch = Stopwatch()..start();
        await processor.analyzeSecurityFast(email);
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(1500));
      });
    });
  });
}
```

**GREEN: 實作 FastPathProcessor**

```dart
// lib/data/providers/foundation/fast_path_processor.dart

/// 快速路徑處理器
class FastPathProcessor {
  final FoundationModelClient _client;
  final OptimizedPromptBuilder _promptBuilder;
  final ContentExtractor _extractor;
  final SimpleSecurityAnalyzer _ruleAnalyzer;

  const FastPathProcessor({
    required FoundationModelClient client,
    required OptimizedPromptBuilder promptBuilder,
    required ContentExtractor extractor,
    required SimpleSecurityAnalyzer ruleAnalyzer,
  })  : _client = client,
        _promptBuilder = promptBuilder,
        _extractor = extractor,
        _ruleAnalyzer = ruleAnalyzer;

  /// 快速安全分析
  Future<SecurityAnalysis> analyzeSecurityFast(Email email) async {
    // 1. 規則快速檢查
    final ruleAnalysis = _ruleAnalyzer.analyze(email);

    // 2. 提取關鍵元素
    final extracted = _extractor.extract(email);

    // 3. 構建 prompt
    final prompt = _promptBuilder.buildCompactSecurityPrompt(
      email: email,
      ruleHints: ruleAnalysis,
      extractedElements: extracted,
    );

    // 4. AI 分析（with fallback）
    try {
      final response = await _client.sendPrompt(prompt);
      return _parseSecurityAnalysis(response, ruleAnalysis);
    } catch (e) {
      // Fallback to rule-based
      return _createRuleBasedAnalysis(ruleAnalysis);
    }
  }

  SecurityAnalysis _parseSecurityAnalysis(
    String aiResponse,
    SimpleSecurityAnalysis ruleAnalysis,
  ) {
    final aiResult = _parseAIResponse(aiResponse);

    return SecurityAnalysis(
      threatLevel: _mergeThreatLevel(
        ruleLevel: ruleAnalysis.threatLevel,
        aiLevel: aiResult.threatLevel,
      ),
      indicators: [
        ...ruleAnalysis.indicators,
        ...aiResult.indicators,
      ],
      confidence: aiResult.confidence,
      reasoning: aiResult.reasoning,
    );
  }

  /// 合併威脅等級
  ThreatLevel _mergeThreatLevel(
    ThreatLevel ruleLevel,
    ThreatLevel aiLevel,
  ) {
    // Rule HIGH/CRITICAL → 不能降級
    if (ruleLevel.index >= ThreatLevel.high.index) {
      return ruleLevel;
    }

    // Rule LOW + AI HIGH → cap at MEDIUM
    if (ruleLevel == ThreatLevel.low &&
        aiLevel.index >= ThreatLevel.high.index) {
      return ThreatLevel.medium;
    }

    // 取較高者
    return ruleLevel.index > aiLevel.index ? ruleLevel : aiLevel;
  }

  SecurityAnalysis _createRuleBasedAnalysis(
    SimpleSecurityAnalysis ruleAnalysis,
  ) {
    return SecurityAnalysis(
      threatLevel: ruleAnalysis.threatLevel,
      indicators: ruleAnalysis.indicators,
      confidence: 0.7, // Lower confidence (no AI confirmation)
      reasoning: 'Rule-based analysis only (AI unavailable)',
    );
  }
}
```

**COMMIT**: `feat(ai): implement FastPathProcessor with rule+AI merging`

---

#### Task 2.3: 整合路由到 FoundationAIProvider

**RED: 寫整合測試**

```dart
// test/integration/dynamic_routing_integration_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dynamic Routing Integration', () {
    late FoundationAIProvider provider;

    setUp(() {
      provider = FoundationAIProvider(
        client: FoundationModelClient(),
        ruleAnalyzer: SimpleSecurityAnalyzer(),
      );
    });

    test('short email uses fast path and completes in <1s', () async {
      final email = createEmail(charCount: 3000);

      final stopwatch = Stopwatch()..start();
      final analysis = await provider.analyzeSecurityThreats(email);
      stopwatch.stop();

      expect(analysis, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(1500)); // p95
    });

    test('medium email uses standard path', () async {
      final email = createEmail(charCount: 12000);

      final stopwatch = Stopwatch()..start();
      final analysis = await provider.analyzeSecurityThreats(email);
      stopwatch.stop();

      expect(analysis, isNotNull);
      expect(stopwatch.elapsedMilliseconds, lessThan(4000)); // p95
    });

    test('falls back to lower path on failure', () async {
      final email = createEdgeCaseEmail(); // Might trigger failures

      final analysis = await provider.analyzeSecurityThreats(email);

      // Should not throw, should gracefully degrade
      expect(analysis, isNotNull);
    });
  });
}
```

**GREEN: 整合到 FoundationAIProvider**

```dart
// lib/data/providers/foundation/foundation_ai_provider.dart

class FoundationAIProvider implements AIProvider {
  // ...existing fields

  late final ContentRouter _router;
  late final FastPathProcessor _fastProcessor;

  FoundationAIProvider({
    required FoundationModelClient client,
    required SimpleSecurityAnalyzer ruleAnalyzer,
  }) : /* ...existing init */ {
    _router = ContentRouter(tokenEstimator: _tokenEstimator);
    _fastProcessor = FastPathProcessor(
      client: _client,
      promptBuilder: _promptBuilder,
      extractor: ContentExtractor(),
      ruleAnalyzer: _ruleAnalyzer,
    );
  }

  @override
  Future<SecurityAnalysis> analyzeSecurityThreats(Email email) async {
    // Route to appropriate path
    final decision = _router.route(email, 'security_analysis');

    try {
      switch (decision.path) {
        case ProcessingPath.fast:
          return await _fastProcessor.analyzeSecurityFast(email);

        case ProcessingPath.standard:
          return await _standardPathAnalysis(email); // Existing recursive logic

        case ProcessingPath.complex:
          return await _complexPathAnalysis(email); // Enhanced version
      }
    } catch (e) {
      // Fallback logic
      if (_router.canDowngrade(decision.path)) {
        return await _fallbackAnalysis(email);
      }
      rethrow;
    }
  }
}
```

**COMMIT**: `feat(ai): integrate dynamic routing into FoundationAIProvider`

---

### 3.2 Phase 2 驗收檢查清單

- [ ] ContentRouter 實作完成
- [ ] FastPathProcessor 實作完成
- [ ] 整合到 FoundationAIProvider
- [ ] 路由決策正確（短→Fast, 中→Standard, 長→Complex）
- [ ] Fast Path 延遲 <1.5s (p95)
- [ ] Standard Path 延遲 <4s (p95)
- [ ] Fallback 機制正常運作
- [ ] 所有測試通過（覆蓋率 ≥90%）
- [ ] Linting 無錯誤

**FINAL COMMIT**: `feat(ai): complete Phase 2 - Dynamic Routing`

---

## 4. Phase 3: HTML Enhancement

**目標**: 實作 HTML → Markdown 轉換，保留結構

**時程**: Week 5-6

### 4.1 實作 HtmlToMarkdownConverter

#### Task 3.1: 表格轉換

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/html_to_markdown_converter_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HtmlToMarkdownConverter', () {
    late HtmlToMarkdownConverter converter;

    setUp(() {
      converter = HtmlToMarkdownConverter();
    });

    group('Table Conversion', () {
      test('converts simple table to markdown', () {
        final html = '''
<table>
  <tr><th>Product</th><th>Price</th></tr>
  <tr><td>A</td><td>100</td></tr>
  <tr><td>B</td><td>200</td></tr>
</table>
''';

        final markdown = converter.convert(html);

        expect(markdown, contains('| Product | Price |'));
        expect(markdown, contains('| --- | --- |'));
        expect(markdown, contains('| A | 100 |'));
        expect(markdown, contains('| B | 200 |'));
      });

      test('handles table without headers', () {
        final html = '''
<table>
  <tr><td>A</td><td>100</td></tr>
  <tr><td>B</td><td>200</td></tr>
</table>
''';

        final markdown = converter.convert(html);

        // Should create header from first row
        expect(markdown, contains('|'));
        expect(markdown, contains('---'));
      });

      test('handles nested tables gracefully', () {
        final html = '''
<table>
  <tr><td>Outer</td><td><table><tr><td>Inner</td></tr></table></td></tr>
</table>
''';

        final markdown = converter.convert(html);

        // Should flatten or handle appropriately
        expect(markdown, isNotEmpty);
      });
    });

    group('List Conversion', () {
      test('converts unordered list', () {
        final html = '''
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
  <li>Item 3</li>
</ul>
''';

        final markdown = converter.convert(html);

        expect(markdown, contains('- Item 1'));
        expect(markdown, contains('- Item 2'));
        expect(markdown, contains('- Item 3'));
      });

      test('converts ordered list', () {
        final html = '''
<ol>
  <li>First</li>
  <li>Second</li>
  <li>Third</li>
</ol>
''';

        final markdown = converter.convert(html);

        expect(markdown, contains('1. First'));
        expect(markdown, contains('2. Second'));
        expect(markdown, contains('3. Third'));
      });

      test('converts nested lists (max 3 levels)', () {
        final html = '''
<ul>
  <li>Level 1
    <ul>
      <li>Level 2
        <ul>
          <li>Level 3</li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
''';

        final markdown = converter.convert(html);

        expect(markdown, contains('- Level 1'));
        expect(markdown, contains('  - Level 2'));
        expect(markdown, contains('    - Level 3'));
      });
    });

    group('Link Conversion', () {
      test('converts links to markdown format', () {
        final html = '<a href="https://example.com">Click here</a>';

        final markdown = converter.convert(html);

        expect(markdown, contains('[Click here](https://example.com)'));
      });

      test('handles links without text', () {
        final html = '<a href="https://example.com"></a>';

        final markdown = converter.convert(html);

        // Should handle gracefully
        expect(markdown, isNot(contains('[]('))); // Don't create empty links
      });
    });

    group('Error Handling', () {
      test('handles malformed HTML', () {
        final html = '<table><tr><td>Unclosed';

        expect(() => converter.convert(html), returnsNormally);
      });

      test('returns empty string for empty input', () {
        final markdown = converter.convert('');

        expect(markdown, isEmpty);
      });
    });
  });
}
```

**GREEN**: 實作 HtmlToMarkdownConverter（參考 design.md 2.4 節）

**COMMIT**: `feat(ai): implement HtmlToMarkdownConverter`

---

#### Task 3.2: 整合到 ContentPreprocessor

**RED: 寫測試**

```dart
// test/unit/data/providers/foundation/enhanced_content_preprocessor_test.dart

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnhancedContentPreprocessor', () {
    late EnhancedContentPreprocessor preprocessor;

    setUp(() {
      preprocessor = EnhancedContentPreprocessor(
        htmlConverter: HtmlToMarkdownConverter(),
        extractor: ContentExtractor(),
        tokenEstimator: TokenEstimator(),
      );
    });

    test('converts HTML email to markdown', () {
      final email = Email(
        id: '1',
        subject: 'Test',
        from: EmailAddress(email: 'test@example.com', name: 'Test'),
        to: [],
        body: 'Plain text',
        htmlBody: '<table><tr><td>A</td><td>B</td></tr></table>',
        receivedDate: DateTime.now(),
      );

      final processed = preprocessor.preprocess(email);

      expect(processed.mainContent, contains('|'));
      expect(processed.mainContent, contains('---'));
    });

    test('falls back to plain text on conversion error', () {
      final email = Email(
        id: '1',
        subject: 'Test',
        from: EmailAddress(email: 'test@example.com', name: 'Test'),
        to: [],
        body: 'Plain text fallback',
        htmlBody: '<malformed html',
        receivedDate: DateTime.now(),
      );

      final processed = preprocessor.preprocess(email);

      expect(processed.mainContent, equals('Plain text fallback'));
    });

    test('includes metadata about structure', () {
      final email = Email(
        id: '1',
        subject: 'Test',
        from: EmailAddress(email: 'test@example.com', name: 'Test'),
        to: [],
        body: 'Text',
        htmlBody: '<table><tr><td>Data</td></tr></table><ul><li>Item</li></ul>',
        receivedDate: DateTime.now(),
      );

      final processed = preprocessor.preprocess(email);

      expect(processed.metadata.hasTables, isTrue);
      expect(processed.metadata.hasLists, isTrue);
    });
  });
}
```

**GREEN**: 實作 EnhancedContentPreprocessor（參考 design.md 2.3 節）

**COMMIT**: `feat(ai): implement EnhancedContentPreprocessor with HTML conversion`

---

### 4.2 Phase 3 驗收檢查清單

- [ ] HtmlToMarkdownConverter 實作完成
- [ ] 表格轉換準確率 >95%
- [ ] 列表層次保留（支援巢狀 3 層）
- [ ] 連結轉換為 Markdown 格式
- [ ] EnhancedContentPreprocessor 整合
- [ ] Fallback 機制正常運作
- [ ] 所有測試通過
- [ ] Token 增加 <20%（vs 純文字）

**FINAL COMMIT**: `feat(ai): complete Phase 3 - HTML Enhancement`

---

## 5. Phase 4: Content Extraction

**目標**: 實作智能內容抽取器

**時程**: Week 7-8

### 5.1 實作 ContentExtractor

#### Task 4.1: URL 與域名抽取

**RED**: 參考 design.md 2.5 節編寫測試

**GREEN**: 實作 ContentExtractor

**COMMIT**: `feat(ai): implement ContentExtractor`

---

#### Task 4.2: 整合到 PromptBuilder

**RED**: 驗證 hints 包含抽取的資訊

**GREEN**: 修改 PromptBuilder 使用抽取的元素

**COMMIT**: `refactor(ai): integrate ContentExtractor into PromptBuilder`

---

### 5.2 Phase 4 驗收檢查清單

- [ ] ContentExtractor 實作完成
- [ ] URL 抽取準確率 >98%
- [ ] Punycode 檢測 100%
- [ ] Homoglyph 檢測 >95%
- [ ] 日期/金額識別準確
- [ ] 安全分析準確率提升 ≥5%
- [ ] 所有測試通過

**FINAL COMMIT**: `feat(ai): complete Phase 4 - Content Extraction`

---

## 6. 最終整合與驗收

### 6.1 完整回歸測試

```bash
# 執行所有測試
flutter test

# 執行整合測試
flutter test integration_test/

# 檢查覆蓋率
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### 6.2 效能基準測試

```bash
# 執行效能測試
flutter test test/performance/
```

### 6.3 最終驗收清單

- [ ] 所有 4 個 Phase 完成
- [ ] 所有 P0 需求實作完成
- [ ] ≥80% P1 需求實作完成
- [ ] 測試覆蓋率 ≥90%
- [ ] 所有成功指標達標
- [ ] Linting 無錯誤
- [ ] 文件更新完成

---

**文件結束**

下一步：請參閱 `testing.md` 了解詳細的測試計劃。
