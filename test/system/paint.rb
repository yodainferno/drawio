# frozen_string_literal: true

require 'rails_helper'

USER1_LOGIN = '1@test.ru'
USER1_PASS = '1' * 6

USER2_LOGIN = '2@test.ru'
USER2_PASS = '2' * 6

RSpec.describe 'Static content', type: :system do
  def set_users
    sign_up(USER1_LOGIN, USER1_PASS)
    sign_up(USER2_LOGIN, USER2_PASS)
  end

  def sign_up(login, pass)
    visit 'users/sign_up' # переходим на страницы ввода

    fill_in :user_email, with: login
    fill_in :user_password, with: pass
    fill_in :user_password_confirmation, with: pass

    find('input[type=submit]').click
    sleep 0.5

    find('#logout').click
    sleep 0.5
    expect(current_path).to eq('/users/sign_in')
  end

  def sign_in(login, password)
    fill_in :user_email, with: login
    fill_in :user_password, with: password

    find('input[type=submit]').click
    sleep 0.5
  end

  def create_canvas(ids)
    # 1 - private:1, active: 1
    visit 'paint'
    sleep 0.5
    fill_in :name, with: "Canvas #{ids[0]} - private"
    find('input[type=submit]').click; sleep 0.5
    expect(page).to have_field('out_link', with: "http://localhost:3000/show/#{ids[0]}")

    # 2 - private:0, active: 1
    visit 'paint'
    sleep 0.5
    fill_in :name, with: "Canvas #{ids[1]} - open"
    find('input[name=private]').click
    find('input[type=submit]').click; sleep 0.5
    expect(page).to have_field('out_link', with: "http://localhost:3000/show/#{ids[1]}")

    # 3 - private:0, active: 0
    visit 'paint'
    sleep 0.5
    fill_in :name, with: "Canvas #{ids[2]} - deleted"
    find('input[name=private]').click
    find('input[name=active]').click
    find('input[type=submit]').click; sleep 0.5
    expect(page).to have_field('out_link', with: "http://localhost:3000/show/#{ids[2]}")
  end


  scenario 'paint security check' do
    set_users

    visit 'users/sign_in'
    sign_in(USER1_LOGIN, USER1_PASS)
    create_canvas([1, 2, 3])
    find('#logout').click

    visit 'users/sign_in'
    sign_in(USER2_LOGIN, USER2_PASS)
    create_canvas([4, 5, 6])
    find('#logout').click
    
    # 
    visit 'users/sign_in'
    sign_in(USER1_LOGIN, USER1_PASS)
    
    # окей
    visit 'paint/1'; sleep 0.5
    expect(find('#canvas'))


    # окей
    visit 'paint/2'; sleep 0.5
    expect(find('#canvas'))

    # окей
    visit 'paint/3'; sleep 0.5
    expect(find('#canvas'))

    # окей
    visit 'paint/5'; sleep 0.5
    expect(find('#canvas'))

    # не окей
    visit 'paint/4'; sleep 0.5
    expect(find('body')).to have_text('Нет доступа к ресурсу')

    # не окей
    visit 'paint/6'; sleep 0.5
    expect(find('body')).to have_text('Нет доступа к ресурсу')


    # окей
    visit 'show/1'; sleep 0.5
    expect(find('#canvas'))

    # окей
    visit 'show/2'; sleep 0.5
    expect(find('#canvas'))

    # окей
    visit 'show/3'; sleep 0.5
    expect(find('#canvas'))

    # окей
    visit 'show/5'; sleep 0.5
    expect(find('#canvas'))

    
    # не окей
    visit 'show/4'; sleep 0.5
    expect(find('body')).to have_text('Автор ограничил доступ к ресурсу')
    
    # не окей
    visit 'show/6'; sleep 0.5
    expect(find('body')).to have_text('Данная запись удалена')
    
    # не окей
    visit 'show/0'; sleep 0.5
    expect(find('body')).to have_text('Запись не найдена')
    
  end
end
