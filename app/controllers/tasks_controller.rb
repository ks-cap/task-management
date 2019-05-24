# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy sort]

  TASK_DISPLAY_PER_PAGE = 25

  def index
    # グループに属している場合はグループに関連するタスク表示
    # 所属していない場合は自分のタスクのみ表示
    @q = if current_user.admin?
           Task.all
         elsif current_user.group.present?
           Task.with_group(current_user.group)
         else
           current_user.tasks
         end.ransack(params[:q])

    @tasks = @q.result(distinct: true)
               .page(params[:page])
               .per(TASK_DISPLAY_PER_PAGE).rank(:row_order)

    respond_to do |format|
      format.html
      format.csv do
        send_data @tasks.generate_csv,
                  filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"
      end
    end
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    # ログインしているユーザーのidをuser_idに入れた状態でTaskデータを登録
    @task = current_user.tasks.new(task_params)
    @task.owner = current_user
    if @task.save
      flash[:success] = I18n.t('message.tasks.create', name: @task.name)
      redirect_to tasks_url
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = I18n.t('message.tasks.update', name: @task.name)
      redirect_to tasks_url
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:danger] = I18n.t('message.tasks.destroy', name: @task.name)
    redirect_to tasks_url
  end


  def sort
    set_task
    @task.update(task_params)
    render nothing: true
  end

  private

  def task_params
    params.require(:task)
          .permit(:name, :description, :deadline, :state, :image, :row_order_position)
  end


  def set_task
    @task = if current_user.admin?
              Task.find(params[:id])
            else
              current_user.tasks.find(params[:id])
            end
  end

  def only_my_group_editable
    unless Task.find(params[:id]).editable?(current_user)
      flash[:danger] = I18n.t('message.tasks.editable', name: @task.name)
      redirect_to tasks_url
    end
  end

end
