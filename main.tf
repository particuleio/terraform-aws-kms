resource "aws_kms_key" "this" {
  description         = var.description
  enable_key_rotation = var.enable_key_rotation
  policy              = var.policy != "" ? var.policy : var.policy_flavor == "default" ? data.aws_iam_policy_document.default_merged.json : var.policy_flavor == "eks_root_volume_encryption" ? data.aws_iam_policy_document.eks_root_volume_encryption_merged.json : data.aws_iam_policy_document.default_merged.json
  tags                = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this.key_id
}
