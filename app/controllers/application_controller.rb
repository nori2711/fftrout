class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  #釣果を絞り込むメソッド
  def fishing_result_pickup
    # index.htmlから絞り込むポイントの位置情報を受け取る
    riverpoint_id = params[:river_point]
    if riverpoint_id.present?
      riverpoint = Riverpoint.find(riverpoint_id)
      latitude = riverpoint.riverpoint_latitude.to_f
      longitude = riverpoint.riverpoint_longitude.to_f
    end

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
  end

  #ポイントのマーカー情報を作成するメソッド
  def river_point_marker_create
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
  end
end
