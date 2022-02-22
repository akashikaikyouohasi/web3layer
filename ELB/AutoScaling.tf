
# AutoScaling：起動設定
resource "aws_launch_configuration" "auto_scaling_instance" {
    # 名前
    name = "sample-auto-scaling-instance" 
    # Amazonマシンイメージ
    image_id = var.ami
    # インスタンスタイプ
    instance_type = "t2.micro"
    # 追加設定
    
    # ストレージ（ボリューム）
    
    # セキュリティグループ
    security_groups = [var.security_group_web]
    
    # キーペア
    key_name = "udemy-sample2"
}

# AutoScaling: AutoScalingグループ設定
resource "aws_autoscaling_group" "auto_scaling_gp" {
    # 名前
    name = "sample-auto-scaling-gp"
    # 起動テンプレート
    launch_configuration = aws_launch_configuration.auto_scaling_instance.name
    # VPC AZとSubnet
    vpc_zone_identifier = [var.public_subnet_ids.ap-northeast-1a, var.public_subnet_ids.ap-northeast-1c]
    
    # ロードバランサーのターゲットグループ
    target_group_arns = [aws_lb_target_group.sample_elb_target.arn]
    # Health check type: ELBのヘルスチェックを利用
    health_check_type = "ELB"
    # ヘルスチェックの猶予期間
    health_check_grace_period = 300
    
    # グループサイズ
    desired_capacity = 2
    min_size = 2
    max_size = 4
    
    # 終了ポリシー
    termination_policies = ["NewestInstance"]
    
    
}

resource "aws_autoscaling_policy" "scaling_policy" {
    # スケーリングポリシー
    autoscaling_group_name = aws_autoscaling_group.auto_scaling_gp.name
    
    # type
    policy_type = "TargetTrackingScaling"
    # スケーリングポリシー名
    name = "sample-scaling-policy"
    
    target_tracking_configuration {
        predefined_metric_specification {
            # メトリクスタイプ
            predefined_metric_type = "ASGAverageCPUUtilization"
      }
      # ターゲット値
      target_value = 40.0
      
      # スケールインを無効にする
      disable_scale_in = true
    }
    
    # メトリクスに含める前にウォームアップする秒数
    estimated_instance_warmup = 300
    
}

resource "aws_autoscaling_group_tag" "name_tag" {
    autoscaling_group_name = aws_autoscaling_group.auto_scaling_gp.name
    
    tag {
        key = "Name"
        value = "test"
        propagate_at_launch = true
    }
}