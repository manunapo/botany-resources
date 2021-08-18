# botany-resources

1. Install terraform https://www.terraform.io/downloads.html

2. Add to ~/.aws/config a "personal" profile with your aws account data:

    > `[profile personal]`
    > `region=us-east-1`
    > `aws_access_key_id = `
    > `aws_secret_access_key = `

3. Subscribe to AWS ami "ami-9391e585".

4. clone this repo

5. cd botany-resources

6.  - terraform init
    - terraform plan
    - terraform apply

7. Once finished:
    - terraform destroy
