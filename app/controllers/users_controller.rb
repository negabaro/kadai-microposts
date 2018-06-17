class UsersController < ApplicationController
  before_action :find_user, only: [:show]
  before_action :require_user_logged_in, only: [:show, :index]
  def index
    @users = User.all.page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      redirect_to @user
    else
      flash[:danger] = "'ユーザの登録に失敗しました。"
      render :new
    end
    
  end
  
  private 
  def find_user
    @user = User.find(params[:id])
  end
  
  def user_params
   params.require(:user).permit(:email,:name,:password, :password_confirmation)
  end
  
  
end
