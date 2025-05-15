# Deploy

## Set Up SSH authorized keys for jenkins

Set up:

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
echo 'GENERATED_PUBLIC_SSH_KEY' >> ~/.ssh/authorized_keys
```

- `'GENERATED_PUBLIC_SSH_KEY'`: Show, [generated public SSH key by `jenkins-deploy`](./jenkins.md#)

Check:

```bash
cat ~/.ssh/authorized_keys
ls -al ~/.ssh
```

### Test SSH connect

1. Go to **jenkins** container

2. Try ssh connect to `deploy` container:

   ```bash
   ssh -i ~/.ssh/jenkins_deploy appuser@deploy
   ```
