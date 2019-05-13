# README
![](https://img.shields.io/badge/Ruby-2.6.3-red.svg)
![](https://img.shields.io/badge/Rails-5.2.3-blue.svg)

# task-management
## タスク管理システム
### 要件
- 自分のタスクを簡単に登録したい
- タスクに終了期限を設定できるようにしたい
- タスクに優先順位をつけたい
- ステータス（未着手・着手・完了）を管理したい
- ステータスでタスクを絞り込みたい
- タスク名・タスクの説明文でタスクを検索したい
- タスクを一覧したい。一覧画面で（優先順位、終了期限などを元にして）ソートしたい
- タスクにラベルなどをつけて分類したい
- ユーザ登録し、自分が登録したタスクだけを見られるようにしたい

# Dependency
- Ruby
- Ruby on Rails
- PostgreSQL
- React

# Setup
- `bundle install --path vendor/bundle`
- `bin/rails db:create`
- `bin/rails db:migrate`

# Usage
## Deploy
### Railsアプリとherokuの紐づけ
- PCからherokuにログイン  
  `heroku login`
- アプリごとに最初の一回だけ！  
  `heroku create 好きなアプリ名`
- herokuにデプロイ  
  `git push heroku master`
- 本番環境(heroku)でのマイグレーション  
  `heroku run rails db:migrate`
- サイトを開く  
  [ココ](https://task-management-ks.herokuapp.com/)


# Licence

# Authors
Ken Sato

# References
[株式会社万葉の新入社員教育用カリキュラム](https://github.com/everyleaf/el-training)
