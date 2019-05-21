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

  describe 'タスク検索機能' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:task1) { FactoryBot.create(:task, name: 'タイトル_1', owner: user) }
    let!(:task2) { FactoryBot.create(:task, name: 'タイトル_10', state: Task.states[:完了], owner: user) }
    let!(:task3) { FactoryBot.create(:task, name: 'タイトル_2', owner: user) }
    let!(:task4) { FactoryBot.create(:task, name: 'タイトル_11', owner: user) }

    it '正しい検索結果が表示される' do
      attr = { name: task1.name, state: task1.state }
      expect(Task.search(attr).pluck(:name)).to match_array [task4.name, task1.name]
    end
  end
end