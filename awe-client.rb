require 'fog'

storage = Fog::Storage.new(
  :provider => 'AWS', 
  :aws_access_key_id => '', 
  :aws_secret_access_key => '',
  :region => 'cn-north-1',
  :endpoint => 'https://s3.cn-north-1.amazonaws.com.cn'
)

# p storage.directories.length


compute = Fog::Compute.new(
  :provider => 'AWS', 
  :aws_access_key_id => '', 
  :aws_secret_access_key => '',
  :region => 'cn-north-1',
  :endpoint => 'https://ec2.cn-north-1.amazonaws.com.cn'
)

p compute.create_volume "cn-north-1a", 10, 'VolumeType' => "gp2" 

# p compute.servers.length

cloudwatch = Fog::AWS::CloudWatch.new(
  :aws_access_key_id => '', 
  :aws_secret_access_key => '',
  :host => 'https://monitoring.cn-north-1.amazonaws.com.cn',
  :region => 'cn-north-1'
)

# p cloudwatch.list_metrics

