#!/usr/bin/env bash

ACCESS_KEY_ID="$(sed -n 's/^aws_access_key_id = \(.*\)$/\1/p' ~/.aws-credentials)"
SECRET_ACCESS_KEY="$(sed -n 's/^aws_secret_access_key = \(.*\)$/\1/p' ~/.aws-credentials)"
SESSION_TOKEN="$(sed -n 's/^aws_session_token = \(.*\)$/\1/p' ~/.aws-credentials)"

newman run $1 --env-var "AWS_ACCESS_KEY_ID=$ACCESS_KEY_ID" --env-var "AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY" --env-var "AWS_SESSION_TOKEN=$SESSION_TOKEN"
