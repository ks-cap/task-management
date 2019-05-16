require 'rails_helper'

describe 'ユーザー管理機能', type: :system do

  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com', admin: true) }

  before do
    # ログインする
    visit login_path
    fill_in 'メールアドレス', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログインする'
  end

  describe '新規作成機能' do

    before do
      visit new_admin_user_path
      fill_in '名前', with: user_b_name
      fill_in 'メールアドレス', with: user_b_email
      fill_in 'パスワード', with: user_b_password
      fill_in 'パスワード（確認）', with: user_b_password_confirmation
      click_button '登録する'
    end

    context '新規ユーザー作成でユーザーを作成したとき' do
      let(:user_b_name) { 'ユーザーB' }
      let(:user_b_email) { 'b@example.com' }
      let(:user_b_password) { 'password' }
      let(:user_b_password_confirmation) { 'password' }

      it '正常に登録される' do
        # 特定のメッセージが画面に表示しているかを確認
        expect(page).to have_selector '.alert-success', text: 'ユーザーB'
      end
    end
  end
end