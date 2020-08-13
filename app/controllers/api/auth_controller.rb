module Api
	class AuthController < ApplicationController
		skip_before_action :verify_authenticity_token

		def create;
			@user = User.where(username: params[:username]).first
			if @user.password == params[:password]
                token = generate_token
                @user.update(token: token)
                render json: {token: token}
            else
                render json:{status: 'ERROR', message:'User not found', data:@user.errors}, status: :unprocessable_entity
			end
		end

		private

		def generate_token
		  SecureRandom.hex(10)
        end

        def auth_token
            params.require(:username, :password)
        end
	end
end