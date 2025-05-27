#!/bin/bash
# 스크립트 실행 중 하나의 명령이라도 실패(즉, 종료 코드가 0이 아님)하면 즉시 스크립트 전체 실행을 중단하도록 만듭니다.
set -ex

if [ -z "${RUNNER_URL}" ] || [ -z "${RUNNER_TOKEN}" ] || [ -z "${RUNNER_NAME}" ]|| [ -z "${RUNNER_LABELS}" ] ]; then
  echo
  echo "Error: Required environment variables are not set."
  echo "       Please set RUNNER_URL, RUNNER_TOKEN, RUNNER_NAME, and RUNNER_LABELS."
  exit 1
fi

if [ ! -f ".runner" ]; then
  echo
  echo "Configuring GitHub Actions Runner..."
  ./config.sh --url "${RUNNER_URL}" \
    --token "${RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels "${RUNNER_LABELS}" \
    --work "_work" \
    --unattended \
    --replace
fi

# Bash 에서 INT(인터럽트, 예: Ctrl+C) 또는 TERM(종료) 시그널이 들어올 때, 이 명령을 자동으로 실행하도록 설정합니다.
# 컨테이너나 스크립트가 중단될 때 GitHub Actions Runner 등록을 해제하고, 종료 코드 130으로 종료합니다.
# 이렇게 하면 Runner가 깔끔하게 정리되어, 불필요하게 남지 않게 됩니다.
trap './config.sh remove --unattended --token ${RUNNER_TOKEN}; exit 130' INT TERM

echo
echo "Starting GitHub Actions Runner..."
./run.sh
