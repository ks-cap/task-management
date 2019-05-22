# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  describe 'TaskModelに関する処理' do
    let(:user) { FactoryBot.build(:user) }
    subject { user.valid? }

    context 'エラーとならない場合' do
      it '正常な値が設定される' do
        is_expected.to eq true
      end
    end

    context 'エラーとなる場合' do
      it '名前が未設定である' do
        user.name = nil
        is_expected.to eq false
      end

      it '名前が文字列超過である' do
        user.name = 'a' * 31
        is_expected.to eq false
      end

      it 'メールアドレスが未設定である' do
        user.email = nil
        is_expected.to eq false
      end

      it 'メールアドレスが文字列超過である' do
        user.email = 'a' * 255 + '@example.com'
        is_expected.to eq false
      end

      it 'メールアドレスが不正である' do
        user.email = '@example.com'
        is_expected.to eq false
        user.email = 'aaaaaa'
        is_expected.to eq false
      end

      it 'メールアドレスが重複である' do
        user.save
        invalid_user = FactoryBot.build(:user, email: user.email)
        expect(invalid_user.valid?).to eq false
      end

      it 'パスワードが未設定である' do
        user.password = nil
        is_expected.to eq false
      end

      it 'パスワードが文字列過少である' do
        user.password = 'a' * 5
        is_expected.to eq false
      end
    end

    context 'アソシエーション' do
      let!(:user) { FactoryBot.create(:user, admin: true) }
      let!(:task) { FactoryBot.create(:task, user: user, owner: user) }
      let!(:group) { FactoryBot.create(:group) }
      let!(:user_group) { FactoryBot.create(:user_group, group: group, user: user) }

      it '紐付くタスクが取得できる' do
        expect(user.tasks.first).to eq task
      end

      it '紐付くグループが取得できる' do
        expect(user.group).to eq group
      end
    end
  end
end
