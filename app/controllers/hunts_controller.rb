require "json"
require "open-uri"
require 'net/http'
require 'uri'

class HuntsController < ApplicationController
  # OpenWeatherMapのAPI_KEYとcurrent weather URL
  API_KEY = ENV['WEATHERMAP_APIKEY']
  BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'

  def index
    # ransackにて釣果を検索
    @search = Hunt.ransack(params[:q])
    @result = @search.result.order("id DESC")

    # index.htmlから絞り込むポイントの位置情報を受け取る
    latitude = params[:riverpoint_latitude]
    longitude = params[:riverpoint_longitude]

    if latitude.present? #ポイント絞込みあり
      # geocoderのnearメソッドで絞り込み
      @hunts = @result.near([latitude, longitude], 0.2, units: :km)
      @hunt_lat = @hunts.map{ |hun|
        hun.latitude
      } #マーカー用の緯度情報の配列作成
      @hunt_lng = @hunts.map{ |hun|
        hun.longitude
      } #マーカー用の経度情報の配列作成
    else #ポイント絞込みなし
      # 釣果情報を地図上に表示
      @hunts = @result.where.not(latitude: nil).order("id DESC") #位置情報ありのレコードを抽出
      @hunt_lat = @hunts.map{ |hun|
        hun.latitude
      } #マーカー用の緯度情報の配列作成
      @hunt_lng = @hunts.map{ |hun|
        hun.longitude
      } #マーカー用の経度情報の配列作成
    end

    # 渓流のポイントを地図上に表示
    @riverpoints = Riverpoint.all
    @riverpoint_lat = @riverpoints.map{ |ri|
      ri.riverpoint_latitude.to_f
    } #マーカー用の緯度情報の配列作成
    @riverpoint_lng = @riverpoints.map{ |ri|
      ri.riverpoint_longitude.to_f
    } #マーカー用の経度情報の配列作成
    @riverpoint_num = @riverpoints.map{ |ri|
      ri.riverpoint_number
    } #マーカー用の番号の配列作成

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

    # 渓流のポイントを地図上に表示
    @riverpoints = Riverpoint.all
    @riverpoint_lat = @riverpoints.map{ |ri|
      ri.riverpoint_latitude.to_f
    } #マーカー用の緯度情報の配列作成
    @riverpoint_lng = @riverpoints.map{ |ri|
      ri.riverpoint_longitude.to_f
    } #マーカー用の経度情報の配列作成
    @riverpoint_name = @riverpoints.map{ |ri|
      ri.riverpoint_name
    } #マーカー用の名前の配列作成

    @apikey = ENV["GOOGLEMAP_APIKEY"]
  end

  private
  def hunt_params
    params.require(:hunt).permit(:fish_photo, :fly_photo, :spot_photo, :latitude, :longitude, :weather_id, :weather_main, :temp, :pressure, :humidity, :wind_speed, :wind_deg, :memo).merge(user_id: current_user.id)
  end
end
