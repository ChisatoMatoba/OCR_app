# README

## インストール手順
1. このリポジトリをローカルへ
2. (以下ターミナル操作)プロジェクトのルートディレクトリへ移動`$ cd ~/<path>/OCR_app`
3. `sudo bundle install`
4. `rails db:create`
5. `rails db:migrate`
6. `rails s`
7. 以下のようになればOK
 ```
 % rails s
=> Booting Puma
=> Rails 7.1.3 application starting in development 
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 6.4.2 (ruby 3.2.2-p53) ("The Eagle of Durango")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 40913
* Listening on http://127.0.0.1:3000
* Listening on http://[::1]:3000
Use Ctrl-C to stop
```
8. `http://localhost:3000`にアクセス
