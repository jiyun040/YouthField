---
name: player-profile-registration
description: Use when the user asks to register or update a player profile, player metadata, or profile setup flow in YouthField.
paths:
  - lib/features/player/**
  - lib/features/auth/presentation/pages/profile_setup_page.dart
  - lib/features/auth/presentation/providers/profile_setup_provider.dart
  - lib/features/mypage/**
  - lib/core/services/user_session.dart
  - lib/core/providers/user_session_provider.dart
  - assets/images/players/**
---

Use this skill for player profile registration or profile-related updates.

Before doing any write action, ask the user for confirmation.

Follow these steps:
1. Read [shared project rules](../_shared/project-rules.md) first.
2. Clarify whether the request is about onboarding profile setup, stored user profile data, or static player catalog data.
3. Trace the flow before editing:
   - profile setup page and provider
   - user session storage and related Riverpod providers
   - mypage profile presentation
   - player entities or static club data if the change is about player catalog content
4. If the UI changes, verify the related Riverpod provider state, saved values, and refresh or invalidation path.
5. Keep data shape consistent across entity, provider, and UI layers.
6. Call out any image or asset dependency that must also be updated.

Special notes:
- Separate user-owned profile data from app-bundled player data.
- Prefer minimal schema changes unless the user explicitly asks for a broader redesign.
