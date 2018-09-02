class Hunt < ActiveRecord::Base
  belongs_to :user

  mount_uploader :fish_photo, PhotoUploader
  mount_uploader :fly_photo, PhotoUploader
  mount_uploader :spot_photo, PhotoUploader

  geocoded_by :latitude

  # attr_accessor :river_point

  # def river_point=(number)
  #   @river_point = river_point
  # end

  # def river_point
  #   return @river_point
  # end
end
