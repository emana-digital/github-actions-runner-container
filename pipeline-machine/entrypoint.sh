#!/bin/bash

if [[ "$@" == "bash" ]]; then
    exec $@
fi

if [[ -z $RUNNER_NAME ]]; then
    echo "Variável de ambiente RUNNER_NAME não setada, usando '${HOSTNAME}'."
    export RUNNER_NAME=${HOSTNAME}
fi

if [[ -z $RUNNER_WORK_DIRECTORY ]]; then
    echo "Variável de ambiente RUNNER_WORK_DIRECTORY não setada, usando '_work'."
    export RUNNER_WORK_DIRECTORY="_work"
fi

if [[ -z $GITHUB_ACCESS_TOKEN ]]; then
    echo "Erro: Você precisa setar a variável de ambiente GITHUB_ACCESS_TOKEN."
    exit 1
fi

if [[ -z $RUNNER_REPLACE_EXISTING ]]; then
    export RUNNER_REPLACE_EXISTING="true"
fi

CONFIG_OPTS=""
if [ "$(echo $RUNNER_REPLACE_EXISTING | tr '[:upper:]' '[:lower:]')" == "true" ]; then
    CONFIG_OPTS="--replace"
fi

if [[ -f ".runner" ]]; then
    echo "Runner already configured. Skipping config."
else

    echo "Exchanging the GitHub Access Token with a Runner Token..."

    IS_ORG_RUNNER=${IS_ORG_RUNNER:-false}

    URI=https://api.github.com
    API_VERSION=v3
    API_HEADER="Accept: application/vnd.github.${API_VERSION}+json"
    AUTH_HEADER="Authorization: token ${GITHUB_ACCESS_TOKEN}"

    RUNNER_REPOSITORY_URL=${RUNNER_REPOSITORY_URL:-${URI}}
    _PROTO="$(echo "${RUNNER_REPOSITORY_URL}" | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    _URL="$(echo "${RUNNER_REPOSITORY_URL/${_PROTO}/}")"
    _PATH="$(echo "${_URL}" | grep / | cut -d/ -f2-)"
    _ACCOUNT="$(echo "${_PATH}" | cut -d/ -f1)"
    _REPO="$(echo "${_PATH}" | cut -d/ -f2)"

    _FULL_URL="${URI}/repos/${_ACCOUNT}/${_REPO}/actions/runners/registration-token"

    if [[ ${IS_ORG_RUNNER} == "true" ]]; then
        [[ -z ${RUNNER_ORG_NAME} ]] && (
            echo "RUNNER_ORG_NAME required for org runners"
            exit 1
        )
        _FULL_URL="${URI}/orgs/${RUNNER_ORG_NAME}/actions/runners/registration-token"
        _SHORT_URL="${_PROTO}github.com/${RUNNER_ORG_NAME}"
    else
        _SHORT_URL=$RUNNER_REPOSITORY_URL
    fi

    RUNNER_TOKEN="$(curl -XPOST -fsSL \
        -H "${AUTH_HEADER}" \
        -H "${API_HEADER}" \
        "${_FULL_URL}" |
        jq -r '.token')"

    echo "Configuring"

    ./config.sh \
        --url $_SHORT_URL \
        --token $RUNNER_TOKEN \
        --name $RUNNER_NAME \
        --work $RUNNER_WORK_DIRECTORY \
        $CONFIG_OPTS \
        --unattended
fi

exec "$@"
