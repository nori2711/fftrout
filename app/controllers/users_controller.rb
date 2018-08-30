class UsersController < ApplicationController

  def index
    # ransackにて釣果を検索
    @search = current_user.hunts.ransack(params[:q])
    @result = @search.result.order("id DESC")
    #位置情報ありのレコードを抽出
    @userhunt = @result.where.not(latitude: nil)

    # index.htmlから絞り込むポイントの位置情報を受け取る
    latitude = params[:riverpoint_latitude]
    longitude = params[:riverpoint_longitude]

    if latitude.present? #ポイント絞込みあり
      # geocoderのnearメソッドで絞り込み
      @hunts = @userhunt.near([latitude, longitude], 0.2, units: :km)
      @hunt_lat = @hunts.map{ |hun|
        hun.latitude
      } #マーカー用の緯度情報の配列作成
      @hunt_lng = @hunts.map{ |hun|
        hun.longitude
      } #マーカー用の経度情報の配列作成
    else #ポイント絞込みなし
      # 釣果情報を地図上に表示
      @hunts = @userhunt
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

  def show
    @user = User.find(params[:id])
    @hunts = current_user.hunts.order("id DESC")
  end

  def edit
  end

  def update
  end
end
