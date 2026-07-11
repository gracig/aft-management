AFT_PROFILE := "aft"

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
    terraform apply -auto-approve

# Show all account requests in DynamoDB
requests:
    aws dynamodb scan --table-name aft-request --profile {{AFT_PROFILE}} \
      | jq '.Items[] | {account: .id.S, status: .status.S}'

# Show Step Functions provisioning executions
executions:
    #!/usr/bin/env bash
    ARN=$(aws stepfunctions list-state-machines --profile {{AFT_PROFILE}} \
      --query 'stateMachines[?contains(name,`provisioning`)].stateMachineArn' \
      --output text)
    aws stepfunctions list-executions --state-machine-arn $ARN --profile {{AFT_PROFILE}} \
      | jq '.executions[] | {name: .name, status: .status, start: .startDate}'

# Show SQS queue depth
queue:
    #!/usr/bin/env bash
    URL=$(aws sqs get-queue-url --queue-name aft-account-request.fifo \
      --profile {{AFT_PROFILE}} --query 'QueueUrl' --output text)
    aws sqs get-queue-attributes --queue-url $URL \
      --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible \
      --profile {{AFT_PROFILE}}

# Show CodePipeline status for account request pipeline
pipeline-status:
    aws codepipeline get-pipeline-state --name ct-aft-account-request --profile {{AFT_PROFILE}} \
      | jq '.stageStates[] | {stage: .stageName, status: .latestExecution.status}'

# Show latest CodeBuild log errors for account request
logs:
    #!/usr/bin/env bash
    STREAM=$(aws logs describe-log-streams \
      --log-group-name /aws/codebuild/ct-aft-account-request \
      --order-by LastEventTime --descending \
      --query 'logStreams[0].logStreamName' --output text --profile {{AFT_PROFILE}})
    aws logs get-log-events \
      --log-group-name /aws/codebuild/ct-aft-account-request \
      --log-stream-name $STREAM --profile {{AFT_PROFILE}} \
      | jq '.events[].message' -r | grep -i "error\|failed\|exit"
