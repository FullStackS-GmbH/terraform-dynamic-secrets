variable "aws_access_key" {
  type        = string
  sensitive   = true
  description = "Amazon AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "Amazon AWS Secret Key"
}

variable "vault_address" {
  type        = string
  default     = "https://vault.fullstacks.eu:8200"
  description = "Address of your HashiCorp Vault Server - Can be set via ENV_VAR $VAULT_ADDR"
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "Your Vault Access Token - Can be set via ENV_VAR $VAULT_TOKEN"
}
