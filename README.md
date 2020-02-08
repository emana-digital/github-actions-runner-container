# Runner Container - Github Actions

Image to run multiple runners on docker


```yml
version: "3.7"

services:
    website-one:
      image: emanadigital/github-actions-runner-container
      environment:
        RUNNER_NAME: "website-one-runner"
        RUNNER_REPOSITORY_URL: XXXX
        RUNNER_TOKEN: XXXX
    website-two:
      image: emanadigital/github-actions-runner-container
      environment:
        RUNNER_NAME: "website-two-runner"
        RUNNER_REPOSITORY_URL: XXXX
        RUNNER_TOKEN: XXXX
```