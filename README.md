# Runner Container

Imagem para executar runners do Github Actions em contêineres

## Uso:

Coloque seu token do github em um arquivo `.env` no mesmo local do `docker-compose.yml`, configure como no exemplo abaixo e inicie usando o `docker-compose up -d`

```yml
version: "3.7"

services:
  project-one:
    image: ghcr.io/emana-digital/github-actions-runner
    environment:
      RUNNER_NAME: "project-one-runner"
      RUNNER_REPOSITORY_URL: "https://github.com/user/project"
      GITHUB_ACCESS_TOKEN: ${GITHUB_ACCESS_TOKEN}
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./_github_runner_work:/home/runner/_work

  organization-one:
    image: ghcr.io/emana-digital/github-actions-runner
    environment:
      IS_ORG_RUNNER: "true"
      RUNNER_NAME: "organization-one-runner"
      RUNNER_ORG_NAME: "organization-one"
      RUNNER_LABELS: "LABEL"
      RUNNER_REPLACE_EXISTING: "true"
      GITHUB_ACCESS_TOKEN: ${GITHUB_ACCESS_TOKEN}
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./_github_runner_work:/home/runner/_work
```
