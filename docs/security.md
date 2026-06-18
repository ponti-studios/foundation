# Security

## Repository policy

- No checked-in env files.
- No mutable runtime image tags in the local stack.
- No workflow action tags; only commit SHAs.
- No secrets should live in the repo tree or history.

## Review checklist

- Use digest-pinned images for anything that can reach production or staging.
- Treat shell overrides as ephemeral, not as stored configuration.
- Prefer release automation over manual tag churn.
