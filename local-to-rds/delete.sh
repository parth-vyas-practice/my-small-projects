#!/usr/bin/env bash
# here $1 is app name and $2 is s3 bucket name
aws cloudformation delete-stack --stack-name $1-RDS
aws cloudformation delete-stack --stack-name $1-EC2
aws s3 rm s3://$2/myapp.zip
rm myapp.zip mybackup DBurl.txt SUBNETID.txt VPCID.txt