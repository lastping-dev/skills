#!/usr/bin/env bash
# Two crontab jobs and one scheduled GitHub Actions workflow.
set -euo pipefail
mkdir -p deploy .github/workflows
cat > deploy/crontab <<'CRON'
# m h dom mon dow command
0 3 * * * /usr/local/bin/backup.sh
*/15 * * * * /opt/app/sync.sh
CRON
cat > .github/workflows/nightly.yml <<'YML'
name: nightly
on:
  schedule:
    - cron: "30 2 * * *"
  workflow_dispatch:
jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/nightly-report.sh
YML
cat > README.md <<'MD'
# demo-app

A small service. The production host runs the jobs in deploy/crontab.
MD
