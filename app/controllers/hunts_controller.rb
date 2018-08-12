require "json"
require "open-uri"
require 'net/http'
require 'uri'

class HuntsController < ApplicationController
  # OpenWeatherMapのAPI_KEYとcurrent weather URL
  API_KEY = ENV['WEATHERMAP_APIKEY']
  BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'

  def index
    # 釣果情報を地図上に表示
    @hunts = Hunt.where.not(latitude: nil) #位置情報ありのレコードを抽出
    @hunt_lat = @hunts.map{ |hun|
      hun.latitude
    } #マーカー用の緯度情報の配列作成
    @hunt_lng = @hunts.map{ |hun|
      hun.longitude
    } #マーカー用の経度情報の配列作成
    @apikey = ENV["GOOGLEMAP_APIKEY"]
  end

  def new
    @hunt = Hunt.new
    @apikey = ENV["GOOGLEMAP_APIKEY"]

    # OpenWeatherMapにrequestしてresponseを受け取る
    uri = URI.parse(BASE_URL + "?lat=35.74&lon=139.19&units=metric&appid=#{API_KEY}")
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
    weather = result['weather'][0]
    @weather_id = weather['id']
    @weather_main = weather['main']
    main = result['main']
    @temp = main['temp']
    @humidity = main['humidity']
    @pressure = main['pressure']
    wind = result['wind']
    @wind_speed = wind['speed']
    @wind_deg = wind['deg']
  end

  def create
    @hunt = Hunt.new(hunt_params, temp: @temp)
    if @hunt.save
      redirect_to "/", success: "釣果の登録が完了しました"
    else
      render "new"
    end
  end

  def show
    @hunt = Hunt.find(params[:id])
    @apikey = ENV["GOOGLEMAP_APIKEY"]
  end

  private
  def hunt_params
    params.require(:hunt).permit(:fish_photo, :fly_photo, :spot_photo, :latitude, :longitude, :weather_id, :weather_main, :temp, :pressure, :humidity, :wind_speed, :wind_deg, :memo).merge(user_id: current_user.id)
  end
end
