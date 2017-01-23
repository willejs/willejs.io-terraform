# willejs.io-terraform

This repo creates all infrastructure for willejs.io.
It deploys docker containers to an ECS cluster.

## Acknowledgements

- Usually I wouldn't couple infrastructure and software deployment together, but in this case it's easy and works for now.
- I am following hashicorp best-practices, and also practices I have developed working on large terraform deployments.

## Components

- VPC
  -  Multi AZ public and private subnets
- NAT Gateway
  - public IPs
  - Route table association
- ECS
  - Cluster
  - Service
    - Task definition
- ALB
  - Route definitions
  - Listeners

## Layout

```
.
├── README.md
├── modules
└── providers
    └── aws
        ├── README.md
        ├── main.tf
        ├── terraform.tfstate
        └── variables.tf

```
### modules

This folder holds project specific modules that are used once or many times. To enable this, all resources in the module must be uniquely named, so that multiple instances can exist at the same time to enable blue-green deployments.

### providers

This folder holds the main code that includes terraform HCL files that defines the infrastructure at its highest level, all project specific details must be in variables.
