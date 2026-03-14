# Tasks & Roadmap

## [完成] Completed

- [x] **Core Architecture**: Clean Architecture layers (Presentation, Domain, Data, Core) setup.
- [x] **Dependency Injection**: `get_it` + `injectable` configuration.
- [x] **Database**: Drift (SQLite) schema and migrations for Accounts, Emails, Folders.
- [x] **Networking**: `ApiClient` with Dio, retry logic, and interceptors.
- [x] **Authentication**:
    - [x] `AuthService` with JWT management.
    - [x] OAuth integration (Google, Apple, Outlook).
    - [x] Biometric authentication.
- [x] **Synchronization**:
    - [x] `EmailSynchronizer` with Parallel Forward/Backward strategies.
    - [x] `BackgroundSyncService` and `IsolateManager`.
    - [x] Gmail History API integration (Incremental Sync).
    - [x] Outlook Delta Sync.
    - [x] `GmailRepository` robust sync with 429 rate-limit handling and dynamic batch sizing.
- [x] **AI System**:
    - [x] `HybridAIProvider` and `AIChannelPolicy`.
    - [x] Apple Intelligence integration (`foundation_models_framework`).
    - [x] Cloud fallback (OpenAI/Anthropic via Hono backend).
    - [x] Phishing detection (`SimpleSecurityAnalyzer`).
- [x] **UI/UX**:
    - [x] Adaptive layouts (Mobile/Desktop).
    - [x] macOS specific UI (`MacOSHomePage`, Native Toolbar).
    - [x] Email list, Detail view, Compose.
    - [x] "Send Later" scheduling UI.
- [x] **Backend**:
    - [x] Hono API Gateway (Auth, Sync, AI endpoints).
    - [x] Secure credential handling (bcrypt, encrypted payloads).
    - [x] Usage tracking and rate limiting.
- [x] **Codebase Audit**: Comprehensive analysis of all layers (Core, Data, Presentation, Backend).
- [x] **Refactoring**:
    - [x] **`MailboxBloc` Decomposition**: Split into `MailboxSelectionCubit` and `MailboxActionCubit`.
    - [x] **Dynamic Sync Optimization**: Adaptive batch sizes for `GmailRepository`.
    - [x] **Technical Debt**: Reduced log verbosity in `TextSanitizer`, removed `DebugStorage`, cleaned up OAuth mocks.
- [x] **Testing**:
    - [x] `EmailSynchronizer` Unit Tests (parallel sync, edge cases).
    - [x] Full Sync Flow Integration Tests.
    - [x] **E2E Testing**: Patrol setup and smoke tests implemented.
- [x] **Push Notifications**:
    - [x] APNs/FCM client-side handlers implemented.
    - [x] NotificationService integrated.
- [x] **Features**:
    - [x] **Snooze UI**: Implemented snooze functionality with DB support.
    - [x] **PGP**: Implemented PGP Key Management and Encrypt toggle.
    - [x] **Unified Inbox**: Implemented "All Inboxes" view.
    - [x] **Calendar**: `CalendarService` implemented with `device_calendar`.
    - [x] **Voice**: `VoiceInputService` implemented with `speech_to_text`.
- [x] **Smart Search**:
    - [x] **Local Vector Search**: Implemented `LocalVectorService` (mocked model), `VectorSearchService`, and hybrid `EmailSearchService`.
    - [x] **RAG**: Integrated embedding generation into `AiTaskQueueService`.
    - [x] **Advanced Search**: Server-side vector search for semantic queries.
- [x] **Web Support**: Polished DB connection for Web compatibility (Wasm/Native split).
- [x] **Voice Assistant**: Integrate voice input into UI components (Search, Compose).
- [x] **Calendar Integration**: Add UI action to create calendar event from email.
- [x] **Performance Tuning**: 
    - [x] Profiled `EmailListWidget` scrolling.
    - [x] Optimized DB queries with composite indexes.
    - [x] Implemented `compute` isolate for heavy DB mapping.
- [x] **Offline Mode**: Robust offline handling and optimistic UI updates.

## [進行中] In Progress / Refinement

## [待辦] Pending / Future