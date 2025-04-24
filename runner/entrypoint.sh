#!/bin/bash
./config.sh \
  --url https://github.com/portal2312/ci-and-cd-demo \
  --token "$RUNNER_TOKEN" \
  --name ci-and-cd-demo-runner \
  --labels ci-and-cd-demo-runner \
  --work _work \
  --unattended \
  --replace
./run.sh
