module Api
	class EventsController < ApplicationController
		def index
			@userId = User.where(token: request.headers["Authorization"]).first
			@events_by_user = Event.select('events.event_name, 
			c.name AS event_category,
			events.event_place, 
			events.event_address, 
			events.event_initial_date, 
			events.event_final_date, 
			t.name AS event_type,
			events.thumbnail')
			.joins(:user)
			.joins("INNER JOIN categories As c ON events.category_id = c.id")
			.joins("INNER JOIN type_events As t ON events.type_event_id = t.id")
			.where(users: {id: @userId.id})
			.all

			if !@userId.to_s.strip.empty?
				render json: @events_by_user.to_json()
			else
				render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
			end			
		end
		
		def show
			@userId = User.where(token: request.headers["Authorization"]).first
			@events_by_user = Event.select('events.id, 
			events.event_name, 
			c.name AS event_category,
			events.event_place, 
			events.event_address, 
			events.event_initial_date, 
			events.event_final_date, 
			t.name AS event_type,
			events.thumbnail')
			.joins(:user)
			.joins("INNER JOIN categories As c ON events.category_id = c.id")
			.joins("INNER JOIN type_events As t ON events.type_event_id = t.id")
			.where(users: {id: @userId.id}, events: {id: params[:id]})

			if !@userId.to_s.strip.empty?
				render json: @events_by_user.to_json(), status: :ok
			else
				render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
			end			
		end
		
		def create
			@user = User.where(token: request.headers["Authorization"]).first
			@category = Category.where(name:  params[:event_category]).first
			@ev_type = TypeEvent.where(name: params[:event_type]).first
			newEvent = Event.create(
				event_name: params[:event_name],
				event_place: params[:event_place],
				event_address: params[:event_address],
				event_initial_date: params[:event_initial_date],
				event_final_date: params[:event_final_date],
				thumbnail: params[:thumbnail],
				user_id: @user.id,
				category_id: @category.id,
				type_event_id: @ev_type.id
			)

			if !@userId.to_s.strip.empty? and newEvent.save
				render json: newEvent.to_json(), status: :created
			else
				render json:{status: 'ERROR', message:'Event not saved'}, status: :unprocessable_entity
			end
		end

		def update
			@user = User.where(token: request.headers["Authorization"]).first
			@category = Category.where(name:  params[:event_category]).first
			@ev_type = TypeEvent.where(name: params[:event_type]).first
			if !@user.to_s.strip.empty?
				newEvent = Event.where(id: params[:id])
				.update(
					event_name: params[:event_name],
					event_place: params[:event_place],
					event_address: params[:event_address],
					event_initial_date: params[:event_initial_date],
					event_final_date: params[:event_final_date],
					thumbnail: params[:thumbnail],
					user_id: @user.id,
					category_id: @category.id,
					type_event_id: @ev_type.id
				)

				render json: newEvent.to_json(), status: :accepted
			else
				render json:{status: 'ERROR', message:'Event not exist'}, status: :unprocessable_entity
			end				
		end
						
		def destroy
			@user = User.where(token: request.headers["Authorization"]).first
			event = Event.where(events: {user_id: @user.id}).where(events: {id: params[:id]})
			if !@user.to_s.strip.empty?
				event.delete_all
				render json:{status: 'SUCCES', message:'Event deleted'}, status: :ok
			else
				render json:{status: 'ERROR', message:'Event not exist to the user'}, status: :unprocessable_entity
			end	
		end

		private

		def event_params
			params.permit(
				:name,
				:location,
				:address,
				:initial_date,
				:final_date,
				:thumbnail
			);

		end
	end	
end