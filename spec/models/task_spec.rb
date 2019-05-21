require 'rails_helper'

describe Task, type: :model do
  describe 'TaskModelに関する処理' do
    let!(:user) { FactoryBot.create(:user) }
    let(:task) { FactoryBot.build(:task, owner: user) }
    subject { task.valid? }

    context 'エラーとならない場合' do
      it '正常な値が設定される' do
        is_expected.to eq true
      end
    end

    context 'エラーとなる場合' do
      it 'タイトルが未設定と表示される' do
        task.name = nil
        is_expected.to eq false
      end

      it 'ステータスが未設定と表示される' do
        task.state = nil
        is_expected.to eq false
      end

      it '終了期日が過去日と表示される' do
        task.deadline = Time.current.ago(1.day)
        is_expected.to eq false
      end

      it '作成者が未設定と表示される' do
        task.owner = nil
        is_expected.to eq false
      end
    end

    context 'アソシエーション' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:owner) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.build(:task, user: user, owner: owner)}

      it '紐付くユーザーが取得できる' do
        expect(task.user).to eq user
      end

      it '作成者に紐付くユーザーが取得できる' do
        expect(task.owner).to eq owner
      end
    end
  end

end