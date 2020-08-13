module Api
	class EventsController < ApplicationController
		skip_before_action :verify_authenticity_token

        def show
			
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