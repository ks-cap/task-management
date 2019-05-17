class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # ログインしているユーザーに紐づくTaskだけを表示
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html
      format.csv { send_data @tasks.generate_csv, filename: "tasks-#{Time.zone.now.strftime('%Y%m%d%S')}.csv"}
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    # ログインしているユーザーのidをuser_idに入れた状態でTaskデータを登録
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました．"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
  end

  def import
    if params.has_key?(:file)
      current_user.tasks.import(params[:file])
      redirect_to tasks_url, notice: "タスクを追加しました"
    else
      redirect_to tasks_url, notice: "追加するファイルが存在しません"
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :deadline, :state, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
