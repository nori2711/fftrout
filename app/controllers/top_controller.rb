class TopController < ApplicationController

  def index
    @hunts = Hunt.all.order("id DESC")
  end

  def show
    @hunt = Hunt.find(params[:id])
    @hunt_lat = @hunts.map{ |hun|
      hun.latitude
    } #マーカー用の緯度情報の配列作成
    @hunt_lng = @hunts.map{ |hun|
      hun.longitude
    } #マーカー用の経度情報の配列作成
    @apikey = ENV["GOOGLEMAP_APIKEY"]
  end

end
