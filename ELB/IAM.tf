#################
### IAM作成
#################
### ポリシー作成
data "aws_iam_policy_document" "udemy_sample_allow_s3" {
  statement {
    # 許可or拒否
    effect = "Allow"
    # アクション
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    # 対象リソース
    resources = [
      "arn:aws:s3:::udemy-vpc-2021083/*"
    ]
  }
}
resource "aws_iam_policy" "udemy_sample_policy" {
  # ポリシー名
  name = "udemy-sample-policy"
  # アタッチするポリシー
  policy = data.aws_iam_policy_document.udemy_sample_allow_s3.json
}

### ロール作成
# 信頼ポリシー作成
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    # sts(Security Token Serivce)で、ロールを引き受ける操作を許可
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
# ロール作成
resource "aws_iam_role" "udemy_sample_ec2_to_s3" {
  name               = "udemy-sample-ec2-to-s3"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

### ロールにポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "udemy_sample_ec2" {
  role       = aws_iam_role.udemy_sample_ec2_to_s3.name
  policy_arn = aws_iam_policy.udemy_sample_policy.arn
}

#################
### IAMインスタンスprofile作成
#################
resource "aws_iam_instance_profile" "udemy_sample_ec2_profile" {
  name = "udemy-sample-ec2-profile"
  # 使用するロール名
  role = aws_iam_role.udemy_sample_ec2_to_s3.name
}