# Deploy

## Set Up SSH authorized keys for jenkins

Set up:

```bash
echo 'GENERATED_PUBLIC_SSH_KEY' >> ~/.ssh/authorized_keys
```

- `'GENERATED_PUBLIC_SSH_KEY'`: Public key of [Generated SSH keys](./jenkins.md#generate-ssh-keys)

> [!IMPORTANT]
> non-root user SSH files and directories permissions:
>
> - `~/.ssh`: `drwx------`(700), `appuser:appuser`
> - `~/.ssh/authorized_keys`: `-rw-------`(600), `appuser:appuser`

### Test

Connect to deploy container:

```bash
ssh -i ~/.ssh/jenkins_deploy appuser@deploy
```

Execute to `/app/deploy_from_nexus.sh` on deploy container:

```bash
ssh -i ~/.ssh/jenkins_deploy -o StrictHostKeyChecking=no appuser@deploy 'bash -l -c "/app/deploy_from_nexus.sh"'
```
