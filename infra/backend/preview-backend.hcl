# Preview environment backend config (template)
# When creating preview environments, replace {PR_NUMBER} with the actual PR number
# Example: For PR #123, this becomes "preview-pr-123/terraform.tfstate"

bucket         = "cloud-portfolio-terraform-state"
key            = "preview-pr-{PR_NUMBER}/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "cloud-portfolio-terraform-locks"
encrypt        = true
