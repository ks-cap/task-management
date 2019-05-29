# frozen_string_literal: true

class Tasks::ImportCsvsController < ApplicationController
  def index; end

  def create
    raise Exceptions::MissingFileContentsError unless params.key?(:file)

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
