# infra-epicbook

Terraform infrastructure for the EpicBook application on **AWS**, provisioned through an **Azure DevOps** pipeline.

- Three tiers: public frontend (Nginx), backend (Node.js/EpicBook), private Amazon RDS for MySQL
- Remote state: S3 bucket with DynamoDB locking
- Pipeline: Validate → Plan → Manual approval → Apply → Outputs
- Secrets are never stored in this repository
