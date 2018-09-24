class UsersController < ApplicationController

  def index
  end

  def show
    @user = User.find(params[:id])
    # @hunts = current_user.hunts.order("id DESC")

    # 検索の選択肢をviewに渡す
    @riverpoint = Riverpoint.all
    # weathersテーブルをhuntsテーブルのweather_mainにあるものに絞り込んで検索の選択肢をviewに渡す
    @weather = Weather.joins(:hunts).group('weather_main')
    # ransackにて釣果を検索
    @search = current_user.hunts.search(params[:q])
    @result = @search.result.order("id DESC")

    #釣果絞込み（application_controllerで定義）
    fishing_result_pickup
    #ポイントのマーカー情報作成（application_controllerで定義）
    river_point_marker_create

    @apikey = ENV["GOOGLEMAP_APIKEY"]
  end

  def edit
  end

  def update
  end
end
