#!/usr/bin/env bash
# get default vpc id
# here $1 is app name and $2 is s3 bucket name $3 is keypair name $4 is instance profile
# RDS section
aws cloudformation create-stack --stack-name $1-RDS --template-body file://RDS.yml --parameters ParameterKey=AppName,ParameterValue=$1 \
#ParameterKey=VPC,ParameterValue=$VPCID

if [[ $? -eq 0 ]]; then
    # Wait for create-stack to finish
    echo  "Waiting for create-rds-stack command to complete"
    CREATE_STACK_STATUS=$(aws cloudformation describe-stacks --stack-name $1-RDS --query 'Stacks[0].StackStatus' --output text)
    while [[ $CREATE_STACK_STATUS == "REVIEW_IN_PROGRESS" ]] || [[ $CREATE_STACK_STATUS == "CREATE_IN_PROGRESS" ]]
    do
        # Wait 30 seconds and then check stack status again
        sleep 30
        CREATE_STACK_STATUS=$(aws cloudformation describe-stacks --stack-name $1-RDS --query 'Stacks[0].StackStatus' --output text)
    done

    VPCID=$(aws cloudformation describe-stacks --stack-name $1-RDS --query 'Stacks[0].Outputs[0].[OutputValue]' --output text)
    SUBNETID=$(aws cloudformation describe-stacks --stack-name $1-RDS --query 'Stacks[0].Outputs[1].[OutputValue]' --output text)
    DBURL=$(aws cloudformation describe-stacks --stack-name $1-RDS --query 'Stacks[0].Outputs[2].[OutputValue]' --output text)
    echo "$VPCID" > VPCID.txt
    echo "$SUBNETID" > SUBNETID.txt
    echo "$DBURL" > DBurl.txt
    
fi

#take dump of database and restore database
export PGPASSWORD="postgres"
# take dump from local database
echo "taking dump of local database"
pg_dump -h localhost -U postgres -Fc postgres > mybackup && \
# restore on RDS
echo "restoring dump on rds"
pg_restore -h $DBURL -U postgres -d postgres -O mybackup && echo "Success"

# upload code to s3 
echo "uploading code zip file to s3"
zip -r myapp.zip myapp/
aws s3 cp myapp.zip s3://$2

# ec2 section
echo "creating ec2 instance"
aws cloudformation create-stack --stack-name $1-EC2 --template-body file://EC2.yml --parameters ParameterKey=AppName,ParameterValue=$1 ParameterKey=VPC,ParameterValue=$VPCID ParameterKey=S3BucketName,ParameterValue=$2 ParameterKey=KeyPairName,ParameterValue=$3 ParameterKey=InstanceRole,ParameterValue=$4 ParameterKey=DBURL,ParameterValue=$DBURL ParameterKey=SubnetID,ParameterValue=$SUBNETID

if [[ $? -eq 0 ]]; then
    # Wait for create-stack to finish
    echo  "Waiting for create-ec2-stack command to complete"
    CREATE_STACK_STATUS=$(aws cloudformation describe-stacks --stack-name $1-EC2 --query 'Stacks[0].StackStatus' --output text)
    while [[ $CREATE_STACK_STATUS == "REVIEW_IN_PROGRESS" ]] || [[ $CREATE_STACK_STATUS == "CREATE_IN_PROGRESS" ]]
    do
        # Wait 30 seconds and then check stack status again
        sleep 30
        CREATE_STACK_STATUS=$(aws cloudformation describe-stacks --stack-name $1-EC2 --query 'Stacks[0].StackStatus' --output text)
    done

    InstanceIP=$(aws cloudformation describe-stacks --stack-name $1-EC2 --query 'Stacks[0].Outputs[0].[OutputValue]' --output text)
    sleep 60
    echo ""
    echo ""
    echo "instance ip = ${InstanceIP}"
fi