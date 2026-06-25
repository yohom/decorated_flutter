# AGENTS

This file records repository-specific working rules for coding agents and automated contributors.

## Testing

- Test files must not import `package:decorated_flutter/decorated_flutter.dart` directly.
- In tests, import only the specific classes, extensions, functions, or widgets under test, plus `package:flutter_test/flutter_test.dart`.
- This avoids symbol collisions with the test framework, such as the `isTrue` conflict caused by `decorated_flutter.dart` re-exporting helpers from `src/utils/functions.dart`.

## Changelog

- Always check `pubspec.yaml` before editing `CHANGELOG.md`.
- If the current package version is `x.y.z-dev.n`, write changelog entries under the `x.y.z` section instead of creating a `next` section.
- `CHANGELOG.md` is user-facing. Only record changes users can perceive, such as features, fixes, behavior changes, or compatibility changes.
- Do not add internal-only notes such as test import rules, repository conventions, or other contributor-facing process updates to `CHANGELOG.md`.

## Notes

- Prefer the narrowest possible imports in tests so dependencies stay explicit and failures are easier to reason about.
