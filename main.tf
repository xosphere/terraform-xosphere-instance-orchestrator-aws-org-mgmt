locals {
  lambda_function__xosphere_organization_ri_data_gatherer = "xosphere-org-ri-data-gatherer"

  xosphere_mgmt_account_arns = formatlist("\"arn:aws:iam::%s:root\"", var.xosphere_mgmt_account_ids)
  //  "\"arn:aws:iam::" + join(":root\", \"arn:aws:iam::", var.xosphere_mgmt_account_ids) + ":root\"" } ]
}

resource "aws_iam_role" "xosphere_organization_ri_data_gatherer_lambda_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Sid": "AllowAssumeFromXosphereManagementAccount",
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "AWS": [ ${join(",", local.xosphere_mgmt_account_arns)} ]
    }
  }
}
EOF
  managed_policy_arns = [ ]
  path = "/"
  name = "${local.lambda_function__xosphere_organization_ri_data_gatherer}-lambda-assume-role"
}

resource "aws_iam_role_policy" "xosphere_organization_ri_data_gatherer_lambda_role_policy" {
  name = "${local.lambda_function__xosphere_organization_ri_data_gatherer}-lambda-policy"
  role = aws_iam_role.xosphere_organization_ri_data_gatherer_lambda_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOrganizationOperations",
      "Effect": "Allow",
      "Action": [
        "organizations:DescribeOrganization"
	    ],
      "Resource": "*"
    },
    {
      "Sid": "AllowCostExplorerOperations",
      "Effect": "Allow",
      "Action": [
		    "ce:GetReservationUtilization"
	    ],
      "Resource": "*"
    }
  ]
}
EOF
}
