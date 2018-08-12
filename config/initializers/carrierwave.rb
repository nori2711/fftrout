require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['SECRET_ACCESS_KEY'],
    region: 'ap-northeast-1'
  }

    case Rails.env
    when 'development'
        config.fog_directory  = 'update-test-nm'
        config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/update-test-nm'
    when 'production'
        config.fog_directory  = 'update-test-nm'
        config.asset_host = 'https://s3-ap-northeast-1.amazonaws.com/update-test-nm'
    end
end
