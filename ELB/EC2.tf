resource "aws_instance" "sample_web_server_01" {
  # AMI
  ami = var.ami
  # インスタンスタイプ
  instance_type = "t2.micro"
  # 配置するサブネット
  subnet_id = var.public_subnet_ids.ap-northeast-1a
  # セキュリティグループ
  vpc_security_group_ids = [var.security_group_web]
  # 自動割り当てパブリックIP
  associate_public_ip_address = true
  # キーペア: キーペアの「名前」を指定すれば、既存キーペアを利用可能？
  key_name = "udemy-sample2"
  # IAMロール(S3のポリシー内包)
  iam_instance_profile = "udemy-sample-ec2-profile"

  # ユーザーデータ
  user_data = file("bashsetting2-1a.txt")

  # EBS設定
  root_block_device {
    # サイズ(GiB)
    volume_size = 8
    # ボリュームタイプ
    volume_type = "gp2"
    # 終了時に削除
    delete_on_termination = true
    # 暗号化
    encrypted = false

    tags = {
      # EBS名
      Name = "sample-ec2-1a"
    }
  }

  tags = {
    # インスタンス名
    Name = "sample-web-server-1a"
  }
}

resource "aws_instance" "sample_web_server_02" {
  # AMI
  ami = var.ami
  # インスタンスタイプ
  instance_type = "t2.micro"
  # 配置するサブネット
  subnet_id = var.public_subnet_ids.ap-northeast-1c
  # セキュリティグループ
  vpc_security_group_ids = [var.security_group_web]
  # 自動割り当てパブリックIP
  associate_public_ip_address = true
  # キーペア: キーペアの「名前」を指定すれば、既存キーペアを利用可能？
  key_name = "udemy-sample2"
  # IAMロール(S3のポリシー内包)
  iam_instance_profile = "udemy-sample-ec2-profile"

  # ユーザーデータ
  user_data = file("user_data/bashsetting-1c.txt")

  # EBS設定
  root_block_device {
    # サイズ(GiB)
    volume_size = 8
    # ボリュームタイプ
    volume_type = "gp2"
    # 終了時に削除
    delete_on_termination = true
    # 暗号化
    encrypted = false

    tags = {
      # EBS名
      Name = "sample-ec2-1c"
    }
  }

  tags = {
    # インスタンス名
    Name = "sample-web-server-1c"
  }
}