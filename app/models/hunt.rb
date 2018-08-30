class Hunt < ActiveRecord::Base
  belongs_to :user

  mount_uploader :fish_photo, PhotoUploader
  mount_uploader :fly_photo, PhotoUploader
  mount_uploader :spot_photo, PhotoUploader

  geocoded_by :latitude
end
