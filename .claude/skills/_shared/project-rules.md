# YouthField Project Rules

- Preserve clean architecture boundaries. Keep presentation, domain, and data concerns separated.
- Use Riverpod for state management. If UI behavior changes, inspect the related provider state, invalidation, and data flow.
- Ask the user for confirmation before making file edits, server-side changes, or deployment-related actions.
- Prefer tracing the full flow before editing: external source or proxy -> service -> repository -> provider -> UI.
- Keep changes scoped and minimal. Do not refactor unrelated areas unless the user asks for it.
- If a change affects data shape, verify both parsing code and the widgets that render the result.
