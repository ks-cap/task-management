# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: %i[show edit update destroy]

  USER_DISPLAY_PER_PAGE = 10

  def index
    @users = User.all
                 .includes!(:group, :user_group)
                 .order(:id)
                 .page(params[:page])
                 .per(USER_DISPLAY_PER_PAGE)
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    prepare_group
    if @user.save
      flash[:success] = "ユーザー「#{@user.name}」を登録しました"
      redirect_to admin_user_url(@user)
    else
      render :new
    end
  end

  def update
    prepare_group
    if @user.update(user_params)
      flash[:success] = "ユーザー「#{@user.name}」を更新しました"
      redirect_to admin_user_url(@user)
    else
      render :edit
    end
  end

  def destroy
    if User.where(admin: true).count == 1 && @user.admin
      flash[:danger] = "管理者が一人のため「#{@user.name}」を削除できません"
    else
      @user.destroy
      flash[:danger] = "タスク「#{@user.name}」を削除しました"
    end
    redirect_to admin_users_url
  end

  private

  def user_params
    params.require(:user)
          .permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def require_admin
    redirect_to root_url unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end

  def prepare_group
    if params[:user][:group].present?
      @user.group = Group.find(params[:user][:group])
    else
      @user.user_group&.destroy
    end
  end
end
