class Admin::GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]
  GROUP_DISPLAY_PER_PAGE = 10

  def index
    @groups = Group.all.order(:id).page(params[:page]).per(GROUP_DISPLAY_PER_PAGE)
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new)(group_params)
    if @group.save
      flash[:notice] = "グループ「#{@group.name}」を作成しました"
      redirect_to admin_group_url(@group)
    else
      render :new
    end
  end

  def update
    if @group.update
      flash[:notice] = "グループ「#{@group.name}」を更新しました"
      redirect_to admin_group_url(@group)
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:danger] = "グループ「#{@group.name}」を削除しました"
    redirect_to admin_groups_url
  end

  private
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
