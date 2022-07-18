# Xosphere Instance Orchestration Aws Org Mgmt
variable "xosphere_mgmt_account_ids" {
  description = "List of all AWS Account IDs of the Xosphere management accounts"
  type = list(string)
}
