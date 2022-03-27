# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Version
  * ruby 3.0.2p107 (2021-07-07 revision 0db68f0233) [x86_64-darwin20]
  * Rails 7.0.2.3

* 追加したGem
  * gem 'rspec-rails'
  * gem "slim-rails"

* Configuration
  * gemの制限があるので、使われた環境変数は`config/local_env.yml`に記載されました。
  * `config/local_env.yml`にいろんな連携データが載せられましたので、repoに上げなかったとなります。
  * ローカルで動作確認する際は、また別途で`config/local_env.yml`を送りさせていただきます。

* Database creation
  * postgresを使いました。
  * 事前にpostgresをインストールする必要があります。
  * `rake db:create db:migrate`

* Database initialization
  * Seedを使って仮のユーザーを作成する
  * `rake db:seed`

* How to run the test suite
  * テストはrspecで書かれました。
  * `RAILS_ENV=test rspec spec/`で動ける。

* Services
  * API連携するためにサービスそうを導入しました。

* ローカルで環境を立ち上がる手順
  - rbenv install 3.0.2
  - rbenv local 3.0.2
  - ruby --version (今のrubyバージョンを確認してください)
  - gem install rails
  - rails -v (今のrailsバージョンを確認してください)
  - RAILS_ENV=development bundle exec rake db:create db:migrate (DBを立ち上げます)
    - roleやuserの権限周りに問題が起こってる可能性があります。その時は`config/database.yml`あるいはpostgres側に調整すれば、うまく実行されるはずです。
  - rails s (ローカルのサーバーを立ち上げます)
  - RAILS_ENV=test bundle exec rspec spec/ (テストを実行します)

* repo管理
  * milestonesを設置しまして、今回の要件紐ついてissueとして作成します。
  * 実装はpull requestで提出しまして、完了した後はrebase mergeやsquarsh mergeでmainに統合します。
  * 開発途中で何か修正すべきところとか、強化する部分が有った場合は随時issuesを作ります。
  * issueで動作確認を行なって、pull requestのマージするかどうかを決めます。
  * ブランチマージしたら随時削除します。
  * mainブランチをpull rebaseを行なって、最新を差分を取り込めれた後に、新しいブランチを切って作業を続きます。
  * milestonesの達成を目指して、開発をすすめておきます。
