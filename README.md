
# Edion Net IaC Terraform Project

This repository manages infrastructure using Terraform, following a layered approach and using Terraform Cloud with OIDC authentication.

## 🔧 Structure Overview

```
edion-net-iac/
├── modules/
│   ├── alb/
│   ├── cloudwatch-log-group/
│   ├── codebuild-project/
│   ├── codedeploy-app-ecs/
│   ├── dynamodb-table/
│   ├── ecs-cluster/
│   ├── ecs-service/
│   ├── eventbridge-schedule/
│   ├── s3-bucket/
│   ├── security-group/
│   └── aws-vpc/
│
├── 00-base/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
│
├── 01-security/
├── 02-shared-services/
├── 03-app-platform/
├── 04-app-web/
├── 05-app-mgt/
│   └── (each has main.tf, variables.tf, outputs.tf, backend.tf)
│
├── terraformcloud/
│   └── oidc_terraformcloud.tf
│
├── README.md
└── .gitignore
```

## 🔐 OIDC Authentication

The file `terraformcloud/oidc_terraformcloud.tf` configures an IAM Role and OIDC provider to enable Terraform Cloud to authenticate to AWS securely using Workload Identity Federation.

## 🚀 Terraform Cloud Setup

### Recommended Terraform Cloud Variables (Workspace Variables)

| Name                         | Type     | Value                                 | Sensitive |
|------------------------------|----------|---------------------------------------|-----------|
| `AWS_REGION`                 | String   | `ap-northeast-1`                      | No        |
| `TF_VAR_project_name`        | String   | `edion`                               | No        |
| `TF_VAR_service_name`        | String   | `net`                                 | No        |
| `TF_VAR_resource_prefix`     | String   | `edion-net`                           | No        |
| `TF_VAR_environment`         | String   | `dev`, `stg`, `prd`                   | No        |

## ℹ️ Notes

- Each layer can be independently applied via Terraform Cloud workspaces.
- No AWS access keys are stored; OIDC via Terraform Cloud is used.
- This setup is environment-isolated (dev/stg/prd separated in codebase).
