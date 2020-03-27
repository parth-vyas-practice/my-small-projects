Requirements to run this project
1. awscli must be installed and configured with "us-east-1" region
2. local machine user persmissions
    - cloudformation create, describe, delete 
    - s3 upload, download, delete
3. required ec2 instance role profile 
    - s3 upload, download, delete
4. s3 bucket in us-east-1 region
5. ec2 instance key-pair for ssh in us-east-1 region
6. here postgres 10 is used so in local use postgres 10
7. here userid pass is postgres 
8. to simulate DB use following commands for docker setup and docker must be installed on local machine
docker pull postgres:10 && docker run -d -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres --name postgres postgres:10
9. pg_restore -h localhost -U postgres -d postgres -O test-backup
10. to create use following command and provide s3 bucket name, instance role profile name, ec2 keypair name
bash execute.sh create
11. to delete just use following command
bash execute.sh delete
12. currently i have setup this project in this folder structure only.