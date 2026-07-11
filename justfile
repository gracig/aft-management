# Deploy AFT pipeline into management account
deploy:
    #!/usr/bin/env bash
    CREDS=$(aws sts assume-role \
      --role-arn arn:aws:iam::141971524659:role/cicdlab-aft-admin \
      --role-session-name aft-deploy \
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
      --output text)
    export AWS_ACCESS_KEY_ID=$(echo $CREDS | awk '{print $1}')
    export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | awk '{print $2}')
    export AWS_SESSION_TOKEN=$(echo $CREDS | awk '{print $3}')
    terraform init && terraform apply
