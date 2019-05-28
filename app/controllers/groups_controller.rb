# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[edit update destroy]

  GROUP_DISPLAY_PER_PAGE = 10

  def index
    @groups = Group.all.order(:id).page(params[:page]).per(GROUP_DISPLAY_PER_PAGE)
  end

  def show
    @group = Group.includes(:users).find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    if @group.save
      flash[:success] = I18n.t('message.groups.create', name: @group.name)
      redirect_to group_url(@group)
    else
      render :new
    end
  end

  def update
    if @group.update
      flash[:success] = I18n.t('message.groups.update', name: @group.name)
      redirect_to group_url(@group)
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:danger] = I18n.t('message.groups.destroy', name: @group.name)
    redirect_to groups_url
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
