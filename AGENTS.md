# Repository Guidelines

## Project Structure & Module Organization
- Monorepo with backend `awesome-mail/` (Cloudflare Workers TypeScript) and Flutter client `awesome_mail_flutter/`; code in `src/` and `lib/`, tests in `tests/`, `test/`, `integration_test/`.
- Specs live in `.kiro/*`; read the matching `requirements.md`, `design.md`, `tasks.md`, plus `CLAUDE.md` before editing to keep work aligned with requirements.

## Workflow & Spec Compliance
- Follow Spec-Driven TDD: map tasks to requirements, honor design notes, then iterate through Red→Green→Refactor loops with small commits.
- After three failed attempts on a problem, pause, log findings, research alternatives, and reassess assumptions before proceeding.
- Do not bypass tooling (`--no-verify`) or disable tests; run lint/format/type-check suites and keep documentation current.
- Update existing files and preserve public APIs by default; create new modules only when the spec explicitly requires one.

## Build, Test & Development Commands
- `awesome-mail/`: `npm ci`, `npm run dev`, `npm run lint`, `npm run type-check`, `npm run build`, `npm run test:coverage`; run `npm run test:ai` only with authorized credentials.
- `awesome_mail_flutter/`: `flutter pub get`, `dart run build_runner build --delete-conflicting-outputs`, `flutter gen-l10n`, `flutter run`, `flutter test --coverage`.
- Execute `scripts/test-runner.sh` for cross-stack regression; it enforces coverage ≥90% and produces consolidated reports.

## Coding Style & Naming Conventions
- Backend follows ESLint + Prettier: two-space indentation, semicolons, `const`, kebab-case sources, `*.test.ts` specs, no unused identifiers or `any` without justification.
- Flutter honors `very_good_analysis`: single quotes, trailing commas, camelCase identifiers, no `print`, architecture split across `core/`, `data/`, `features/`, `presentation/`, `shared/`; extend existing components instead of duplicating them.

## Testing & Coverage Expectations
- Backend unit specs live in `tests/unit/`, integrations in `tests/integration/`; mock external services unless running real AI tests. Target ≥90% unit, ≥80% integration, and 100% coverage on critical flows.
- Flutter unit/widget tests stay in `test/`, end-to-end flows in `integration_test/`; name files like `feature_action_test.dart`, keep coverage ≥90%, and add regression cases when fixing bugs.

## Commit & Pull Request Guidelines
- Use Conventional Commits (e.g. `feat(auth): add oauth refresh`), keep summaries imperative, and choose scopes that mirror module names.
- PRs should cite relevant specs/tasks, describe behaviour changes, attach lint/test output, and include screenshots for UI updates plus notes for config adjustments (`wrangler.toml`, OAuth settings).

## Security & Configuration Tips
- Never commit secrets; manage Worker bindings and OAuth keys through Wrangler secrets or platform keychains.
- Default AI features to mock endpoints; set `ENABLE_REAL_AI_API_TESTS=true` only when approved credentials are present and document the run.

## Additional Notes
- Always response in Traditional Chinese.