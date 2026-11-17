# Partial configuration: real values are supplied at init time
# (locally via backend.hcl, in the pipeline via -backend-config flags).
terraform {
  backend "s3" {}
}
