require "json"
require "open-uri"
require 'net/http'
require 'uri'

class HuntsController < ApplicationController
  # OpenWeatherMapのAPI_KEYとcurrent weather URL
  API_KEY = ENV['WEATHERMAP_APIKEY']
  BASE_URL = 'http://api.openweathermap.org/data/2.5/weather'

  def index
    # 検索の選択肢をviewに渡す
    @riverpoint = Riverpoint.all
    # weathersテーブルをhuntsテーブルのweather_mainにあるものに絞り込んで検索の選択肢をviewに渡す
    @weather = Weather.joins(:hunts).group('weather_main')
    # ransackにて釣果を検索
    @search = Hunt.ransack(params[:q])
    @result = @search.result.order("id DESC")

    #釣果絞込み（application_controllerで定義）
    fishing_result_pickup
    #ポイントのマーカー情報作成（application_controllerで定義）
    river_point_marker_create

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
      redirect_to "/hunts/#{@hunt.id}/edit"
    else
      render "new"
    end
  end

  def show
    @hunt = Hunt.find(params[:id])

    #ポイントのマーカー情報作成（application_controllerで定義）
    river_point_marker_create

    @apikey = ENV["GOOGLEMAP_APIKEY"]

    # フライ判定済であればフライ種類名をビューに渡す
    if @hunt.flyclass.present?
      @flyname = Flytype.find_by(flyclass: @hunt.flyclass).flyname
    end
  end

  def destroy
    hunt = Hunt.find(params[:id])
    if hunt.user_id == current_user.id
      hunt.destroy
    end
  end

  def edit
    @hunt = Hunt.find(params[:id])
    @flytypes = Flytype.all
    if @hunt.fly_photo.present?
      # フライ識別APIにrequestしてresponseを受け取る
      uri = URI.parse("https://aqueous-basin-70922.herokuapp.com/fly/files")
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(
        "filename" => @hunt["fly_photo"],
        "photoid" => @hunt.id,
      )
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      result = JSON.parse(response.body)
      @predicted1 = result['predicted1']
      @predicted2 = result['predicted2']
      @predicted3 = result['predicted3']
      @percentage1 = result['percentage1']
      @percentage2 = result['percentage2']
      @percentage3 = result['percentage3']
      # その他の選択肢
      @predicted90 = 'standard'
      @predicted91 = 'upper-wing'
      @predicted92 = 'wet'
      @predicted99 = 'others'
      @percentage99 = 'ー'
      # フライ種類の名前
      @flyname1 = Flytype.find_by(flyclass: @predicted1).flyname
      @flyname2 = Flytype.find_by(flyclass: @predicted2).flyname
      @flyname3 = Flytype.find_by(flyclass: @predicted3).flyname
      @flyname90 = Flytype.find_by(flyclass: @predicted90).flyname
      @flyname91 = Flytype.find_by(flyclass: @predicted91).flyname
      @flyname92 = Flytype.find_by(flyclass: @predicted92).flyname
      @flyname99 = Flytype.find_by(flyclass: @predicted99).flyname
    end
  end

  def update
    hunt = Hunt.find(params[:id])
    if hunt.user_id == current_user.id
      hunt.update(hunt_update_params)
    end
  end

  private
  def hunt_params
    params.require(:hunt).permit(:fish_photo, :fly_photo, :spot_photo, :latitude, :longitude, :weather_id, :weather_main, :temp, :pressure, :humidity, :wind_speed, :wind_deg, :memo).merge(user_id: current_user.id)
  end

  def hunt_update_params
    params.permit(:fly_photo, :spot_photo, :memo, :flyclass)
  end
end
