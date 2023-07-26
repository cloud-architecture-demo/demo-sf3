# Demo SF-3

This repo contains reference architecture expressed with infrastructure/configuration as code to observe BizDevOps workflows, in a cloud native environment.

The architecture in this demo utilizes [Amazon Web Services](https://aws.amazon.com/), [Elastic Kubernetes Service](https://aws.amazon.com/eks/) as the **Core Infrastructure Layer**.


For the **Infrastructure Application Layer**, we will be utilizing [ArgoCD](https://argo-cd.readthedocs.io/), which requires the ArgoCD Kubernetes Operator to be installed in the cluster. 
Additionally, the [Jenkins Kubernetes Operator](https://github.com/jenkinsci/kubernetes-operator) and the [Configuration as Code plugin](https://github.com/jenkinsci/configuration-as-code-plugin) are used to automate the configuration of each CI/CD Pipeline.

Finally, in the **Business Application Layer**, we are using the [sock-shop demo, from Weaveworks](https://microservices-demo.github.io/).

<br>

<br>

---

##### Dependencies:

For this guide you will need to install the following dependencies:

1. git: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
2. Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started
3. aws cli: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
4. kubectl: https://kubernetes.io/docs/tasks/tools/
5. If you are using Windows, it is suggested to install git for windows instead: https://gitforwindows.org/

> Don't forget to make sure that the path to your git, terraform, aws and kubectl binaries are in the $PATH. i.e. `export PATH=$PATH:/path/to/binaries/`
   
<br>

##### Deploy:
Step 1: Clone the demo code:
```
git clone git@github.com:cloud-architecture-demo/demo-sf3.git
```

<br>

Step 2: Change directories into the code directory.
```
cd ./demo-sf3
```

<br>

Step 3: You will need to copy the file `secrets.tfvars.example` and name it `secrets.tfvars`. Be sure to replace the default values with those relevant to you.

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

<br>

Step 4: Deploy demo-sf3 to Amazon Web Services

Run the following commands in the order listed, one at a time.
```
terraform init
terraform plan -var-file secrets.tfvars
terraform apply -var-file secrets.tfvars
```
> Enter "yes" when prompted.

<br>

Step 5: Export the path to the newly generated EKS control Plane credentials for this cluster, `kubeconfig-tf`.
```
export KUBECONFIG=$(pwd)/kubeconfig-tf
```
> NOTE: 
>
> This simply defines the KUBECONFIG environment variable in your local shell.
> Doing this will not overwrite any kubeconfig files that you may have already established at `~/.kube/config`

<br>

Step 6: Use kubectl to display the IP address of the Jenkins server's LoadBalancer.
```
kubectl get svc jenkins-operator-http-prod-jenkins
```
> Once the address is displayed, you can copy it into a browser window and observe the Jenkins UI on port `8080`.
>
> Try building the microservices!
> 
>> Note:
>>
>> Use kubectl to display the `jenkins-operator` user's password to log into the Jenkins CI/CD server.
>> ```
>> kubectl get secret jenkins-operator-credentials-prod-jenkins -o 'jsonpath={.data.password}' | base64 -d
>> ```

<br>

Step 7: Use kubectl to display the IP address of the ArgoCD server's LoadBalancer.
```
kubectl -n argocd get svc argocd-server
```
>
> Once the address is displayed, you can copy it into a browser window and observe the ArgoCD UI on port `8080`.
>
> Try syncing the microservices in ArgoCD and wait for the app to be deployed.
> 
>> Note:
>>
>> Use kubectl to display the `admin` user's password to log into the ArgoCD server.
>> ```
>> kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
>> ```

<br>

Step 8: Use kubectl to display the IP address of the Sock Shop's front-end LoadBalancer.
```
kubectl -n sock-shop get svc front-end
```
> Once the address is displayed, you can copy it into a browser window and observe the ArgoCD UI on port `80`.
>
