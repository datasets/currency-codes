# Update Script Maintenance Report

Date: 2026-03-03

- Ran `scripts/runall.sh` successfully to validate current update pipeline.
- Hardened XML downloads in `scripts/runall.sh` with `curl --fail --silent --show-error --location`.
- Added `permissions: contents: write` in `.github/workflows/actions.yml` for scheduled push reliability.
