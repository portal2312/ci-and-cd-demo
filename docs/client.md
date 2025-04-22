# Client

- [Client](#client)
  - [Develop Environments](#develop-environments)
    - [Set up Yarn](#set-up-yarn)
    - [Set up Vite](#set-up-vite)
    - [Set up support TypeScript by VSCode](#set-up-support-typescript-by-vscode)
    - [Install initial packages](#install-initial-packages)
  - [Docker](#docker)
    - [Installing in Docker for CICD-Jobs](#installing-in-docker-for-cicd-jobs)

## Develop Environments

### Set up Yarn

```bash
nvm install 22.14.0  # node 버전 설치하기
npm install -g npm corepack  # Upgrade npm and install corepack
npm list -g  # 확인하기
mkdir client && cd client
echo 22.14.0 > .nvmrc
nvm use  # node 를 .nvmrc 버전으로 활성화 하기
yarn set version stable  # yarn 안정적인 버전으로 설정하기
yarn --version  # yarn version 확인하기
yarn init -2  # 현재 경로에서 yarn 초기화 하기
rm -rf .git  # 최상위 .git 에서 관리하기 위해 제거하기
git add . && git commit -v -m 'Initial client'  # 현재까지 버전 관리하기
```

### Set up Vite

```bash
yarn create vite  # Vite prompt 로 프로젝트 생성하기
# Project name: . (Ignore)
# Select a framework: React
# Select a variant: TypeScript + SWC
```

### Set up support TypeScript by VSCode

```bash
yarn dlx @yarnpkg/sdks vscode   # Support VSCode
```

`client/.vscode/settings.json` 내용을 `.vscode/settings.json` 으로 옴긴 후, 아래와 같이 편집하기:

```json
{
  // ... exists settings

  "search.exclude": {
    "**/.yarn": true,
    "**/.pnp.*": true
  },
  "eslint.nodePath": "client/.yarn/sdks", // Fix: Add client path
  "typescript.tsdk": "client/.yarn/sdks/typescript/lib", // Fix: Add client path
  "typescript.enablePromptUseWorkspaceTsdk": true
}
```

`client/.vscode/extensions.json` 을 `.vscode/extensions.json` 로 옴기기.

Refer to [this](https://yarnpkg.com/getting-started/editor-sdks#vscode).

### Install initial packages

`Initial client` 에서 변경된 내용 확인하기:

- `client/.gitignore`
- `client/package.json`
- `client/README.md`
- `client/yarn.lock`

Install packages by `yarn`:

```bash
yarn install
```

## Docker

### Installing in Docker for CICD-Jobs

Edit [`Dockerfile`](../client/Dockerfile), Refer to [this](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-in-docker-for-cicd-jobs).
