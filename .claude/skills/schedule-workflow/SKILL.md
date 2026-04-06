---
name: schedule-workflow
description: Use when the user asks about match schedules, says "gyeonggi iljeong", sends a schedule-related link, or requests proxy changes for schedule data.
paths:
  - lib/features/schedule/**
  - lib/features/main/presentation/pages/home_tab.dart
  - lib/features/main/presentation/widgets/schedule_item.dart
  - proxy/api/schedule.js
  - proxy/api/joinkfa.js
  - proxy/api/match-detail.js
---

Use this skill for schedule-view work in YouthField.

Before doing any write action, ask the user for confirmation.

Follow these steps:
1. Read [shared project rules](../_shared/project-rules.md) first.
2. Identify the source of truth: K League, JoinKFA, proxy response, or a direct link the user provided.
3. Trace the flow end to end before editing:
   - `proxy/api/*.js`
   - `lib/features/schedule/data/services/*.dart`
   - `lib/features/schedule/data/repositories/*.dart`
   - `lib/features/schedule/presentation/providers/*.dart`
   - `lib/features/schedule/presentation/pages/*.dart`
4. If the UI changes, explicitly verify the matching Riverpod providers and loading or error states.
5. If the data contract changes, verify parsing models and widgets together.
6. Summarize impact in terms of proxy, data parsing, provider state, and UI behavior.

Special notes:
- If the user sends a link, classify it first and explain which layer needs to change.
- Prefer small contract-safe changes over broad rewrites.
