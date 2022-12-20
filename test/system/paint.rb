# frozen_string_literal: true

require 'rails_helper'

USER1_LOGIN = '1@test.ru'
USER1_PASS = '1' * 6

USER2_LOGIN = '2@test.ru'
USER2_PASS = '2' * 6

RSpec.describe 'Static content', type: :system do
  def sign_in(login, pass)
    visit 'users/sign_up' # переходим на страницы ввода

    fill_in :user_email, with: login
    fill_in :user_password, with: pass
    fill_in :user_password_confirmation, with: pass

    find('input[type=submit]').click

    expect(find('body')).to have_text(login)
    expect(current_path).to eq('/')
  end

  # создание картины
  scenario 'sign up' do
    sign_in(USER1_LOGIN, USER1_PASS)

    visit 'paint'

    expect(current_path).to eq('/paint')

    find('input[type=submit]').click

    expect(page).to have_field('out_link', with: 'http://localhost:3000/show/1')
  end
end
