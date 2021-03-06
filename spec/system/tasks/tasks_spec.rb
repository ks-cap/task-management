# frozen_string_literal: true

require 'rails_helper'

describe 'タスク管理機能', type: :system do
  # ユーザーAとユーザーBを定義する
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  # ユーザーAのタスクを作成するタイミングで、user_aを利用する。この時点でuser_aがデータベースに登録される。
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a, owner: user_a) }
  let!(:task_b) { FactoryBot.create(:task, name: '次のタスク', user: user_a, owner: user_a) }
  let!(:task_c) { FactoryBot.create(:task, name: '最後のタスク', user: user_a, owner: user_a) }

  # contextの内容が呼び出される前に実行(1つのdescribeの中に複数のcontextが存在する場合contextの外側のbeforeが呼ばれる)
  before do
    # ログインする
    visit login_path
    fill_in I18n.t('activerecord.attributes.session.email'), with: login_user.email
    fill_in I18n.t('activerecord.attributes.session.password'), with: login_user.password
    click_button I18n.t('button.login')
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしているとき' do
      # before do で利用するlogin_userを定義する
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }

      it 'ユーザーAが作成したタスクが表示されない' do
        # ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end

  describe 'CSV形式のファイルをインポート・エクスポート' do
    describe 'インポート機能' do
      let(:login_user) { user_a }
      context 'ファイルを選択せずにインポートボタンを押したとき' do
        before do
          click_button I18n.t('button.import')
        end

        it 'エラーとなる' do
          expect(page).to have_selector '.alert-danger', text: 'CSVによるタスク一括登録に失敗しました(ファイルを指定して下さい)'
        end
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    let(:task_description) { '' }

    before do
      visit new_task_path
      fill_in I18n.t('activerecord.attributes.task.name'), with: task_name
      fill_in I18n.t('activerecord.attributes.task.description'), with: task_description
      click_button I18n.t('button.create')
    end

    context '新規作成画面で名称を入力したとき' do
      let(:task_name) { '新規作成のテストを書く' }

      it '正常に登録される' do
        # 特定のメッセージが画面に表示しているかを確認
        expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
      end
    end

    context '新規作成画面で名称を入力しなかったとき' do
      let(:task_name) { '' }

      it 'エラーとなる' do
        # within: 探索する範囲を画面内の特定の範囲に狭める
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end

    context '新規作成画面で名称をコンマが入力されたとき' do
      let(:task_name) { '次の、タスク' }

      it 'エラーとなる' do
        # within: 探索する範囲を画面内の特定の範囲に狭める
        within '#error_explanation' do
          expect(page).to have_content '名称にカンマを含めることはできません'
        end
      end
    end

    context '新規作成画面で名称が指定文字列を超えたとき' do
      let(:task_name) { (0...50).map { rand(65..90).chr }.join }

      it 'エラーとなる' do
        # within: 探索する範囲を画面内の特定の範囲に狭める
        within '#error_explanation' do
          expect(page).to have_content '名称は30文字以内で入力してください'
        end
      end
    end

    context '新規作成画面で詳しい説明が指定文字列を超えたとき' do
      let(:task_name) { '最後のタスク' }
      let(:task_description) { (0...150).map { rand(65..90).chr }.join }

      it 'エラーとなる' do
        # within: 探索する範囲を画面内の特定の範囲に狭める
        within '#error_explanation' do
          expect(page).to have_content '詳しい説明は100文字以内で入力してください'
        end
      end
    end
  end
end
