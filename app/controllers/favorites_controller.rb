class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  before_action :find_micropost_id, only: [:create,:destroy]
  
  def create
    current_user.add_favorite(@micropost)
    flash[:success] = "お気に入り登録しました。"
    redirect_to :back
    #redirect_to @micropost
  end
  
  def destroy
   current_user.cancel_favorite(@micropost)
   flash[:success] = "お気に入りを取り消しました。"
   #redirect_to @micropost
   redirect_to :back
  end
  
  def likes
    @favorite_list = current_user.likes
  end
  
  
  private
  def find_micropost_id
    @micropost = Micropost.find(params[:micropost_id])
  end
  

end
