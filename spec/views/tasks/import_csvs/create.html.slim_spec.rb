require 'rails_helper'

RSpec.describe 'CSV形式のファイルをインポート・エクスポート', type: :view do

  before do
    # ログインする
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  describe 'インポート機能' do
    context 'ファイルを選択せずにインポートボタンを押したとき' do
      before do
        click_button 'インポート'
      end

      it 'エラーとなる' do
        expect(page).to have_selector '.alert-danger', text: 'CSVによるタスク一括登録に失敗しました(ファイルを指定して下さい)'
      end
    end
  end
end
