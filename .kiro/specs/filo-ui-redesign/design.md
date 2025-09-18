# Awesome 風格 UI/UX 重構設計文件

## 概述

本設計文件基於 Awesome Mail for Mac 的設計哲學，為 Awesome Mail Flutter 應用程式定義了完整的 UI/UX 重構方案。設計重點在於**更新現有組件**以創建一個現代化、優雅且高效能的郵件客戶端，完全符合 Awesome Mail 的視覺風格和互動體驗。

## 重構策略

### 現有組件更新優先原則

本重構遵循「更新優於新建」的核心原則：

1. **現有頁面更新**：
   - 更新 `enhanced_macos_home_page.dart` 以實現三欄佈局
   - 擴展 `enhanced_settings_page.dart` 以符合 Awesome 設定介面風格
   - 修改 `compose_page.dart` 實現底部抽屜式撰寫介面

2. **現有組件擴展**：
   - 擴展 `MacOSDesignSystem` 添加 Awesome 特有的設計 tokens
   - 更新 `email_list_widget.dart` 實現 Awesome 風格的郵件清單
   - 修改 `app_button.dart`、`app_card.dart` 等共用組件

3. **漸進式改進**：
   - 保持現有 API 介面不變，僅更新視覺實現
   - 添加新的樣式選項而非替換現有樣式
   - 確保向後相容性

## 架構設計

### 整體架構

```
┌─────────────────────────────────────────────────────────────────┐
│                        macOS Title Bar                          │
├─────────────────────────────────────────────────────────────────┤
│                     Enhanced Toolbar                            │
├──────────────┬──────────────────────────┬─────────────────────────┤
│              │                          │                     │
│   Sidebar    │     Message List         │   Reading Pane      │
│   240-264px  │                          │   680-740px         │
│              │                          │                     │
│              │                          │                     │
│              │                          │                     │
│              │                          │                     │
│              │                          │                     │
│              │                          │                     │
│              │                          │                     │
│              │                          │                     │
│              │                          │                     │
└──────────────┴──────────────────────────┴─────────────────────────┤
│                     Composer Drawer (底部彈出)                   │
└─────────────────────────────────────────────────────────────────┘

                                          ┌─────────────────────┐
                                          │                     │
                                          │    AI Drawer        │
                                          │    360-380px        │
                                          │                     │
                                          │                     │
                                          │                     │
                                          │                     │
                                          │                     │
                                          │                     │
                                          └─────────────────────┘
```

### 核心組件層次

1. **MacOSWindow** - 主視窗容器
2. **EnhancedToolbar** - 頂部工具列
3. **ThreeColumnLayout** - 三欄主佈局
4. **AIDrawer** - 右側 AI 功能抽屜
5. **ComposerSheet** - 底部撰寫抽屜

## 組件與介面設計

### 1. 側邊欄 (Sidebar)

#### 設計規格
- **寬度**: 240-264px（可調整）
- **最小寬度**: 180px
- **最大寬度**: 320px
- **背景色**: 深色主題 `#1C1C1E`，淺色主題 `#F2F2F7`

#### 組件更新策略
**更新現有的 `MacOSSidebar` 組件**：
```dart
// 更新 lib/presentation/widgets/macos/macos_enhanced_components.dart
class MacOSSidebar extends StatelessWidget {
  // 添加 Awesome 風格支援
  final bool useAwesomeStyle;
  
  // 擴展現有的側邊欄項目配置
  final List<SidebarItem> items = [
    SidebarItem(icon: Icons.inbox, label: 'Inbox', count: 128),
    SidebarItem(icon: Icons.assignment, label: 'To-Do'),
    SidebarItem(icon: Icons.priority_high, label: 'Important'),
    SidebarItem(icon: Icons.update, label: 'Updates'),
    SidebarItem(icon: Icons.local_offer, label: 'Promotions'),
    SidebarItem(icon: Icons.star, label: 'Starred'),
    SidebarItem(icon: Icons.drafts, label: 'Draft'),
    SidebarItem(icon: Icons.send, label: 'Sent'),
    SidebarItem(icon: Icons.archive, label: 'Archive'),
    SidebarItem(icon: Icons.report, label: 'Spam'),
    SidebarItem(icon: Icons.delete, label: 'Trash'),
  ];
}
```

#### 視覺特色
- 選中狀態使用藍色背景 `#007AFF` 和圓角 `8px`
- 圖示大小 `16px`，文字使用 `SF Pro 13px`
- 項目間距 `4px`，內邊距 `8px 12px`

### 2. 郵件清單 (MessageList)

#### 設計規格
- **列高度**: 56-64px
- **頭像大小**: 32px 圓形
- **字體層次**: 主旨 `SF Pro 14px Semi-Bold`，摘要 `SF Pro 12px Regular`

#### 組件更新策略
**更新現有的 `EmailListWidget` 和 `EmailListItem`**：
```dart
// 更新 lib/presentation/widgets/email_list/email_list_widget.dart
class EmailListWidget extends StatelessWidget {
  // 添加 Awesome 風格支援
  final bool useAwesomeStyle;
  
  // 更新現有的 buildItem 方法
  Widget buildMessageItem(EmailMessage message) {
    return Container(
      height: useAwesomeStyle ? 60 : 56, // Awesome 風格使用較高的列
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 16), // 32px 直徑
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.subject, 
                  style: useAwesomeStyle 
                    ? MacOSTypography.titleMedium.copyWith(fontWeight: FontWeight.w600)
                    : MacOSTypography.titleMedium
                ),
                Text(message.preview, style: MacOSTypography.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message.time, style: MacOSTypography.caption),
              if (message.hasAttachment) Icon(Icons.attach_file, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}
```

#### 互動設計
- **Hover 效果**: 背景色變化 `rgba(255,255,255,0.05)`
- **快速動作**: 封存、刪除、標記、加星、釘選
- **滑動手勢**: 左滑封存，右滑刪除

### 3. 分類 Chips

#### 設計規格
```dart
class AwesomeMailboxChips extends StatelessWidget {
  final List<ChipData> chips = [
    ChipData(label: 'Important', count: 1, color: Colors.red),
    ChipData(label: 'Updates', count: 127, color: Colors.blue),
    ChipData(label: 'Promotions', count: 100, color: Colors.green),
    ChipData(label: 'All', count: 228, color: Colors.grey),
  ];
  
  Widget buildChip(ChipData chip) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: chip.isSelected ? chip.color : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: chip.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(chip.label, style: MacOSTypography.labelMedium),
          if (chip.count > 0) ...[
            SizedBox(width: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${chip.count}', style: MacOSTypography.caption),
            ),
          ],
        ],
      ),
    );
  }
}
```

### 4. 閱讀窗格 (ReadingPane)

#### 設計規格
- **寬度**: 680-740px
- **主旨字體**: `SF Pro 22-24px Semi-Bold`
- **內容字體**: `SF Pro 14px Regular`
- **行高**: 1.6

#### 組件結構
```dart
class FiloReadingPane extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MessageHeader(),
        MessageActionBar(),
        MessageBanner(), // 安全警示
        Expanded(child: MessageContent()),
      ],
    );
  }
}

class MessageHeader extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.subject,
            style: MacOSTypography.displaySmall.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          MessageMeta(),
        ],
      ),
    );
  }
}
```

### 5. AI 抽屜 (AIDrawer)

#### 設計規格
- **寬度**: 360-380px
- **背景色**: 深色主題 `#2C2C2E`
- **圓角**: 左側 `12px`

#### 組件結構
```dart
class FiloAIDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      decoration: BoxDecoration(
        color: MacOSColors.darkSecondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          AIDrawerHeader(),
          AISuggestionChips(),
          Expanded(child: AIConversation()),
          AIInputField(),
        ],
      ),
    );
  }
}

class AISuggestionChips extends StatelessWidget {
  final List<String> suggestions = [
    'Summarize this email',
    'Generate to-do',
    'Draft a reply',
    'Show emails awaiting my reply this week',
    'Summarize my writing style in a few lines',
    'Delete this week\'s verification code emails',
  ];
}
```

### 6. 撰寫抽屜 (ComposerSheet)

#### 設計規格
- **高度**: 動態調整，最小 300px
- **背景色**: 深色主題 `#1C1C1E`
- **圓角**: 頂部 `16px`

#### 組件結構
```dart
class FiloComposerSheet extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MacOSColors.darkBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          ComposerHeader(),
          ComposerFields(), // To, Cc, Bcc, Subject
          Expanded(child: ComposerEditor()),
          ComposerToolbar(),
        ],
      ),
    );
  }
}
```

## 資料模型

### 郵件資料模型

```dart
class EmailMessage {
  final String id;
  final String subject;
  final String preview;
  final String content;
  final EmailAddress sender;
  final List<EmailAddress> recipients;
  final DateTime timestamp;
  final bool isRead;
  final bool isStarred;
  final bool isPinned;
  final bool hasAttachment;
  final List<Attachment> attachments;
  final SecurityInfo security;
  final AIClassification classification;
}

class EmailAddress {
  final String email;
  final String displayName;
  final String? avatarUrl;
}

class SecurityInfo {
  final bool dkimValid;
  final bool spfValid;
  final bool dmarcValid;
  final TrustLevel trustLevel;
}

class AIClassification {
  final MailboxType type; // Important, Updates, Promotions, etc.
  final double confidence;
  final List<String> entities;
  final String? summary;
}
```

### 使用者偏好模型

```dart
class UserPreferences {
  final bool aiDrawerOpen;
  final double sidebarWidth;
  final ThemeMode themeMode;
  final String language;
  final Map<String, bool> featureFlags;
  final NotificationSettings notifications;
}
```

## 錯誤處理

### 錯誤狀態設計

1. **網路錯誤**
   - 顯示重試按鈕
   - 保持離線功能可用

2. **同步失敗**
   - 狀態指示器顯示同步狀態
   - 自動重試機制

3. **AI 功能錯誤**
   - 優雅降級到基本功能
   - 錯誤訊息使用友善語言

### 載入狀態

```dart
class LoadingStates {
  static Widget messageListSkeleton() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => MessageItemSkeleton(),
    );
  }
  
  static Widget aiThinking() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          LoadingDots(),
          SizedBox(width: 8),
          Text('AI 正在思考...', style: MacOSTypography.bodyMedium),
        ],
      ),
    );
  }
}
```

## 測試策略

### 單元測試

1. **組件測試**
   - 每個 UI 組件的渲染測試
   - 互動行為測試
   - 狀態管理測試

2. **資料模型測試**
   - 序列化/反序列化
   - 驗證邏輯
   - 邊界條件

### 整合測試

1. **使用者流程測試**
   - 郵件閱讀流程
   - 撰寫發送流程
   - AI 功能互動

2. **效能測試**
   - 大量郵件載入
   - 滾動效能
   - 記憶體使用

### 視覺回歸測試

```dart
void main() {
  group('Filo UI Visual Tests', () {
    testWidgets('MessageList renders correctly', (tester) async {
      await tester.pumpWidget(FiloMessageList(messages: mockMessages));
      await expectLater(
        find.byType(FiloMessageList),
        matchesGoldenFile('message_list.png'),
      );
    });
    
    testWidgets('AIDrawer renders correctly', (tester) async {
      await tester.pumpWidget(FiloAIDrawer());
      await expectLater(
        find.byType(FiloAIDrawer),
        matchesGoldenFile('ai_drawer.png'),
      );
    });
  });
}
```

## 效能考量

### 虛擬化渲染

```dart
class VirtualizedMessageList extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemExtent: 60, // 固定高度提升效能
      itemBuilder: (context, index) {
        if (index >= messages.length - 10) {
          // 預載入更多郵件
          loadMoreMessages();
        }
        return MessageListItem(message: messages[index]);
      },
    );
  }
}
```

### 圖片快取

```dart
class AvatarCache {
  static final Map<String, ImageProvider> _cache = {};
  
  static ImageProvider getAvatar(String email) {
    return _cache.putIfAbsent(
      email,
      () => CachedNetworkImageProvider(generateAvatarUrl(email)),
    );
  }
}
```

### 狀態管理

使用 Riverpod 進行狀態管理，確保高效能的狀態更新：

```dart
final messagesProvider = StateNotifierProvider<MessagesNotifier, MessagesState>(
  (ref) => MessagesNotifier(),
);

final selectedMessageProvider = Provider<EmailMessage?>((ref) {
  final messages = ref.watch(messagesProvider);
  final selectedId = ref.watch(selectedMessageIdProvider);
  return messages.messages.firstWhereOrNull((m) => m.id == selectedId);
});
```

## 無障礙設計

### 語義標籤

```dart
class AccessibleMessageItem extends StatelessWidget {
  Widget build(BuildContext context) {
    return Semantics(
      label: '來自 ${message.sender.displayName} 的郵件',
      hint: message.isRead ? '已讀' : '未讀',
      child: MessageListItem(message: message),
    );
  }
}
```

### 鍵盤導航

```dart
class KeyboardShortcuts extends StatelessWidget {
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.keyR): ReplyIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyA): ReplyAllIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyF): ForwardIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyE): ArchiveIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyS): StarIntent(),
      },
      child: Actions(
        actions: {
          ReplyIntent: CallbackAction<ReplyIntent>(
            onInvoke: (intent) => handleReply(),
          ),
          // ... 其他動作
        },
        child: child,
      ),
    );
  }
}
```

## 國際化支援

### 文字本地化

```dart
class FiloLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'zh_TW': {
      'inbox': '收件匣',
      'important': '重要',
      'updates': '更新',
      'promotions': '促銷',
      'compose': '撰寫',
      'reply': '回覆',
      'forward': '轉寄',
    },
    'en_US': {
      'inbox': 'Inbox',
      'important': 'Important',
      'updates': 'Updates',
      'promotions': 'Promotions',
      'compose': 'Compose',
      'reply': 'Reply',
      'forward': 'Forward',
    },
  };
}
```

### RTL 支援

```dart
class AdaptiveLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    
    return Row(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      children: [
        if (!isRTL) Sidebar(),
        Expanded(child: MessageList()),
        ReadingPane(),
        if (isRTL) Sidebar(),
      ],
    );
  }
}
```

這個設計文件提供了完整的 Filo 風格 UI/UX 重構技術方案，涵蓋了架構設計、組件規格、資料模型、錯誤處理、測試策略、效能優化和無障礙支援等各個方面。