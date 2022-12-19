# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Static content', type: :system do
	LOGIN = 'test@1.mail';
	PASS = '1'*6;
	WRONG_PASS = '0'*6;

	def sign_up
		visit 'users/sign_up' # переходим на страницы ввода

		fill_in :user_email, with: LOGIN
		fill_in :user_password, with: PASS
		fill_in :user_password_confirmation, with: PASS

		find('input[type=submit]').click
	end

	def sign_in(login, password)
		fill_in :user_email, with: login
		fill_in :user_password, with: password

		find('input[type=submit]').click
	end

	# сценарий регистрации
	scenario 'sign up' do
		sign_up

		expect(find('body')).to have_text(LOGIN)
		expect(current_path).to eq('/')
	end

	# сценарий входа верного
	scenario 'sign in correct' do
		sign_up
		find('#logout').click
		expect(current_path).to eq('/users/sign_in')

		sign_in(LOGIN, PASS)

		expect(find('body')).to have_text(LOGIN)
		expect(current_path).to eq('/')
	end

	# сценарий входа верного
	scenario 'sign in wrond' do
		sign_up
		find('#logout').click
		expect(current_path).to eq('/users/sign_in')

		sign_in(LOGIN, WRONG_PASS)

		expect(current_path).to eq('/users/sign_in')
	end
end