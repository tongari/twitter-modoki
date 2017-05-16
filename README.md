
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

