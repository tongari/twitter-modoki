
# railsインストール

```
$ gem install rails -v 4.2.3
```

```
$ rails _4.2.3_ new ./ -d postgresql
```

# git 

- ステージに配置していないものを元に戻す

```
$ git reset --hard HEAD
```

- 追跡されていないファイル、ディレクトリをワークツリーから削除する。
```
$ git clean -fd
```

# controller作成

```
$ rails g controller {name(s)} {method}
```

# model作成

```
$ rails g model {name}
```

# migrationファイルにカラム定義

```
migrationfile

create_table :{modelname} do |t|
  t.欲しいカラムのデータ型 :カラムの名前
  t.欲しいカラムのデータ型 :カラムの名前

  t.timestamps null: false
end
```

- Cloud9でマイグレーションをするにはCloud9の固有の設定をする必要がある。


# cloud9の固有設定

- データベースを起動

```
$ sudo service postgresql start
```

- PostgreSQLにフル権限ユーザとして接続する

```
$ sudo sudo -u postgres psql
```
`実行後にpostgres=# と表示されればOK。`

- PostgreSQLにOSのユーザ名と同名のユーザを登録する。

```
$ CREATE USER ubuntu SUPERUSER;
```

- 完了したらPostgreSQL実行モードから抜け出す。

```
$ コントロールキー(ctrl)とd
```

- config/database.ymlファイルを編集

```
#省略
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: 5
  template: template0

development:
#省略
```
`template0と指定することで、独自のエンコーディング設定を行うことができます。`


# マイグレーション実行

- まずはデータベースを作成（最初の１回だけ）

```
$ rake db:create
```

- マイグレーション実行

```
$ rake db:migrate
```

- schemaを確認
`db/schema.rb` を確認

# dbを確認

- データベースのターミナルを開く
```
$ rails db
```

- テーブル確認
```
$ \d
```

# サーバを起動
- Cloud9の場合
```
$ rails s -b $IP -p $PORT
```

- ローカル
```
$ rails s
```

# DBに初期データ投入

- seeds.rbに記載
```
# coding: utf-8
Tweet.create(:content => 'ダミー投稿')
```


- DBに適用
```
$ rake db:seed
```

# CRUDを作成
- resourcesメソッドを使用して、routingを作成

`config/routes.rb`
```ruby:config/routes.rb
Rails.application.routes.draw do
  resources :tweets
  
  ~~~~~~~~~~
  省略
  ~~~~~~~~~~

```


- viewに適宜要素を作成

`views/tweets/index.html.erb`
```ruby:views/tweets/index.html.erb
<% @tweets.each do |tweet| %>
<p><%= tweet.content %></p>
<% end %>
```
とか<br>

`views/tweets/new.html.erb`
```ruby:views/tweets/new.html.erb
<%= form_for(@tweet, url: tweets_path) do |f| %>
  <%= f.label :つぶやき %>
  <%= f.text_area :content %>
  <%= f.submit :投稿 %>
<% end %>
```
`form helperは適宜ぐぐる`


- controllerにroutingに対応したメソッドを作成する

`controllers/tweets_controller.rb`
```ruby:controllers/tweets_controller.rb
class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all
  end
  
  def new
    @tweet = Tweet.new
  end
  
  def create
    @tweet = Tweet.new(tweets_param)
    if @tweet.save
      redirect_to tweets_path, notice: "つぶやき投稿しました！"
    else
      render 'new'
    end
  end
  
  
  private
    def tweets_param
      params.require(:tweet).permit(:content);
    end
end
  
など（他、edit,deleteなどもろもろ追記必要あり）
```

- modelにバリデーションを作成

`models/tweet.rb`

```ruby:models/tweet.rb
class Tweet < ActiveRecord::Base
  validates :content, presence:true, length: {maximum: 140}
end
```


- エラーメッセージを表示させる

`参考url`<br>
[http://ruby-rails.hatenadiary.com/entry/20140810/1407623400](http://ruby-rails.hatenadiary.com/entry/20140810/1407623400)


- エラーメッセージを日本語化させる

`参考url`<br>
[http://blog.otsukasatoshi.com/entry/2016/04/17/024627](http://blog.otsukasatoshi.com/entry/2016/04/17/024627)<br>
[http://tarunama.hatenablog.com/entry/2017/05/22/201531](http://tarunama.hatenablog.com/entry/2017/05/22/201531)

`がしかし`<br>

`models/tweet.rb`
```ruby:models/tweet.rb
class Tweet < ActiveRecord::Base
  validates :content, presence:true, length: {maximum: 140}
  
  
  validate :add_error

  def add_error
    # 空のときにエラーメッセージを追加する
    if content.blank?
      errors[:base] << "なにかつぶやいてね"
    end
  end
  
end
```

`views/tweets/new.html.erb`
```ruby:views/tweets/new.html.erb
<div id="error_explanation">
  <h2><%= @tweet.errors.messages[:base].count %>件のエラーがあります。</h2>
  <ul>
    <% @tweet.errors.messages[:base].each do |msg| %>
    <li><%= msg %></li>
    <% end %>
  </ul>
</div>
<% end %>
```

`カスタムエラーで追記すれば、日本語化の必要ない？？`


- 投稿削除を作成

`views/tweets/index.html.erb`
```ruby:views/tweets/index.html.erb
<%= link_to 'このつぶやきを削除！', tweet_path(tweet.id), method: :delete ,
data: { confirm: '本当に削除していいですか？' } %>
```

`controllers/tweets_controller.rb`
```ruby:controllers/tweets_controller.rb
def destroy
  @tweet = Tweet.find(params[:id])
  @tweet.destroy
  redirect_to tweets_path, notice: "つぶやきを削除しました！"
end
```

- 投稿編集を作成

`controllers/tweets_controller.rb`
```ruby:controllers/tweets_controller.rb
def update
  if @tweet.update(tweets_param)
    redirect_to tweets_path, notice: "つぶやきを更新しました！"
  else
    render 'edit'
  end
end
```

- 投稿確認を作成

`config/routes.rb`
```ruby:config/routes.rb
resources :tweets ,only: [:index, :new, :create, :edit, :update ,:destroy] do
  collection do
    post :confirm
  end
end
```

`controllers/tweets_controller.rb`
```ruby:controllers/tweets_controller.rb
def confirm
  @tweet = Tweet.new(tweets_param)
  render :new if @tweet.invalid?
end
```
`views/tweets/confirm.html.erb`
```ruby:views/tweets/confirm.html.erb
<h1>つぶやきを確認</h1>

<%= form_for(@tweet, url: tweets_path) do |f| %>
  <!--隠しパラメータ-->
  <%= f.hidden_field :content %>
  <p>
    <span>つぶやき内容 : </span> <%= @tweet.content %>  
  </p>
  <%= f.submit :投稿 %>
<% end %>
```

- 投稿確認から投稿画面へ戻る際パラメータを引き継ぐ

`views/tweets/confirm.html.erb`
```ruby:views/tweets/confirm.html.erb
<h1>つぶやきを確認</h1>

<%= form_for(@tweet, url: tweets_path) do |f| %>
  <!--隠しパラメータ-->
  <%= f.hidden_field :content %>
  <p>
    <span>つぶやき内容 : </span> <%= @tweet.content %>  
  </p>
  <%= f.submit :投稿 %>
<% end %>

<%= form_for(@tweet, url:new_tweet_path, method: 'get') do |f| %>
  <%= f.hidden_field :content %>
  <%= f.submit "戻る", name:'back' %>
<% end %>
```

`controllers/tweets_controller.rb`
```ruby:controllers/tweets_controller.rb
def new
  if params[:back]
    @tweet = Tweet.new(tweets_param)
  else
    @tweet = Tweet.new
  end
end
に変更
```

がしかし、`戻る際、getで値が見えてしまうのでpostで戻りたい`ので今回は以下で対応


`config/routes.rb`
```ruby:config/routes.rb
resources :tweets ,only: [:index, :new, :create, :edit, :update ,:destroy] do
  collection do
    post :confirm
  end
end

post 'tweets/new' => 'tweets#new'
```

`controllers/tweets_controller.rb`
```ruby:controllers/tweets_controller.rb
def new
  # if params[:back]
  if request.post?
    @tweet = Tweet.new(tweets_param)
  else
    @tweet = Tweet.new
  end
end
```

`views/tweets/confirm.html.erb`
```ruby:views/tweets/confirm.html.erb
<!-- 遷移先パスを変更してgetからpostへ-->
<%= form_for(@tweet, url:tweets_new_path, method: 'post') do |f| %>
  <%= f.hidden_field :content %>
  <%= f.submit "戻る", name:'back' %>
<% end %>
```

# viewをいい感じにする

### 時間表示する

- 日本の時刻にする

`config/application.rb` に以下を追記
```
config.time_zone = 'Tokyo'
config.active_record.default_timezone = :local
```

- 時間表示を整形する

`参考サイト`<br>
[http://orange-lily27.hatenablog.com/entry/2015/07/12/102003](http://orange-lily27.hatenablog.com/entry/2015/07/12/102003)

- 文字数カウントを作る

`忌まわしきtubolinksをはずす`

`app/assets/javascripts/application.js`
```
//= require jquery
//= require jquery_ujs
//= require turbolinks <- これを削除
//= require_tree .
```

`views/layouts/application.htm.erb`
```
<%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
↓
<%= javascript_include_tag 'application' %>
```

- bootstrapで作る

`Gemfile`
```
gem 'twitter-bootstrap-rails
```

```bash
$ bundle install
$ rails generate bootstrap:install static
```

# herokuに公開

- hrokuとの連携準備

```bash
$ heroku login
$ heroku create
```

- Herokuへのアセットプリコンパイル

`config/environments/production.rb`
```ruby
config.assets.compile = false
↓
config.assets.compile = true
```

```bash
$ rake assets:precompile RAILS_ENV=production
```

- Gem「rails_12factor」を追加

`Gemfile`
```ruby
gem 'rails_12factor', group: :production
を追記
```

```bash
$ bundle install
```

- Herokuへの送付

`まずはアセットプリコンパイルしたものをgitにpush`
```
$ git add -A
$ git commit -m 'update'
$ git push heroku master
```

- Herokuのデータベースにテーブルを作成

```bash
$ heroku run rake db:migrate RAILS_ENV=production
```

- 環境変数を設定する

```
$ heroku config:add SECRET_TOKEN="$(bundle exec rake secret)"
```


### 追加機能としては
- 投稿する際にニックネームとアバターを設定させる
- ページング