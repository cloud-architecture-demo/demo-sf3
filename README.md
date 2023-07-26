# AWS EKS Cluster

This terraform plan creates an EKS cluster, VPC/Networking, IAM roles/policies.

> > Please note that this terraform plan is expecting the user to provide inputs using a **git ignored** `.tfvars` file. You could optionally provide the parameters individually instead, using the `-var` flag.
> > Typically, this is where any passwords, authentication information and other secrets can be stored safely, outside of version control. Additionally, this provides a vehicle to inject less sensitive user defined inputs like, region, name labels, domain name, etc..
> > The `.tfvars` file could be encrypted at rest if desired and decrypted with each use (Ansible vault, GNU Privacy Guard, VeraCrypt, BitLocker, etc...).
> 
> Here are the values that you should define for this terraform EKS plan:
> - cluster-name
> - region
> - vpn_cidr_block
> - endpoint_public_access
> - endpoint_private_access
> - ec2_ssh_key
>
> For example, your `.tfvars` file might look similar to this:
> ```
> ## EKS architecture demo secrets
> cluster-name = "Your-EKS-CLuster-Name"
> region = "Your-AWS-Region"
> 
> vpn_cidr_block = "X.X.X.X/32"
> endpoint_public_access = "true"          # If false, a transitgateway, jump box or reverse proxy will be needed to use kubectl outside of the VPC.
> endpoint_private_access = "true"
> ec2_ssh_key = "Your-EC2-Key-Pair"        # Optional, if you need access.
> ```

### Usage:
```
git clone https://github.com/cloud-architecture-demo/demo-sf3.git
cd demo-sf3

terraform init
terraform plan
terraform apply -var-file secrets.tfvars
```
