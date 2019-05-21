require 'rails_helper'

describe Group, type: :model do
  describe 'TaskModelに関する処理' do
    let(:group) { FactoryBot.create(:group) }
    subject { group.valid? }

    context 'エラーとならない場合' do
      it '正常な値が設定される' do
        is_expected.to eq true
      end
    end

    context 'エラーとなる場合' do
      it 'タイトルが未設定である' do
        group.name = nil
        is_expected.to eq false
      end

      it 'グループ名が文字列超過である' do
        group.name = 'a' * 256
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーション' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:group) { FactoryBot.create(:group) }
    let!(:user_group) { FactoryBot.create(:user_group, group: group, user: user) }

    it '紐付くユーザーが取得できる' do
      expect(group.users.first).to eq user
    end
  end
end
