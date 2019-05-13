class ApplicationController < ActionController::Base
    # helper_method指定することで全てのビューから使えるようにする
  helper_method :current_user
  # アプリケーション内の全てのアクションの処理前にユーザーがログイン済みかどうかチェックを入れる
  before_action :login_required
  private
  # ユーザーがログインしていればsession[:user_id]にユーザーのidが入っているため、Userオブジェクトを取得できる
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path unless current_user
  end
end
