class Weather < ActiveRecord::Base
  has_many :hunts, foreign_key: 'weather_main', primary_key: 'weather_main'
end
