module Api
    class UsersController < ApplicationController
        skip_before_action :verify_authenticity_token

        def create
            @user = User.new(user_params)
            
            respond_to do |format|
                if @user.save
                    flash[:notice] = 'Was successfully created.'
                    format.html { redirect_to('/') }
                    format.json { render json: @user.to_json(only: [:username, :first_name, :last_name, :email]), status: :created }
                else
                    flash[:error] = "Something went wrong"
                    format.html { render action: "new" }
                    format.json { render json:{status: 'ERROR', message:'User not saved', data:user.errors}, status: :unprocessable_entity }
                end
            end
        end
        
        private

        def user_params
            params.require(:user).permit(
                :username,
                :first_name,
                :last_name,
                :email,
                :password
            );

        end    
    end
end