#!/usr/bin/env bash
if [ $1 == "create" ]; then
    APPNAME="my-test-app"
    echo "S3 bucket ec2 keypair should be in us-east-1 region otherwise script will fail"
    read -p 'Please Enter Valid s3 bucket name: ' S3BUCKETNAME
    read -p 'Please Enter Valid ec2 key pair name: ' EC2KeyPairName
    read -p 'Please Enter Valid ec2 instance role profile name only: ' InstanceRole

    echo "${S3BUCKETNAME}" > Deploy-Params.txt
    echo "${EC2KeyPairName}" >> Deploy-Params.txt
    echo "${InstanceRole}" >> Deploy-Params.txt
    echo "$APPNAME" >> Deploy-Params.txt
    declare -a KEY
    declare -a VALUE
    KEY=(${S3BUCKETNAME} ${EC2KeyPairName} ${InstanceRole})
    VALUE=(S3BUCKETNAME EC2KeyPairName InstanceRole)
    i=0
    while [ $i -lt ${#VALUE[*]} ]; do
        if [ -z ${KEY[$i]} ]; then
            echo "${VALUE[$i]} is empty please provide valid value"
            DEPLOY="false"
        else
            DEPLOY="true"
        fi
        i=$(($i + 1))
    done
    if [ $DEPLOY == "true" ]; then
        bash create.sh $APPNAME $S3BUCKETNAME $EC2KeyPairName $InstanceRole
    else
        echo "dont deploy"
    fi
elif [ $1 == "delete" ]; then
    bash delete.sh $(sed -n 4p Deploy-Params.txt) $(sed -n 1p Deploy-Params.txt)
fi