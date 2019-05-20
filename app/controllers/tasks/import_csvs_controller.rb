class Tasks::ImportCsvsController < ApplicationController
  def index
  end

  def create
    begin
      raise Exceptions::MissingFileContentsError if !params.has_key?(:file)
      current_user.tasks.import(params[:file])
      flash[:success] = 'タスクを追加しました'
    rescue Exceptions::MissingFileContentsError
      flash[:danger] = 'CSVによるタスク一括登録に失敗しました(ファイルを指定して下さい)'
    rescue StandardError => e
      flash[:danger] = 'CSVによるページ一括登録に失敗しました。'
      Rails.logger.error("There are errors in the uploaded file #{e.message}")
    ensure
      redirect_to tasks_url
    end
  end
end
