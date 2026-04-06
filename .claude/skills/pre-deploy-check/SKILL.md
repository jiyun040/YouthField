---
name: pre-deploy-check
description: Use before deployment, release verification, or when the user asks for a final check of Flutter app or proxy server changes.
paths:
  - lib/**
  - proxy/**
  - pubspec.yaml
  - firebase.json
---

Use this skill for pre-deploy validation in YouthField.

Before running build, deploy, or any write action, ask the user for confirmation.

Follow these steps:
1. Read [shared project rules](../_shared/project-rules.md) first.
2. Identify the deployment surface:
   - Flutter app
   - Firebase hosting or services
   - Vercel proxy server
3. Review changed areas and list likely blast radius before running checks.
4. After user confirmation, run only the smallest useful verification set first, such as analyze, targeted tests, or proxy sanity checks.
5. Report blockers in priority order, including architecture violations, provider-state risks, parsing risks, and deployment risks.
6. Do not deploy automatically after checks unless the user explicitly asks for deployment.

Suggested verification mindset:
- If UI changed, verify the related Riverpod providers.
- If proxy responses changed, verify service parsing and affected widgets.
- Prefer actionable release notes over raw command output.
