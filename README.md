# Edion Net Dev - Infrastructure as Code (Terraform)

This project uses Terraform to manage the infrastructure for the Edion Net Dev application lágrimas on AWS, encompassing "申込web" (Application Web) and "申込web管理" (Application Management Web).

## Project Structure

The project is organized into reusable **modules** and sequentially applied **layers** (root modules):

-   **`modules/`**: Contains reusable Terraform modules for creating specific AWS resources (e.g., S3 bucket, ECS service).
-   **`00-base/`**: Foundational layer, including basic network configuration (referencing existing VPC, Subnets) and common IAM roles/policies.
-   **`01-security/`**: Layer for managing security aspects, primarily Security Groups.
-   **`02-shared-services/`**: Layer for creating shared services like S3 buckets (for uploads, logs), DynamoDB (for sessions), and CloudWatch Log Groups.
-   **`03-app-platform/`**: Layer for setting up the application runtime platform, including ECS Clusters, Application Load Balancers (ALBs), and CodeCommit Repositories.
-   **`04-app-web/`**: Layer for deploying the "Application Web" (`申込web`), including its ECS Service, CodePipeline, CodeBuild, CodeDeploy.
-   **`05-app-mgt/`**: Layer for deploying the "Application Management Web" (`申込web管理`), similar to `04-app-web/` but for the management system, and EventBridge Schedules.

## Prerequisites

1.  Install [Terraform](https://www.terraform.io/downloads.html) (version >= 1.0).
2.  Configure AWS CLI with appropriate access credentials.
3.  Create an S3 bucket to store Terraform state and a DynamoDB table for state locking (update this information in the `backend.tf` files of each layer).

## How to Deploy Layers

Deploy the layers in the specified order. For each layer:

1.  Navigate to the layer's directory: `cd <layer-directory-name>` (e.g., `cd 00-base`)
2.  Initialize Terraform: `terraform init`
3.  (Optional) Create a `terraform.tfvars` file (or a name corresponding to your environment) with the necessary variable values.
4.  Review the deployment plan: `terraform plan -var-file=terraform.tfvars`
5.  Apply the changes: `terraform apply -var-file=terraform.tfvars`

**Order of Applying Layers:**

1.  `00-base`
2.  `01-security`
3.  `02-shared-services`
4.  `03-app-platform`
5.  `04-app-web`
6.  `05-app-mgt`

## State Management

Each layer will have its own state file stored in the S3 backend configured in its respective `backend.tf` file. This isolates the state between layers.

## Passing Data Between Layers

Data (outputs) from previously applied layers are passed to subsequent layers using `data "terraform_remote_state"`.

---

## Layer Details

### `00-base/` (Base Layer)

-   **Purpose:** Establishes fundamental network resources and foundational, infrequently changing IAM roles/policies.
-   **Key Resources:**
    -   References to the existing VPC (`dev-edion_isp`) and Subnets (`private-subnet`) (using data sources).
    -   (Example) Basic IAM Roles for services to read from S3 or write logs (requires more detailed definition).
-   **Outputs:**
    -   `vpc_id`: ID of the VPC.
    -   `private_subnet_ids`: List of IDs for the private subnets.
    -   (Example) `ecs_task_execution_role_arn`: ARN of the IAM role for ECS Task Execution.

### `01-security/` (Security Layer)

-   **Purpose:** Manages security-related resources, primarily Security Groups.
-   **Key Resources:**
    -   Security Group for Fargate Tasks (`edion-net-app-ecs-dev-sg`).
    -   Security Group for the "Application Web" ALB (`edion-net-app-registration-dev-alb-sg`). *(Corrected name)*
    -   Security Group for the "Application Management Web" ALB (`edion-net-app-manage-dev-alb-sg`). *(Corrected name)*
-   **Inputs:**
    -   `vpc_id` (from the output of the `00-base` layer).
-   **Outputs:**
    -   `fargate_task_sg_id`: ID of the Security Group for Fargate tasks.
    -   `app_web_alb_sg_id`: ID of the Security Group for the Application Web ALB.
    -   `app_mgt_alb_sg_id`: ID of the Security Group for the Application Management Web ALB.

### `02-shared-services/` (Shared Services Layer)

-   **Purpose:** Creates storage and logging services utilized by multiple applications or components.
-   **Key Resources:**
    -   S3 Buckets:
        -   `edion-net-dev-important-info` (for important files).
        -   `edion-net-dev-img-upload` (for images).
    -   DynamoDB Table:
        -   `edion-net-app-sessions-dev-table` (for session management).
    -   CloudWatch Log Groups:
        -   For CodePipelines (`/edion-net-dev/codepipeline/app-codepipeline`, `/edion-net-dev/codepipeline/app-mgt-codepipeline`).
        -   For Applications (`/edion-net-dev/app/container-app-logs`, `/edion-net-dev/app-mgt/container-app-logs`).
-   **Outputs:**
    -   `important_info_bucket_name`, `important_info_bucket_arn`.
    -   `img_upload_bucket_name`, `img_upload_bucket_arn`.
    -   `sessions_dynamodb_table_name`, `sessions_dynamodb_table_arn`.
    -   ARNs/Names of the CloudWatch Log Groups.

### `03-app-platform/` (Application Platform Layer)

-   **Purpose:** Sets up the platform components required to run and manage the applications.
-   **Key Resources:**
    -   ECS Clusters (Fargate):
        -   `edion-net-dev-app-cluster01`
        -   `edion-net-dev-app-mgt-cluster01`
    -   Application Load Balancers (ALBs):
        -   `edion-net-app-registration-dev-alb` (for "Application Web")
        -   `edion-net-app-manage-dev-alb` (for "Application Management Web")
    -   CodeCommit Repositories:
        -   `edion-net-dev-app-repository`
        -   `edion-net-dev-app-mgt-repository`
-   **Inputs:**
    -   `vpc_id`, `private_subnet_ids` (from `00-base`).
    -   `app_web_alb_sg_id`, `app_mgt_alb_sg_id` (from `01-security`).
    -   (Example) `ecs_task_execution_role_arn` (from `00-base`).
-   **Outputs:**
    -   `app_ecs_cluster_arn`, `app_ecs_cluster_name`.
    -   `mgt_ecs_cluster_arn`, `mgt_ecs_cluster_name`.
    -   `app_web_alb_arn`, `app_web_alb_dns_name`, `app_web_alb_http_listener_arn`.
    -   `app_mgt_alb_arn`, `app_mgt_alb_dns_name`, `app_mgt_alb_http_listener_arn`.
    -   `app_repository_clone_url_http`, `app_repository_name`.
    -   `mgt_repository_clone_url_http`, `mgt_repository_name`.

### `04-app-web/` ("Application Web" Layer)

-   **Purpose:** Deploys the entire "Application Web", including its ECS service and CI/CD pipeline.
-   **Key Resources:**
    -   ECS Service (`edion-net-app-registration-dev-service`) and Task Definition (`registration-dev-taskdef`).
    -   CodeBuild Project (`edion-net-dev-app-project01`).
    -   CodeDeploy Application (`edion-net-dev-app01`) and Deployment Group (`edion-net-dev-app-deploy_group01`).
    -   CodePipeline (`edion-net-dev-app-codepipeline`).
    -   EventBridge Schedules (`edion-net-app-dev-stop-schedule`, `edion-net-app-dev-start-schedule`) to stop/start the ECS service.
-   **Inputs:**
    -   ARNs/Names of ECS Cluster, ALB Listener, CodeCommit Repo (from `03-app-platform`).
    -   ARNs/Names of CloudWatch Log Group (from `02-shared-services`).
    -   `vpc_id`, `private_subnet_ids` (from `00-base`).
    -   `fargate_task_sg_id` (from `01-security`).
    -   Application configuration (image, port, env variables - via `.tfvars` file).
-   **Outputs:** (If needed for other systems)

### `05-app-mgt/` ("Application Management Web" Layer)

-   **Purpose:** Deploys the entire "Application Management Web", similar to `04-app-web/`.
-   **Key Resources:**
    -   ECS Service (`edion-net-app-manage-dev-service`) and Task Definition (`manage-dev-taskdef`).
    -   CodeBuild Project (`edion-net-dev-app-mgt-project01`).
    -   CodeDeploy Application (`edion-net-dev-app-mgt01`) and Deployment Group (`edion-net-dev-app-mgt-deploy_group01`).
    -   CodePipeline (`edion-net-dev-app-mgt-codepipeline`).
    -   EventBridge Schedules (`edion-net-app-dev-stop-manage-schedule`, `edion-net-app-dev-start-manage-schedule`).
-   **Inputs:** Similar to `04-app-web/` but with corresponding "mgt" resources.
-   **Outputs:** (If needed)