module Api
    class SessionsController < ApplicationController
        skip_before_action :verify_authenticity_token

        def index
        end

        def create
            @user = User.authenticate(login_params[:username], login_params[:password])
            respond_to do |format|
                if !@user.to_s.strip.empty?
                    token = generate_token
                    session[:user_id] = token
                    @user.update(token: token)
                    format.html { redirect_to controller: "events", action: "index" }      
                    format.json { render json: {:token => generate_token}, status: :ok }
                else
                    flash[:login_errors] = ['El usuario o contraseña es incorrecta.']
                    format.html { redirect_to root_path }       
                    format.json { render json:{status: 'ERROR', message:'User not found'}, status: :unprocessable_entity }             
                end
            end
        end

        def destroy
          session[:user_id] = nil
          redirect_to root_url, notice: "Logged out!"
        end

        private

        def generate_token
            SecureRandom.hex(20)
        end

        def login_params
            params.require(:user).permit(:username, :password)
        end
    end
end