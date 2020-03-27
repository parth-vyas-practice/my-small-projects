#!/bin/bash
if [ $1 == "create" ]; then
    terraform init && terraform apply -auto-approve
elif [ $1 == "delete" ]; then
    terraform destroy -auto-approve
fi