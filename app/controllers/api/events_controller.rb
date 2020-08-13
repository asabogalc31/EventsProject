module Api
	class EventsController < ApplicationController
		def index
			@userId = User.where(token: request.headers["Authorization"]).first
			@events_by_user = Event.select('events.name AS event_name, 
			c.name AS event_category,
			events.location AS event_place, 
			events.address AS event_address, 
			events.initial_date AS event_initial_date, 
			events.final_date AS event_final_date, 
			e.name AS event_typed,
			events.thumbnail')
			.joins(:user)
			.joins("INNER JOIN categories As c ON events.category_id = c.id")
			.joins("INNER JOIN event_types As e ON events.event_type_id = e.id")
			.where(users: {id: @userId.id})

			if !@userId.to_s.strip.empty?
				render json: @events_by_user.to_json()
			else
				render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
			end			
		end
		
		def show
			@userId = User.where(token: request.headers["Authorization"]).first
			@events_by_user = Event.select('events.id, 
			events.name AS event_name, 
			c.name AS event_category,
			events.location AS event_place, 
			events.address AS event_address, 
			events.initial_date AS event_initial_date, 
			events.final_date AS event_final_date, 
			e.name AS event_typed,
			events.thumbnail')
			.joins(:user)
			.joins("INNER JOIN categories As c ON events.category_id = c.id")
			.joins("INNER JOIN event_types As e ON events.event_type_id = e.id")
			.where(users: {id: @userId.id}, events: {id: params[:id]})

			if !@userId.to_s.strip.empty?
				render json: @events_by_user.to_json()
			else
				render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
			end			
		end
		
		def create
			@user = User.where(token: request.headers["Authorization"]).first
			@category = Category.where(name:  params[:event_category]).first
			@ev_type = EventType.where(name: params[:event_typed]).first
			newEvent = Event.create(
				name: params[:name],
				location: params[:location],
				address: params[:address],
				initial_date: params[:initial_date],
				final_date: params[:final_date],
				thumbnail: params[:thumbnail],
				user_id: @user.id,
				category_id: @category.id,
				event_type_id: @ev_type.id
			)

			if newEvent.save
				render json: newEvent.to_json()
			else
				render json:{status: 'ERROR', message:'Event not saved'}, status: :unprocessable_entity
			end
		end

		def update
			@user = User.where(token: request.headers["Authorization"]).first
			@category = Category.where(name:  params[:event_category]).first
			@ev_type = EventType.where(name: params[:event_typed]).first
			newEvent = Event.update(
				id: params[:id],
				name: params[:name],
				location: params[:location],
				address: params[:address],
				initial_date: params[:initial_date],
				final_date: params[:final_date],
				thumbnail: params[:thumbnail],
				user_id: @user.id,
				category_id: @category.id,
				event_type_id: @ev_type.id
			)

			render json: newEvent.to_json()
		end
						
		def destroy
			@user = User.where(token: request.headers["Authorization"]).first
			event = Event.where(events: {user_id: @user.id}).where(events: {id: params[:id]})
			if !@user.to_s.strip.empty?
				event.delete_all
				render json:{status: 'SUCCES', message:'Event deleted'}
			else
				render json:{status: 'ERROR', message:'Event not exist'}, status: :unprocessable_entity
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