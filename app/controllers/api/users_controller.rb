module Api
	class UsersController < ApplicationController
		skip_before_action :verify_authenticity_token

		def create
			user = User.new(user_params);

			if user.save
  				render json: user.to_json(only: [:username, :first_name, :last_name, :email]), status: :created
			else
				render json:{status: 'ERROR', message:'User not saved', data:user.errors}, status: :unprocessable_entity
			end
		end

		private

		def user_params
			params.permit(
				:username,
				:first_name,
				:last_name,
				:email,
				:password
			);

		end
	end	
end