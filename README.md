# terraform-gcp-demostack
    This Project configures Nomad, Vault and Consul on a variable amount of servers and workers. it already set up some nomad jobs, vault configurations and Consul queries. this is meant as a reference (and a demo environment) and really shouldnt be used for production. 
## Solution Diagram
![Solution Diagram](./assets/Demostack_overview.png)

## Variables for TF deployment
You need to provide a number of variables in your Terraform TFE environment.
Please check the terraform.tfvars.example file for the list

## Dependencies
 <TODO>

 ### TLS

 <TODO>

 ## Consul

 <TODO>

 ## Vault

 <TODO>

 ## Nomad
 
 <TODO>

## troubleshooting
To begin debugging, check the cloud-init output on each of the hosts:

```shell
$ sudo tail -f /var/log/syslog
```