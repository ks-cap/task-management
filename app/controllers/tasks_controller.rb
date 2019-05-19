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
      flash[:success] = "タスク「#{@task.name}」を登録しました"
      redirect_to tasks_url
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = "タスク「#{@task.name}」を更新しました"
      redirect_to tasks_url
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
  end

  def import
    begin
      current_user.tasks.import(params[:file])
      flash[:success] = 'タスクを追加しました'
    #rescue Tasks::MissingFileContentsError
      #flash[:error] = 'CSVによるタスク一括登録に失敗しました(ファイルを指定して下さい。)'
    rescue StandardError => e
      flash[:danger] = 'CSVによるページ一括登録に失敗しました。'
      Rails.logger.error("There are errors in the uploaded file #{e.message}")
    ensure
      redirect_to tasks_url
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
