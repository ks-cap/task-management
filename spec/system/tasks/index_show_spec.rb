# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '登録したタスクを確認する', type: :system do
  let!(:current_user) { FactoryBot.create(:user) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email),    with: current_user.email
    fill_in User.human_attribute_name(:password), with: current_user.password
    click_button I18n.t('button.login')
  end

  describe 'タスク一覧' do
    describe '一覧表示' do
      let!(:task1) { FactoryBot.create(:task, name: 'タイトル1', user: current_user, owner: current_user) }
      let!(:task2) { FactoryBot.create(:task, name: 'タイトル2', user: current_user, owner: current_user) }
      let!(:task3) { FactoryBot.create(:task, name: 'タイトル3', user: current_user, owner: current_user) }

      before { visit tasks_path }

      it 'タスクの一覧が表示されること' do
        expect(page).to have_content task1.name
        expect(page).to have_content task2.name
        expect(page).to have_content task3.name
      end
    end
  end

  describe 'タスク詳細' do
    let!(:task) { FactoryBot.create(:task, user: current_user, owner: current_user) }
    before { visit task_path(task) }

    it '指定したタスクの詳細が表示されること' do
      expect(page).to have_content task.name
    end
  end
end
