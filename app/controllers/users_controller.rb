#
# users_controller.rb
# Copyright (C) 2023 tinix <tinix@archlinux>
#
# Distributed under terms of the MIT license.
#
class UsersController < ApplicationController
	before_action :authorize_request, except: [:create, :login]

	def create
		@user = User.new(user_params)
		if @user.save
			token = encode_token({ user_id: @user.id })
			render json: { user: @user, token: token }, status: :created
		else
			render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def login
		@user = User.find_by(email: params[:email])
		if @user&.authenticate(params[:password])
			token = encode_token({ user_id: @user.id })
			render json: { user: @user, token: token }, status: :ok
		else
			render json: { error: 'Invalid email or password' }, status: :unauthorized
		end
	end

	private

	def user_params
		params.permit(:name, :email, :password, :password_confirmation)
	end
end



