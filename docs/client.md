# Client

## Set up

### Yarn

```bash
nvm install 22.14.0  # node 버전 설치하기
npm install -g corepack  # yarn 활성화 하기
mkdir client && cd client
echo 22.14.0 > .nvmrc
nvm use  # node 버전 활성화 하기
yarn init -2  # 현재 경로에서 yarn 초기화 하기
rm -rf .git  # 최상위 .git 에서 관리하기 위해 제거하기
git add . && git commit -v -m 'Initial client'  # 현재까지 버전 관리하기
```

### Vite

```bash
yarn create vite  # Vite prompt 로 프로젝트 생성하기
# Project name: . (Ignore)
# Select a framework: React
# Select a variant: TypeScript + SWC
```

### TypeScript

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
