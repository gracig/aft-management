_assume:
    #!/usr/bin/env bash
    CREDS=$(aws sts assume-role \
      --role-arn arn:aws:iam::141971524659:role/cicdlab-aft-admin \
      --role-session-name aft-deploy \
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
      --output text)
    echo "export AWS_ACCESS_KEY_ID=$(echo $CREDS | awk '{print $1}')"
    echo "export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | awk '{print $2}')"
    echo "export AWS_SESSION_TOKEN=$(echo $CREDS | awk '{print $3}')"

# Initialize AFT Terraform
init:
    #!/usr/bin/env bash
    eval $(just _assume)
    terraform init

# Plan AFT deployment
plan:
    #!/usr/bin/env bash
    eval $(just _assume)
    terraform plan

# Apply AFT deployment
apply:
    #!/usr/bin/env bash
    eval $(just _assume)
    terraform apply
