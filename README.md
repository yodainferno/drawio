Создание проекта:

1) создание проекта со —skip-hotwire
rails new drawio
cd drawio

2) подключение гемов
gem "devise"
gem 'bootstrap', '~> 5.2.2'
bundle install

3) генерация devise
rails generate devise:install

в config/environments/development.rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

rails g devise:views
rails generate devise users

rails db:migrate

4) создание контроллера рисования
rails g controller canvas paint my gallery

5) После подключения custom js:
https://stackoverflow.com/questions/70548841/how-to-add-custom-js-file-to-new-rails-7-project/71303435#71303435

rails assets:precompile