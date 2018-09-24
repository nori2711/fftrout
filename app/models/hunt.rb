class Hunt < ActiveRecord::Base
  belongs_to :user
  belongs_to :weather, foreign_key: 'weather_main', primary_key: 'weather_main'

  mount_uploader :fish_photo, PhotoUploader
  mount_uploader :fly_photo, PhotoUploader
  mount_uploader :spot_photo, PhotoUploader

  geocoded_by :latitude
end
