# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'ユーザー一覧と詳細', type: :system do
  let(:user1) { FactoryBot.create(:user, name: 'test_user_1') }
  let(:current_user) { FactoryBot.create(:user, admin: true) }

  before do
    visit login_path
    fill_in User.human_attribute_name(:email), with: current_user.email
    fill_in User.human_attribute_name(:password), with: current_user.password
    click_button I18n.t('button.login')
  end

  describe '詳細' do
    let!(:task) { FactoryBot.create(:task, user: user1, owner: user1) }
    before { visit admin_user_path(user1) }

    it '詳細が表示される' do
      expect(page).to have_content user1.name
    end
  end
end
