# Apple Intelligence 內容簡化策略優化 - 技術設計

## 文件資訊
- **版本**: 1.0.0
- **建立日期**: 2025-10-31
- **狀態**: Draft
- **關聯需求**: requirements.md

## 目錄
1. [系統架構](#1-系統架構)
2. [核心組件設計](#2-核心組件設計)
3. [資料流程](#3-資料流程)
4. [API 設計](#4-api-設計)
5. [演算法設計](#5-演算法設計)
6. [效能優化策略](#6-效能優化策略)
7. [錯誤處理](#7-錯誤處理)
8. [測試策略](#8-測試策略)

---

## 1. 系統架構

### 1.1 整體架構圖

```
┌─────────────────────────────────────────────────────────────┐
│                    Email Application Layer                   │
│  (MailboxBloc, EmailSyncCubit, AIBloc)                      │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                      AI Service Layer                        │
│  (AIService - 請求去重、快取、結果持久化)                     │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                   AI Provider Selection                      │
│  (HybridAIProvider - 本地優先 + 遠端 fallback)               │
└─────────────┬───────────────────────────────┬───────────────┘
              │                               │
              ▼                               ▼
    ┌─────────────────────┐       ┌─────────────────────────┐
    │ FoundationAIProvider│       │  RemoteAIProvider       │
    │   (本地 AI)         │       │  (Cloudflare Workers)   │
    └──────────┬──────────┘       └─────────────────────────┘
               │
               ▼
    ┌────────────────────────────────────────────────────────┐
    │           [新增] ContentRouter (新增)                       │
    │  根據郵件長度選擇處理策略                                │
    │  - Fast Path    (短郵件, <6k chars)                     │
    │  - Standard Path (中郵件, 6-24k chars)                  │
    │  - Complex Path  (長郵件, >24k chars)                   │
    └──────────┬───────────────────────────┬─────────────────┘
               │                           │
               ▼                           ▼
    ┌──────────────────────┐   ┌───────────────────────────┐
    │   FastPathProcessor   │   │ RecursiveSummarizer       │
    │  (單次 AI 呼叫)       │   │ (當前遞迴策略)             │
    └──────────┬───────────┘   └───────────┬───────────────┘
               │                           │
               └───────────┬───────────────┘
                           │
                           ▼
            ┌────────────────────────────────────────┐
            │  [新增] EnhancedContentPreprocessor (新增) │
            │  - HTML → Markdown 轉換                │
            │  - 智能內容抽取                        │
            │  - Token 估算與預算管理                │
            └───────────────┬────────────────────────┘
                            │
                            ▼
            ┌────────────────────────────────────────┐
            │  [新增] OptimizedPromptBuilder (新增)      │
            │  - 精簡 Prompt Template (1500 tokens)  │
            │  - @Generable 結構化輸出               │
            │  - 動態 hints 注入                     │
            └───────────────┬────────────────────────┘
                            │
                            ▼
            ┌────────────────────────────────────────┐
            │   FoundationModelClient                │
            │   (Apple Intelligence API)             │
            └────────────────────────────────────────┘
```

### 1.2 模組依賴關係

```
AIService
  └─> HybridAIProvider
       ├─> FoundationAIProvider (本地)
       │    ├─> ContentRouter [新增]
       │    │    ├─> FastPathProcessor [新增]
       │    │    └─> RecursiveSummarizer (已存在，優化)
       │    ├─> EnhancedContentPreprocessor [新增]
       │    │    ├─> HtmlToMarkdownConverter [新增]
       │    │    ├─> ContentExtractor [新增]
       │    │    └─> TokenEstimator (已存在，優化)
       │    └─> OptimizedPromptBuilder [新增]
       │         └─> PromptTemplateLibrary [新增]
       │
       └─> RemoteAIProvider (遠端)
            └─> (無變更)
```

### 1.3 組件責任矩陣

| 組件 | 責任 | 輸入 | 輸出 | 狀態 |
|------|------|------|------|------|
| **ContentRouter** | 根據郵件長度選擇處理路徑 | Email | ProcessingPath | [新增] 新增 |
| **FastPathProcessor** | 短郵件單次處理 | Email, CompactPrompt | AIResponse | [新增] 新增 |
| **RecursiveSummarizer** | 長郵件遞迴摘要 | Email, StandardPrompt | EmailSummary | [修改] 優化 |
| **EnhancedContentPreprocessor** | 內容預處理與清理 | Email | ProcessedContent | [新增] 新增 |
| **HtmlToMarkdownConverter** | HTML 轉 Markdown | HTML String | Markdown String | [新增] 新增 |
| **ContentExtractor** | 抽取關鍵元素 | Email Body | ExtractedElements | [新增] 新增 |
| **OptimizedPromptBuilder** | 精簡 Prompt 構建 | Operation, Content, Hints | Prompt | [新增] 新增 |
| **PromptTemplateLibrary** | Prompt 模板管理 | OperationType | Template String | [新增] 新增 |
| **TokenEstimator** | Token 估算 | String | int (tokens) | [完成] 已存在 |

---

## 2. 核心組件設計

### 2.1 ContentRouter

**目的**: 根據郵件內容長度和複雜度，選擇最佳處理策略

#### 類別定義

```dart
/// 內容處理路徑
enum ProcessingPath {
  /// 快速路徑：短郵件，單次 AI 呼叫
  fast,

  /// 標準路徑：中等郵件，遞迴摘要
  standard,

  /// 複雜路徑：長郵件，改良策略
  complex,
}

/// 路由決策結果
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

  // 閾值設定（可配置）
  static const int _fastPathCharLimit = 6000;
  static const int _fastPathTokenLimit = 2000;
  static const int _complexPathCharLimit = 24000;
  static const int _complexPathTokenLimit = 8000;

  /// 決定處理路徑
  RoutingDecision route(Email email, String operation) {
    final charLength = email.body.length;
    final tokenCount = _tokenEstimator.estimate(email.body);

    // Fast Path: 短郵件
    if (charLength < _fastPathCharLimit && tokenCount < _fastPathTokenLimit) {
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

    // Complex Path: 長郵件
    if (charLength >= _complexPathCharLimit || tokenCount >= _complexPathTokenLimit) {
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

    // Standard Path: 中等郵件
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

  /// 檢查是否可以降級到更簡單的路徑
  bool canDowngrade(ProcessingPath current) {
    return current == ProcessingPath.complex;
  }
}
```

---

### 2.2 FastPathProcessor

**目的**: 為短郵件提供快速單次 AI 處理

#### 類別定義

```dart
/// 快速路徑處理器
class FastPathProcessor {
  final FoundationModelClient _client;
  final OptimizedPromptBuilder _promptBuilder;
  final ContentExtractor _extractor;
  final SimpleSecurityAnalyzer _ruleAnalyzer;

  /// 快速安全分析
  Future<SecurityAnalysis> analyzeSecurityFast(Email email) async {
    // 1. 規則快速檢查（提供 hints）
    final ruleAnalysis = _ruleAnalyzer.analyze(email);

    // 2. 提取關鍵元素
    final extracted = _extractor.extract(email);

    // 3. 構建緊湊 prompt（~1200 tokens）
    final prompt = _promptBuilder.buildCompactSecurityPrompt(
      email: email,
      ruleHints: ruleAnalysis,
      extractedElements: extracted,
    );

    // 4. 單次 AI 呼叫
    try {
      final response = await _client.sendPrompt(prompt);
      return _parseSecurityAnalysis(response, ruleAnalysis);
    } catch (e) {
      // 失敗時降級到規則分析
      return _createRuleBasedAnalysis(ruleAnalysis);
    }
  }

  /// 快速摘要
  Future<EmailSummary> summarizeFast(Email email) async {
    final extracted = _extractor.extract(email);

    final prompt = _promptBuilder.buildCompactSummaryPrompt(
      email: email,
      extractedElements: extracted,
    );

    final response = await _client.sendPrompt(prompt);
    return _parseSummary(response);
  }

  /// 解析安全分析結果（合併規則 + AI）
  SecurityAnalysis _parseSecurityAnalysis(
    String aiResponse,
    SimpleSecurityAnalysis ruleAnalysis,
  ) {
    final aiResult = _parseAISecurityResponse(aiResponse);

    // 合併規則與 AI 分析（規則具有最終決定權）
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

  /// 合併威脅等級（規則優先）
  ThreatLevel _mergeThreatLevel(ThreatLevel ruleLevel, ThreatLevel aiLevel) {
    // 規則檢測到 HIGH/CRITICAL → 最終結果不能低於此
    if (ruleLevel.index >= ThreatLevel.high.index) {
      return ruleLevel;
    }

    // 規則檢測到 LOW → AI 不能升級為 HIGH（防止誤報）
    if (ruleLevel == ThreatLevel.low && aiLevel.index >= ThreatLevel.high.index) {
      return ThreatLevel.medium; // 上限為 MEDIUM
    }

    // 其他情況取較高者
    return ruleLevel.index > aiLevel.index ? ruleLevel : aiLevel;
  }
}
```

---

### 2.3 EnhancedContentPreprocessor

**目的**: 增強內容預處理，保留結構化資訊

#### 類別定義

```dart
/// 處理後的內容
class ProcessedContent {
  /// 主要內容（Markdown 格式）
  final String mainContent;

  /// 提取的關鍵元素
  final ExtractedElements elements;

  /// 元數據
  final ContentMetadata metadata;

  /// Token 估算
  final int estimatedTokens;

  const ProcessedContent({
    required this.mainContent,
    required this.elements,
    required this.metadata,
    required this.estimatedTokens,
  });
}

/// 增強內容預處理器
class EnhancedContentPreprocessor {
  final HtmlToMarkdownConverter _htmlConverter;
  final ContentExtractor _extractor;
  final TokenEstimator _tokenEstimator;

  /// 預處理郵件內容
  ProcessedContent preprocess(Email email) {
    // 1. HTML → Markdown 轉換
    final markdown = _convertToMarkdown(email);

    // 2. 提取關鍵元素
    final extracted = _extractor.extract(email);

    // 3. 清理與標準化
    final cleaned = _cleanAndNormalize(markdown);

    // 4. Token 估算
    final tokens = _tokenEstimator.estimate(cleaned);

    // 5. 收集元數據
    final metadata = ContentMetadata(
      hasImages: extracted.imageCount > 0,
      hasLinks: extracted.urls.isNotEmpty,
      hasTables: markdown.contains('|'),
      hasLists: markdown.contains(RegExp(r'^[\-\*\+]\s', multiLine: true)),
      originalLength: email.body.length,
      processedLength: cleaned.length,
    );

    return ProcessedContent(
      mainContent: cleaned,
      elements: extracted,
      metadata: metadata,
      estimatedTokens: tokens,
    );
  }

  /// HTML → Markdown 轉換
  String _convertToMarkdown(Email email) {
    if (email.htmlBody != null && email.htmlBody!.isNotEmpty) {
      try {
        return _htmlConverter.convert(email.htmlBody!);
      } catch (e) {
        // Fallback 到純文字
        return email.body;
      }
    }
    return email.body;
  }

  /// 清理與標準化
  String _cleanAndNormalize(String content) {
    return content
      // 移除過多的換行（最多保留雙換行）
      .replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n')
      // 標準化空白字元
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      // 移除 Data URIs
      .replaceAll(RegExp(r'data:image/[^;]+;base64,[^\s)]+'), '[image]')
      // 移除 CID 引用
      .replaceAll(RegExp(r'cid:[^\s)]+'), '[inline-image]')
      .trim();
  }
}
```

---

### 2.4 HtmlToMarkdownConverter

**目的**: 將 HTML 轉換為 Markdown，保留表格和列表結構

#### 類別定義

```dart
/// HTML → Markdown 轉換器
class HtmlToMarkdownConverter {
  /// 轉換 HTML 為 Markdown
  String convert(String html) {
    final document = parse(html);

    // 移除不需要的標籤
    document.querySelectorAll('script, style, noscript').forEach(
      (element) => element.remove(),
    );

    // 轉換表格
    _convertTables(document);

    // 轉換列表
    _convertLists(document);

    // 轉換連結
    _convertLinks(document);

    // 提取純文字
    return document.body?.text ?? '';
  }

  /// 轉換表格為 Markdown
  void _convertTables(html.Document document) {
    for (final table in document.querySelectorAll('table')) {
      final markdown = _tableToMarkdown(table);
      table.replaceWith(html.Text(markdown));
    }
  }

  /// 表格 → Markdown 表格
  String _tableToMarkdown(html.Element table) {
    final rows = <List<String>>[];

    // 處理表頭
    final headers = table.querySelectorAll('th');
    if (headers.isNotEmpty) {
      rows.add(headers.map((h) => h.text.trim()).toList());
    }

    // 處理資料列
    for (final row in table.querySelectorAll('tr')) {
      final cells = row.querySelectorAll('td');
      if (cells.isNotEmpty) {
        rows.add(cells.map((c) => c.text.trim()).toList());
      }
    }

    if (rows.isEmpty) return '';

    // 構建 Markdown 表格
    final buffer = StringBuffer();

    // 表頭
    buffer.writeln('| ${rows[0].join(' | ')} |');
    buffer.writeln('| ${List.filled(rows[0].length, '---').join(' | ')} |');

    // 資料行
    for (var i = 1; i < rows.length; i++) {
      buffer.writeln('| ${rows[i].join(' | ')} |');
    }

    return buffer.toString();
  }

  /// 轉換列表為 Markdown
  void _convertLists(html.Document document) {
    // 處理無序列表
    for (final ul in document.querySelectorAll('ul')) {
      final markdown = _listToMarkdown(ul, ordered: false);
      ul.replaceWith(html.Text(markdown));
    }

    // 處理有序列表
    for (final ol in document.querySelectorAll('ol')) {
      final markdown = _listToMarkdown(ol, ordered: true);
      ol.replaceWith(html.Text(markdown));
    }
  }

  /// 列表 → Markdown 列表
  String _listToMarkdown(html.Element list, {required bool ordered, int depth = 0}) {
    final buffer = StringBuffer();
    final indent = '  ' * depth;
    var index = 1;

    for (final item in list.querySelectorAll('li')) {
      // 檢查是否有巢狀列表
      final nestedLists = item.querySelectorAll('ul, ol');
      final text = item.text.trim();

      if (ordered) {
        buffer.writeln('$indent$index. $text');
        index++;
      } else {
        buffer.writeln('$indent- $text');
      }

      // 處理巢狀列表（最多 3 層）
      if (depth < 2) {
        for (final nested in nestedLists) {
          buffer.write(_listToMarkdown(
            nested,
            ordered: nested.localName == 'ol',
            depth: depth + 1,
          ));
        }
      }
    }

    return buffer.toString();
  }

  /// 轉換連結為 Markdown
  void _convertLinks(html.Document document) {
    for (final link in document.querySelectorAll('a')) {
      final text = link.text.trim();
      final href = link.attributes['href'] ?? '';

      if (text.isEmpty || href.isEmpty) continue;

      // [顯示文字](URL)
      final markdown = '[$text]($href)';
      link.replaceWith(html.Text(markdown));
    }
  }
}
```

---

### 2.5 ContentExtractor

**目的**: 智能抽取郵件中的關鍵元素（URLs, 日期, 金額等）

#### 類別定義

```dart
/// 提取的關鍵元素
class ExtractedElements {
  /// URLs（包含錨點文字）
  final List<UrlInfo> urls;

  /// 域名資訊
  final List<DomainInfo> domains;

  /// 日期
  final List<DateTime> dates;

  /// 金額
  final List<Amount> amounts;

  /// 電話號碼
  final List<String> phoneNumbers;

  /// 圖片數量
  final int imageCount;

  const ExtractedElements({
    required this.urls,
    required this.domains,
    required this.dates,
    required this.amounts,
    required this.phoneNumbers,
    required this.imageCount,
  });

  /// 是否包含可疑指標
  bool get hasSuspiciousIndicators {
    return domains.any((d) => d.isPunycode || d.hasUserinfo || d.hasHomoglyph);
  }
}

/// URL 資訊
class UrlInfo {
  final String url;
  final String anchorText;
  final String scheme;
  final String host;
  final String eTldPlusOne;

  const UrlInfo({
    required this.url,
    required this.anchorText,
    required this.scheme,
    required this.host,
    required this.eTldPlusOne,
  });
}

/// 域名資訊
class DomainInfo {
  final String domain;
  final String eTldPlusOne;
  final bool isPunycode;
  final bool hasUserinfo;
  final bool hasHomoglyph;
  final List<String> suspiciousPatterns;

  const DomainInfo({
    required this.domain,
    required this.eTldPlusOne,
    required this.isPunycode,
    required this.hasUserinfo,
    required this.hasHomoglyph,
    required this.suspiciousPatterns,
  });
}

/// 金額
class Amount {
  final double value;
  final String currency;
  final String rawText;

  const Amount({
    required this.value,
    required this.currency,
    required this.rawText,
  });
}

/// 內容抽取器
class ContentExtractor {
  // URL 正則
  static final _urlPattern = RegExp(
    r'https?://[^\s<>"\')]+',
    caseSensitive: false,
  );

  // Punycode 正則
  static final _punycodePattern = RegExp(r'xn--');

  // Userinfo 正則
  static final _userinfoPattern = RegExp(r'://[^@/]+@');

  // 日期正則（支援多種格式）
  static final _datePatterns = [
    RegExp(r'\d{4}-\d{2}-\d{2}'),                    // 2025-10-31
    RegExp(r'\d{1,2}/\d{1,2}/\d{4}'),                // 10/31/2025
    RegExp(r'\d{1,2}\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{4}'),
  ];

  // 金額正則
  static final _amountPattern = RegExp(
    r'(\$|USD|EUR|GBP|JPY|CNY|TWD|NT\$)\s*(\d{1,3}(,\d{3})*(\.\d{2})?)',
  );

  /// 提取關鍵元素
  ExtractedElements extract(Email email) {
    final content = email.htmlBody ?? email.body;

    return ExtractedElements(
      urls: _extractUrls(content),
      domains: _extractDomains(content),
      dates: _extractDates(content),
      amounts: _extractAmounts(content),
      phoneNumbers: _extractPhoneNumbers(content),
      imageCount: _countImages(email.htmlBody ?? ''),
    );
  }

  /// 提取 URLs
  List<UrlInfo> _extractUrls(String content) {
    final matches = _urlPattern.allMatches(content);
    final urls = <UrlInfo>[];

    for (final match in matches) {
      final url = match.group(0)!;
      try {
        final uri = Uri.parse(url);
        urls.add(UrlInfo(
          url: url,
          anchorText: _extractAnchorText(content, match.start),
          scheme: uri.scheme,
          host: uri.host,
          eTldPlusOne: _extractETldPlusOne(uri.host),
        ));
      } catch (e) {
        // 忽略無效 URL
      }
    }

    return urls;
  }

  /// 提取域名資訊
  List<DomainInfo> _extractDomains(String content) {
    final urls = _extractUrls(content);
    final domains = <String, DomainInfo>{};

    for (final url in urls) {
      if (domains.containsKey(url.eTldPlusOne)) continue;

      domains[url.eTldPlusOne] = DomainInfo(
        domain: url.host,
        eTldPlusOne: url.eTldPlusOne,
        isPunycode: _punycodePattern.hasMatch(url.host),
        hasUserinfo: _userinfoPattern.hasMatch(url.url),
        hasHomoglyph: _detectHomoglyph(url.host),
        suspiciousPatterns: _detectSuspiciousPatterns(url.host),
      );
    }

    return domains.values.toList();
  }

  /// 檢測 Homoglyph（同形異義字元）
  bool _detectHomoglyph(String domain) {
    // 檢測 Cyrillic, Greek 等字元
    final cyrillic = RegExp(r'[\u0400-\u04FF]');
    final greek = RegExp(r'[\u0370-\u03FF]');

    return cyrillic.hasMatch(domain) || greek.hasMatch(domain);
  }

  /// 檢測可疑模式
  List<String> _detectSuspiciousPatterns(String domain) {
    final patterns = <String>[];

    // 常見品牌模仿
    final brandPatterns = {
      'apple': RegExp(r'app[1l]e|appl[e3]', caseSensitive: false),
      'google': RegExp(r'g[o0]{2}gle|googl[e3]', caseSensitive: false),
      'paypal': RegExp(r'pay[p]?al|p[a4]yp[a4]l', caseSensitive: false),
    };

    for (final entry in brandPatterns.entries) {
      if (entry.value.hasMatch(domain) && !domain.contains(entry.key)) {
        patterns.add('brand_impersonation:${entry.key}');
      }
    }

    return patterns;
  }

  /// 提取日期
  List<DateTime> _extractDates(String content) {
    final dates = <DateTime>[];

    for (final pattern in _datePatterns) {
      final matches = pattern.allMatches(content);
      for (final match in matches) {
        try {
          final date = DateTime.parse(match.group(0)!);
          dates.add(date);
        } catch (e) {
          // 忽略無效日期
        }
      }
    }

    return dates;
  }

  /// 提取金額
  List<Amount> _extractAmounts(String content) {
    final matches = _amountPattern.allMatches(content);
    final amounts = <Amount>[];

    for (final match in matches) {
      final currency = match.group(1)!;
      final valueStr = match.group(2)!.replaceAll(',', '');

      try {
        final value = double.parse(valueStr);
        amounts.add(Amount(
          value: value,
          currency: _normalizeCurrency(currency),
          rawText: match.group(0)!,
        ));
      } catch (e) {
        // 忽略無效金額
      }
    }

    return amounts;
  }

  /// 標準化幣種
  String _normalizeCurrency(String raw) {
    const currencyMap = {
      '\$': 'USD',
      'NT\$': 'TWD',
    };

    return currencyMap[raw] ?? raw;
  }

  /// 提取錨點文字
  String _extractAnchorText(String content, int urlStart) {
    // 簡化實作：查找前後的文字
    final before = content.substring(max(0, urlStart - 50), urlStart);
    final linkTextMatch = RegExp(r'>\s*([^<]+?)\s*<').firstMatch(before);

    return linkTextMatch?.group(1)?.trim() ?? '';
  }

  /// 提取 eTLD+1
  String _extractETldPlusOne(String host) {
    final parts = host.split('.');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2]}.${parts[parts.length - 1]}';
    }
    return host;
  }

  /// 計算圖片數量
  int _countImages(String html) {
    return '<img'.allMatches(html).length +
           'data:image/'.allMatches(html).length;
  }

  /// 提取電話號碼
  List<String> _extractPhoneNumbers(String content) {
    // 支援多種格式：+886-2-1234-5678, (02) 1234-5678, 0912-345-678
    final patterns = [
      RegExp(r'\+\d{1,3}-\d{1,4}-\d{4}-\d{4}'),
      RegExp(r'\(\d{2}\)\s*\d{4}-\d{4}'),
      RegExp(r'09\d{2}-\d{3}-\d{3}'),
    ];

    final phones = <String>{};
    for (final pattern in patterns) {
      phones.addAll(pattern.allMatches(content).map((m) => m.group(0)!));
    }

    return phones.toList();
  }
}
```

---

### 2.6 OptimizedPromptBuilder

**目的**: 構建精簡的 Prompt（1500 tokens for security, 1200 tokens for summary）

#### 類別定義

```dart
/// Prompt 構建器
class OptimizedPromptBuilder {
  final PromptTemplateLibrary _templates;
  final TokenEstimator _tokenEstimator;

  /// 構建精簡安全分析 Prompt
  String buildCompactSecurityPrompt({
    required Email email,
    required SimpleSecurityAnalysis ruleHints,
    required ExtractedElements extractedElements,
  }) {
    // 1. 選擇模板（基於規則 hints 選擇詳細程度）
    final template = ruleHints.threatLevel >= ThreatLevel.medium
      ? _templates.securityAnalysisDetailed
      : _templates.securityAnalysisCompact;

    // 2. 格式化 hints
    final hints = _formatSecurityHints(ruleHints, extractedElements);

    // 3. 截斷內容以符合預算
    final contentBudget = _calculateContentBudget(template, hints);
    final truncatedBody = _truncateContent(email.body, contentBudget);

    // 4. 填充模板
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
      final suspicious = extracted.domains.where((d) =>
        d.isPunycode || d.hasUserinfo || d.hasHomoglyph
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
      buffer.writeln('Amounts: ${extracted.amounts.map((a) => a.rawText).join(", ")}');
    }

    return buffer.toString();
  }

  /// 計算內容預算
  int _calculateContentBudget(String template, String hints) {
    const maxInput = 3196; // 4096 - 900 (output buffer)

    final templateTokens = _tokenEstimator.estimate(template);
    final hintsTokens = _tokenEstimator.estimate(hints);
    final metadataTokens = 100; // 預留給 subject, from, to

    final available = maxInput - templateTokens - hintsTokens - metadataTokens;
    return max(500, available); // 最少保留 500 tokens
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

---

### 2.7 PromptTemplateLibrary

**目的**: 管理精簡的 Prompt 模板

#### 模板定義

```dart
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

  /// 安全分析 - 詳細版（~1500 tokens，用於已有可疑指標的郵件）
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

---

## 3. 資料流程

### 3.1 Fast Path 流程圖

```
[Email Input]
    │
    ▼
[ContentRouter.route()]
    │ (length <6k, tokens <2k)
    ▼
[ProcessingPath.fast]
    │
    ├──────────────┬───────────────┐
    │              │               │
    ▼              ▼               ▼
[Rule Check]  [Extract     [Preprocess
(100ms)        Elements]    Content]
               (50ms)       (100ms)
    │              │               │
    └──────────────┴───────────────┘
                   │
                   ▼
        [Build Compact Prompt]
        (template ~1200 tokens)
                   │
                   ▼
        [Single AI Call]
        (TTFT ~600ms)
                   │
                   ▼
        [Merge Rule + AI]
        (50ms)
                   │
                   ▼
        [SecurityAnalysis]

Total latency: ~900ms (p50), ~1.2s (p95)
```

### 3.2 Standard Path 流程圖

```
[Email Input]
    │
    ▼
[ContentRouter.route()]
    │ (6k < length < 24k)
    ▼
[ProcessingPath.standard]
    │
    ▼
[Preprocess Content]
(HTML → Markdown, Extract)
    │
    ▼
[Check Token Budget]
    │
    ├─ Fits → [Direct Processing]
    │           │
    │           ▼
    │        [Build Standard Prompt]
    │           │
    │           ▼
    │        [Single AI Call]
    │
    └─ Exceeds → [Recursive Summarization]
                    │
                    ▼
                 [Split with Overlap]
                 (12.5% overlap)
                    │
                    ▼
                 [Process Each Segment]
                 (parallel if possible)
                    │
                    ▼
                 [Merge Summaries]
                 (dedup + filter)
                    │
                    ▼
                 [Check Combined Length]
                    │
                    ├─ OK → [Result]
                    └─ Still long → [Recursive Compress]

Total latency: ~2-4s (depends on segments)
```

### 3.3 Complex Path 流程圖

```
[Email Input]
    │
    ▼
[ContentRouter.route()]
    │ (length >24k)
    ▼
[ProcessingPath.complex]
    │
    ▼
[Check Feasibility]
    │
    ├─ Can process → [Enhanced Recursive Strategy]
    │                   │
    │                   ▼
    │                [Aggressive Content Compression]
    │                (smart paragraph selection)
    │                   │
    │                   ▼
    │                [Multi-level Summarization]
    │                   │
    │                   ▼
    │                [Result]
    │
    └─ Too long → [Fallback Options]
                     │
                     ├─ [Use Remote AI]
                     │   (unlimited context)
                     │
                     └─ [Extract Key Info Only]
                         (URLs, amounts, summary)

Total latency: ~5-8s (on-device), ~3-5s (remote)
```

---

## 4. API 設計

### 4.1 公開 API

**FoundationAIProvider** 的公開介面保持不變，內部實作優化：

```dart
abstract class AIProvider {
  /// 安全威脅分析
  Future<SecurityAnalysis> analyzeSecurityThreats(Email email);

  /// 內容摘要
  Future<EmailSummary> summarizeContent(Email email, {int maxLength = 200});

  /// 生成回覆建議
  Future<List<ReplySuggestion>> generateReplies(Email email);

  /// 實體擷取
  Future<ExtractedEntities> extractEntities(Email email);
}
```

### 4.2 內部 API（新增）

```dart
/// 內容路由器
class ContentRouter {
  RoutingDecision route(Email email, String operation);
  bool canDowngrade(ProcessingPath current);
}

/// 快速處理器
class FastPathProcessor {
  Future<SecurityAnalysis> analyzeSecurityFast(Email email);
  Future<EmailSummary> summarizeFast(Email email);
}

/// 增強預處理器
class EnhancedContentPreprocessor {
  ProcessedContent preprocess(Email email);
}

/// HTML 轉換器
class HtmlToMarkdownConverter {
  String convert(String html);
}

/// 內容抽取器
class ContentExtractor {
  ExtractedElements extract(Email email);
}

/// Prompt 構建器
class OptimizedPromptBuilder {
  String buildCompactSecurityPrompt({
    required Email email,
    required SimpleSecurityAnalysis ruleHints,
    required ExtractedElements extractedElements,
  });

  String buildCompactSummaryPrompt({
    required Email email,
    required ExtractedElements extractedElements,
  });
}
```

---

## 5. 演算法設計

### 5.1 動態路由演算法

```dart
RoutingDecision route(Email email, String operation) {
  // 1. 計算基本指標
  final charLength = email.body.length;
  final tokenCount = _tokenEstimator.estimate(email.body);

  // 2. 快速路徑條件
  if (_isFastPathEligible(charLength, tokenCount, operation)) {
    return RoutingDecision(path: ProcessingPath.fast, ...);
  }

  // 3. 複雜路徑條件
  if (_isComplexPathRequired(charLength, tokenCount, operation)) {
    return RoutingDecision(path: ProcessingPath.complex, ...);
  }

  // 4. 預設標準路徑
  return RoutingDecision(path: ProcessingPath.standard, ...);
}

bool _isFastPathEligible(int chars, int tokens, String operation) {
  // 基本閾值
  if (chars >= _fastPathCharLimit || tokens >= _fastPathTokenLimit) {
    return false;
  }

  // 特定操作的額外條件
  if (operation == 'security_analysis') {
    // 安全分析需要更保守（因需要完整上下文）
    return chars < _fastPathCharLimit * 0.8;
  }

  return true;
}
```

### 5.2 威脅等級合併演算法

```dart
ThreatLevel _mergeThreatLevel(ThreatLevel ruleLevel, ThreatLevel aiLevel) {
  // 規則 1: 規則檢測到 HIGH/CRITICAL → 最終結果不能低於此
  if (ruleLevel.index >= ThreatLevel.high.index) {
    return ruleLevel;
  }

  // 規則 2: 規則檢測到 LOW → AI 不能升級為 HIGH
  // （防止誤報，因為規則已排除明顯高風險指標）
  if (ruleLevel == ThreatLevel.low && aiLevel.index >= ThreatLevel.high.index) {
    return ThreatLevel.medium; // Cap at MEDIUM
  }

  // 規則 3: 其他情況取較高者
  return ruleLevel.index > aiLevel.index ? ruleLevel : aiLevel;
}
```

### 5.3 內容截斷演算法

```dart
String _truncateContent(String content, int budgetTokens) {
  final currentTokens = _tokenEstimator.estimate(content);

  if (currentTokens <= budgetTokens) {
    return content;
  }

  // 1. 計算目標長度（保守估算）
  final ratio = budgetTokens / currentTokens;
  final targetChars = (content.length * ratio * 0.9).floor();

  // 2. 嘗試在段落邊界截斷
  final paragraphBoundary = _findBoundary(
    content,
    targetChars,
    RegExp(r'\n\n'),
    tolerance: 0.15,
  );

  if (paragraphBoundary != null) {
    return '${content.substring(0, paragraphBoundary)}…';
  }

  // 3. 嘗試在句子邊界截斷
  final sentenceBoundary = _findBoundary(
    content,
    targetChars,
    RegExp(r'[。.!?！？]\s*'),
    tolerance: 0.25,
  );

  if (sentenceBoundary != null) {
    return '${content.substring(0, sentenceBoundary)}…';
  }

  // 4. 強制截斷
  return '${content.substring(0, targetChars)}…';
}

int? _findBoundary(
  String content,
  int target,
  RegExp pattern,
  {required double tolerance},
) {
  final minPos = (target * (1 - tolerance)).floor();
  final maxPos = min((target * (1 + tolerance)).floor(), content.length);

  // 向後搜尋邊界
  final searchSpace = content.substring(minPos, maxPos);
  final match = pattern.firstMatch(searchSpace);

  if (match != null) {
    return minPos + match.end;
  }

  return null;
}
```

---

## 6. 效能優化策略

### 6.1 Token 估算快取

```dart
class CachedTokenEstimator {
  final TokenEstimator _estimator;
  final Map<int, int> _cache = {};

  static const int _maxCacheSize = 1000;

  int estimate(String text) {
    final hash = text.hashCode;

    // 檢查快取
    if (_cache.containsKey(hash)) {
      return _cache[hash]!;
    }

    // 計算並快取
    final tokens = _estimator.estimate(text);

    // LRU 策略
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

    _cache[hash] = tokens;
    return tokens;
  }

  void clearCache() {
    _cache.clear();
  }
}
```

### 6.2 Model Prewarming

```dart
class FoundationAIProvider {
  bool _isPrewarmed = false;

  /// 預熱模型（在應用啟動或進入郵件列表時呼叫）
  Future<void> prewarm() async {
    if (_isPrewarmed) return;

    try {
      // Apple 官方建議：使用 prewarm 預載資源
      await _client.prewarm();
      _isPrewarmed = true;
    } catch (e) {
      // 預熱失敗不影響功能
      _logger.warning('Model prewarming failed: $e');
    }
  }

  /// 檢查是否需要預熱
  bool _shouldPrewarm() {
    // 基於使用模式決定（如用戶打開郵件列表頁）
    return true;
  }
}
```

### 6.3 並行處理優化

```dart
Future<EmailSummary> _recursiveSummarize(String content) async {
  final segments = _splitWithOverlap(content, ...);

  // 並行處理（受 Foundation Models 併發限制）
  const maxConcurrent = 2; // 保守值，避免過載裝置

  final summaries = <EmailSummary>[];

  for (var i = 0; i < segments.length; i += maxConcurrent) {
    final batch = segments.skip(i).take(maxConcurrent);

    // 並行處理這一批
    final batchResults = await Future.wait(
      batch.map((seg) => _summarizeSingleSegment(seg)),
    );

    summaries.addAll(batchResults);
  }

  return _mergePartialSummaries(summaries);
}
```

---

## 7. 錯誤處理

### 7.1 降級策略

```dart
Future<SecurityAnalysis> analyzeSecurityThreats(Email email) async {
  // 1. 嘗試最佳路徑
  try {
    final decision = _router.route(email, 'security_analysis');

    switch (decision.path) {
      case ProcessingPath.fast:
        return await _fastProcessor.analyzeSecurityFast(email);

      case ProcessingPath.standard:
        return await _standardProcessor.analyzeSecurityStandard(email);

      case ProcessingPath.complex:
        return await _complexProcessor.analyzeSecurityComplex(email);
    }
  } on LocalAIUnavailableException catch (e) {
    // 2. 本地 AI 不可用 → 降級到遠端
    _logger.warning('Local AI unavailable, falling back to remote: $e');
    return await _remoteProvider.analyzeSecurityThreats(email);

  } on PromptTooLongException catch (e) {
    // 3. Prompt 過長 → 嘗試更激進的壓縮
    _logger.warning('Prompt too long, trying aggressive compression: $e');

    try {
      return await _complexProcessor.analyzeWithAggressiveCompression(email);
    } catch (e2) {
      // 4. 仍然失敗 → 降級到規則分析
      _logger.error('Aggressive compression failed, using rules only: $e2');
      return _ruleAnalyzer.analyze(email).toSecurityAnalysis();
    }

  } catch (e) {
    // 5. 其他錯誤 → 降級到規則分析
    _logger.error('Unexpected error in AI analysis: $e');
    return _ruleAnalyzer.analyze(email).toSecurityAnalysis();
  }
}
```

### 7.2 錯誤類型定義

```dart
/// 本地 AI 不可用
class LocalAIUnavailableException implements Exception {
  final String message;
  final String? reason;

  LocalAIUnavailableException(this.message, {this.reason});
}

/// Prompt 過長
class PromptTooLongException implements Exception {
  final int actualTokens;
  final int maxTokens;

  PromptTooLongException(this.actualTokens, this.maxTokens);

  @override
  String toString() =>
    'Prompt too long: $actualTokens tokens (max: $maxTokens)';
}

/// 內容轉換失敗
class ContentConversionException implements Exception {
  final String message;
  final Object? originalError;

  ContentConversionException(this.message, {this.originalError});
}
```

---

## 8. 測試策略

### 8.1 單元測試

**測試覆蓋範圍**:

```dart
// content_router_test.dart
group('ContentRouter', () {
  test('routes short email to fast path', () { ... });
  test('routes medium email to standard path', () { ... });
  test('routes long email to complex path', () { ... });
  test('respects operation-specific thresholds', () { ... });
});

// fast_path_processor_test.dart
group('FastPathProcessor', () {
  test('analyzes short email within 1s', () { ... });
  test('merges rule and AI threat levels correctly', () { ... });
  test('caps threat level when rule says LOW', () { ... });
  test('preserves rule HIGH indicators', () { ... });
});

// html_to_markdown_converter_test.dart
group('HtmlToMarkdownConverter', () {
  test('converts simple table to markdown', () { ... });
  test('converts nested lists to markdown', () { ... });
  test('preserves link text and href', () { ... });
  test('handles malformed HTML gracefully', () { ... });
});

// content_extractor_test.dart
group('ContentExtractor', () {
  test('extracts all URLs from content', () { ... });
  test('detects punycode domains', () { ... });
  test('detects userinfo in URLs', () { ... });
  test('detects homoglyph characters', () { ... });
  test('extracts dates in multiple formats', () { ... });
  test('extracts amounts with currency symbols', () { ... });
});

// optimized_prompt_builder_test.dart
group('OptimizedPromptBuilder', () {
  test('compact security prompt <= 1500 tokens', () { ... });
  test('compact summary prompt <= 1200 tokens', () { ... });
  test('includes rule hints in prompt', () { ... });
  test('truncates content to fit budget', () { ... });
});
```

### 8.2 整合測試

```dart
// ai_optimization_integration_test.dart
group('AI Optimization Integration', () {
  testWidgets('short phishing email detected in <1s', (tester) async {
    // Given: 短釣魚郵件
    final email = createShortPhishingEmail();

    // When: 分析
    final stopwatch = Stopwatch()..start();
    final analysis = await aiProvider.analyzeSecurityThreats(email);
    stopwatch.stop();

    // Then: 正確偵測且快速
    expect(analysis.threatLevel, greaterThanOrEqualTo(ThreatLevel.high));
    expect(stopwatch.elapsedMilliseconds, lessThan(1500)); // p95
  });

  testWidgets('table structure preserved in summary', (tester) async {
    // Given: 包含財務表格的郵件
    final email = createEmailWithFinancialTable();

    // When: 摘要
    final summary = await aiProvider.summarizeContent(email);

    // Then: 摘要包含表格資訊
    expect(summary.summary, contains('總金額'));
    expect(summary.keyPoints, isNotEmpty);
    expect(summary.keyPoints.first, contains('$1,234.56'));
  });

  testWidgets('falls back to remote on local failure', (tester) async {
    // Given: 本地 AI 不可用
    aiProvider.setLocalAIAvailable(false);
    final email = createTestEmail();

    // When: 分析
    final analysis = await aiProvider.analyzeSecurityThreats(email);

    // Then: 使用遠端且成功
    expect(analysis, isNotNull);
    expect(analysis.usedRemoteAI, isTrue);
  });
});
```

### 8.3 效能測試

```dart
// performance_test.dart
group('Performance Benchmarks', () {
  test('Fast Path: <1s for 95% of short emails', () async {
    final emails = generateShortEmails(count: 100);
    final latencies = <int>[];

    for (final email in emails) {
      final stopwatch = Stopwatch()..start();
      await aiProvider.analyzeSecurityThreats(email);
      latencies.add(stopwatch.elapsedMilliseconds);
    }

    latencies.sort();
    final p95 = latencies[(latencies.length * 0.95).floor()];

    expect(p95, lessThan(1500)); // p95 < 1.5s
  });

  test('Standard Path: <4s for medium emails', () async {
    final emails = generateMediumEmails(count: 50);
    final latencies = <int>[];

    for (final email in emails) {
      final stopwatch = Stopwatch()..start();
      await aiProvider.summarizeContent(email);
      latencies.add(stopwatch.elapsedMilliseconds);
    }

    latencies.sort();
    final p95 = latencies[(latencies.length * 0.95).floor()];

    expect(p95, lessThan(4000)); // p95 < 4s
  });

  test('Token estimation cache improves performance', () async {
    final content = generateLongText(10000);

    // 未快取
    final stopwatch1 = Stopwatch()..start();
    tokenEstimator.estimate(content);
    final uncachedTime = stopwatch1.elapsedMicroseconds;

    // 已快取
    final stopwatch2 = Stopwatch()..start();
    tokenEstimator.estimate(content);
    final cachedTime = stopwatch2.elapsedMicroseconds;

    expect(cachedTime, lessThan(uncachedTime * 0.1)); // >10x faster
  });
});
```

### 8.4 準確率測試

```dart
// accuracy_test.dart
group('Phishing Detection Accuracy', () {
  test('achieves >=85% true positive rate', () async {
    final phishingEmails = loadPhishingDataset(); // 100 samples

    var truePositives = 0;
    for (final email in phishingEmails) {
      final analysis = await aiProvider.analyzeSecurityThreats(email);
      if (analysis.threatLevel.index >= ThreatLevel.medium.index) {
        truePositives++;
      }
    }

    final recall = truePositives / phishingEmails.length;
    expect(recall, greaterThanOrEqualTo(0.85)); // >=85%
  });

  test('achieves <=12% false positive rate', () async {
    final legitimateEmails = loadLegitimateDataset(); // 200 samples

    var falsePositives = 0;
    for (final email in legitimateEmails) {
      final analysis = await aiProvider.analyzeSecurityThreats(email);
      if (analysis.threatLevel.index >= ThreatLevel.medium.index) {
        falsePositives++;
      }
    }

    final fpr = falsePositives / legitimateEmails.length;
    expect(fpr, lessThanOrEqualTo(0.12)); // <=12%
  });
});
```

---

## 9. 部署與監控

### 9.1 Feature Flag

```dart
/// Feature flags for gradual rollout
class AIOptimizationFeatureFlags {
  /// 啟用 Fast Path
  static const bool enableFastPath = true;

  /// 啟用 HTML → Markdown 轉換
  static const bool enableMarkdownConversion = true;

  /// 啟用智能內容抽取
  static const bool enableContentExtraction = true;

  /// 使用精簡 Prompt
  static const bool useCompactPrompts = true;

  /// Fast Path 字元閾值（可動態調整）
  static int fastPathCharLimit = 6000;

  /// Fast Path token 閾值
  static int fastPathTokenLimit = 2000;
}
```

### 9.2 效能指標收集

```dart
/// 效能指標收集器
class AIPerformanceMetrics {
  final _latencies = <String, List<int>>{};
  final _pathUsage = <ProcessingPath, int>{};
  final _errors = <String, int>{};

  /// 記錄延遲
  void recordLatency(String operation, ProcessingPath path, int milliseconds) {
    final key = '${operation}_${path.name}';
    _latencies.putIfAbsent(key, () => []).add(milliseconds);
    _pathUsage[path] = (_pathUsage[path] ?? 0) + 1;
  }

  /// 記錄錯誤
  void recordError(String operation, String errorType) {
    final key = '${operation}_$errorType';
    _errors[key] = (_errors[key] ?? 0) + 1;
  }

  /// 匯出統計
  Map<String, dynamic> exportStats() {
    return {
      'latencies': _latencies.map((key, values) {
        values.sort();
        return MapEntry(key, {
          'p50': values[(values.length * 0.5).floor()],
          'p95': values[(values.length * 0.95).floor()],
          'p99': values[(values.length * 0.99).floor()],
          'count': values.length,
        });
      }),
      'pathUsage': _pathUsage,
      'errors': _errors,
    };
  }
}
```

---

## 10. 文件修訂歷史

| 版本 | 日期 | 作者 | 變更內容 |
|------|------|------|---------|
| 1.0.0 | 2025-10-31 | AI Team | 初始版本 |

---

**文件結束**

下一步：請參閱 `tasks.md` 了解 TDD 實施任務清單。
