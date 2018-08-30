class UsersController < ApplicationController

  def index
    # 釣果情報を地図上に表示
    @hunts = current_user.hunts.where.not(latitude: nil) #位置情報ありのレコードを抽出
    @hunt_lat = @hunts.map{ |hun|
      hun.latitude
    } #マーカー用の緯度情報の配列作成
    @hunt_lng = @hunts.map{ |hun|
      hun.longitude
    } #マーカー用の経度情報の配列作成

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
