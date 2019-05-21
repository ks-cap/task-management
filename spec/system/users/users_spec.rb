# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com', admin: true, group: group) }
  let!(:user_c) { FactoryBot.create(:user, name: 'ユーザーC', email: 'c@example.com', group: group) }
  let(:group) { FactoryBot.create(:group) }

  before do
    # ログインする
    visit login_path
    fill_in 'メールアドレス', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログインする'
  end

  describe '新規作成機能' do
    let(:user_b_email) { 'b@example.com' }
    let(:user_b_password) { 'password' }
    let(:user_b_password_confirmation) { 'password' }

    before do
      visit new_admin_user_path
      fill_in User.human_attribute_name(:name), with: user_b_name
      fill_in User.human_attribute_name(:email), with: user_b_email
      select group.name, from: User.human_attribute_name(:group)
      fill_in User.human_attribute_name(:password), with: user_b_password
      fill_in User.human_attribute_name(:password_confirmation), with: user_b_password_confirmation
      click_button '登録する'
    end

    context '新規ユーザー作成でユーザーを作成したとき' do
      let(:user_b_name) { 'ユーザーB' }

      it '正常に登録される' do
        # 特定のメッセージが画面に表示しているかを確認
        expect(page).to have_selector '.alert-success', text: 'ユーザーB'
      end
    end

    context '新規ユーザー作成でユーザーを作成したとき' do
      let(:user_b_name) { '' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content '名前を入力してください'
        end
      end
    end

    context '新規ユーザー作成でユーザーを作成したとき' do
      let(:user_b_name) { 'ユーザーB' }
      let(:user_b_email) { 'c@example.com' }

      it 'エラーとなる' do
        within '#error_explanation' do
          expect(page).to have_content 'メールアドレスはすでに存在します'
        end
      end
    end
  end

  # 機能していない
  describe 'ユーザー削除機能' do
    before do
      visit admin_users_path
    end

    context '管理者権限を持っている人がユーザーを削除しようとしたとき' do
      before do
        #page.first('削除').click
        click_button '削除'
      end

      it '正常に削除される' do
        expect(page).to have_selector '.alert-danger', text: '管理者が一人のため「ユーザーA」を削除できません'
      end
    end

    context '管理者権限を持っている人が1人しかいない状態で管理者を削除しようとしたとき' do
      before do
        #page.first('削除').click
        click_button '削除'
      end
      it 'エラーとなる' do
        expect(page).to have_selector '.alert-danger', text: '管理者が一人のため「ユーザーA」を削除できません'
      end
    end
  end
end
