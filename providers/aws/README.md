
## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| vpc_subnet | Set the CIDR of the VPC subnet | `"10.0.0.0/16"` | no |
| private_subnets | Private subnets for non public NAT routed resources | `"10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"` | no |
| public_subnets | Public subnets for public routed resources | `"10.0.4.0/24,10.0.5.0/24,10.0.6.0/24"` | no |
| project_name |  | `"willejsio"` | no |
| availability_zones | Availability zones to place the private/public subnets in | `"eu-west-1a,eu-west-1b,eu-west-1c"` | no |

