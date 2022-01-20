data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "default_merged" {
  count = var.policy_flavor == "default" ? 1 : 0
  source_policy_documents = [
    data.aws_iam_policy_document.default
  ]
}

data "aws_iam_policy_document" "eks_root_volume_encrytion_merged" {
  count = var.policy_flavor == "eks_root_volume_encrytion_merged" ? 1 : 0
  source_policy_documents = [
    data.aws_iam_policy_document.default,
    data.aws_iam_policy_document.eks_root_volume_encrytion
  ]
}

data "aws_iam_policy_document" "default" {

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "eks_root_volume_encrytion" {

  statement {
    sid    = "Allow service-linked role use of the CMK"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
      ]
    }

    actions = [
      "kms:CreateGrant"
    ]

    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }

  }
}
