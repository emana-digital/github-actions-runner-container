# Runner Container - Github Actions

Imagem para executar runners do github actions em cointaineres

```yml
version: "3.7"

services:
  project-one:
    image: emanadigital/github-actions-runner-container
    environment:
      RUNNER_NAME: "project-one-runner"
      RUNNER_REPOSITORY_URL: XXXX
      GITHUB_ACCESS_TOKEN: XXXX
  organization-one:
    image: emanadigital/github-actions-runner-container
    environment:
      IS_ORG_RUNNER: true
      RUNNER_NAME: "organization-two-runner"
      RUNNER_ORG_NAME: organization
      GITHUB_ACCESS_TOKEN: XXXX
```
