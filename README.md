# web3layer

## 構造
VPCを作成し、subnetを4つ作成する。
各AZ毎にPrivateとPublicを1つずつ、合計4つのSubnetを作成する。
セキュリティグループ・ルートも作成。

ELBを作成し、AutoScalingグループを設定する
EC2を負荷に応じて調整できるようにする。

その後、プライベートサブネットにRDSを構築する。

## 流れ
VPCなど、固定的なものとEC2などの作ったり消したりするものは別のtfstateで管理する。

