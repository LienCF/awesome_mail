# Architecture Design Document

## 1. System Overview

**Awesome Mail** is a next-generation email client built with **Flutter** (mobile/desktop) and **Node.js/TypeScript** (backend). It emphasizes **Privacy**, **Security**, **AI-driven productivity**, and **Cross-Platform** consistency.

### Key Architectural Principles
- **Local-First & Hybrid AI**: Prioritize on-device processing (Apple Intelligence via `foundation_models_framework`) for privacy and speed, falling back to Cloudflare Workers (OpenAI/Anthropic) for complex tasks or when local models are unavailable. `AIChannelPolicy` orchestrates this routing based on availability and user preference (`device`, `cloud`, `auto`).
- **Secure by Design**: End-to-end encryption placeholders, rigorous phishing detection (`SimpleSecurityAnalyzer`), and secure credential storage (`CredentialManager` with platform-specific implementations). Backend uses `bcrypt` for passwords and encrypted payloads for sensitive data sync.
- **Reactive & Offline-Capable**: Built on `Bloc` pattern for state management and `Drift` (SQLite) for local persistence, ensuring full offline functionality with robust background synchronization (`BackgroundSyncService`, `IsolateManager`).
- **Modular & Scalable**: Clean Architecture with strict separation of concerns (Presentation, Domain, Data, Core).

---

## 2. High-Level Architecture

### 2.1 Frontend (Flutter)

- **Presentation Layer**:
  - **State Management**: `Bloc` / `Cubit`. `MailboxBloc` acts as the central coordinator for mailbox state, though it delegates specific tasks to `AccountManagementCubit`, `FolderCubit`, and `EmailSyncCubit`.
  - **UI Components**: Material 3 (Adaptive) + Platform-specific widgets (e.g., `MacOSHomePage`, `MacOSPreferencesDialog`).
  - **Navigation**: `AppRouter` with guard logic for protected routes.
- **Domain Layer**:
  - **Entities**: Pure Dart classes (e.g., `Email`, `Account`, `SecurityAnalysis`).
  - **Repositories**: Interfaces defining data operations (e.g., `EmailRepository`).
  - **Use Cases**: Business logic encapsulations (e.g., `ClassifyEmailUseCase`).
- **Data Layer**:
  - **Repositories Impl**: Concrete implementations (e.g., `GmailRepository`, `OutlookRepository`). `GmailRepository` specifically implements an optimized "ALL MAIL" sync strategy.
  - **Data Sources**:
    - **Local**: `Drift` database (SQLite), `FlutterSecureStorage`, `SharedPreferences`.
    - **Remote**: `ApiClient` (Dio/Http), `GmailRemoteService`, `OutlookProvider`.
  - **Providers**: Specialized data handlers (e.g., `FoundationAIProvider` for local AI, `RemoteAIProvider` for cloud AI).
- **Core Layer**:
  - **Services**: Singletons for system-wide functionality (e.g., `AuthService`, `SyncService`, `AIService`).
  - **Security**: `EncryptionService`, `BiometricService`, `PGPService`.
  - **Background**: `IsolateManager`, `BackgroundSyncService`.

### 2.2 Backend (Cloudflare Workers / Hono)

- **API Gateway**: RESTful API handling auth, sync, and AI proxying.
- **Auth Service**: OAuth token exchange/refresh, JWT issuance with refresh token rotation stored in KV.
- **Sync Service**: Handling cross-device settings and account synchronization (encrypted).
- **AI Service**: Proxy for LLM providers (OpenAI/Anthropic) with rate limiting and prompt engineering.
- **Storage**: Cloudflare D1 (Relational), KV (Cache), R2 (Storage), Durable Objects (Consistency).

---

## 3. Core Subsystems

### 3.1 Synchronization Engine (`EmailSynchronizer`)

A robust, multi-strategy sync engine ensures data consistency while minimizing bandwidth and battery usage.

- **Strategies**:
  - **Full Sync**: Fetches all emails (backward direction). Used for initial setup or recovery. Uses "metadata-only" first approach for speed.
  - **Incremental Sync**: Uses Gmail History API (forward direction) or Outlook Delta Sync to fetch only changes since the last sync.
  - **Resume Sync**: Continues pagination from the last saved token (backward direction).
- **Parallelism**: Supports concurrent Forward (Incremental) and Backward (Full/Resume) syncs. This allows users to see new emails immediately while historical data backfills.
- **Rate Limit Handling**: `GmailRepository` implements adaptive page sizing and automatic retries with exponential backoff to handle 429 Too Many Requests errors.
- **Infrastructure**:
  - **Background Processing**: Uses `IsolateManager` to run sync tasks off the main thread.
  - **State Management**: `SyncStateManager` tracks cursors (`historyId`, `pageToken`) and sync status.
  - **Drift Detection**: `SyncHealthChecker` and `AutoRepair` mechanisms detect and fix consistency issues.

### 3.2 AI Integration (Hybrid Architecture)

- **Coordinator**: `AIInitCoordinator` manages background prewarming of local models.
- **Routing**: `AIChannelPolicy` dynamically routes requests based on task complexity, device capabilities, and user settings (Auto/Local-Only/Cloud-Only).
- **Providers**:
  - **Local**: `FoundationAIProvider` interacts with Apple Intelligence via `foundation_models_framework`. Used for summarization, smart replies, and basic classification.
  - **Remote**: `RemoteAIProvider` calls the backend for advanced context analysis and complex reasoning.
- **Concurrency**: `AiSessionSemaphore` limits concurrent local model sessions to prevent resource exhaustion.
- **Features**:
  - **Smart Summary**: Auto-generates summaries for long emails.
  - **Smart Reply**: Context-aware reply suggestions.
  - **Security Analysis**: AI-assisted threat detection.
  - **Title Generation**: concise titles for display.

### 3.3 Security & Privacy

- **Phishing Detection**: `SimpleSecurityAnalyzer` implements heuristics for:
  - **Homoglyphs/Punycode**: Detecting confusing characters in URLs.
  - **Brand Mismatch**: Checking if sender domain matches claimed brand in content/links.
  - **Urgency/Bait**: Detecting "act now" or "winner" patterns.
- **Encryption**:
  - **At Rest**: `EncryptionService` (AES-256) for sensitive fields in DB. `FlutterSecureStorage` for tokens/credentials.
  - **PGP**: `PGPService` (via `openpgp`) for end-to-end email encryption/signing.
- **Authentication**:
  - **OAuth**: `UnifiedOAuthService` aggregates Google and Apple sign-in.
  - **Biometrics**: `BiometricService` for local app lock and sensitive action confirmation.
  - **Token Management**: `AuthService` handles token refresh, revocation, and secure storage (with macOS Keychain corruption recovery strategies).

### 3.4 Database Schema (Drift)

- **Accounts**: `id`, `email`, `provider`, `oauth_tokens` (encrypted).
- **Emails**: `id`, `threadId`, `subject`, `body`, `htmlBody`, `sender`, `recipients`, `flags`, `aiSummary`, `securityScore`.
- **Folders**: `id`, `name`, `type` (inbox, sent, etc.), `unreadCount`.
- **SyncMetadata**: `accountId`, `folderId`, `syncToken`, `lastSyncTime`.
- **Attachments**: `id`, `emailId`, `filename`, `size`, `localPath`, `remoteUrl`.

---

## 4. Platform Specifics

- **macOS**:
  - **Menu Bar**: `MenuService` via MethodChannels for native menu actions (New Email, Sync, etc.).
  - **UI**: 3-column layout (`MacOSHomePage`), native-style toolbar, preferences dialog.
- **Android/iOS**:
  - **Intents**: `AppIntentService` for handling shortcuts and deep links.
  - **OAuth**: Native SDK integrations.

## 5. Development & Testing

- **DI**: `get_it` + `injectable` for dependency injection.
- **Logging**: `AwesomeLogger` with file rotation and console output.
- **Remote Config**: `RemoteConfigService` for feature flags and A/B testing.
- **Testing**: Unit, Widget, and Integration tests covering core flows (Auth, Sync, AI).