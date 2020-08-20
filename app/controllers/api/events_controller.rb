module Api
	class EventsController < ApplicationController
		skip_before_action :verify_authenticity_token

		def index
			@userId = User.find_by(token: session[:user_id])
			@events = Event.select('events.id,
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
			.where(users: {id: @userId.id})
			.all
			
			respond_to do |format|
				if !@userId.to_s.strip.empty?
					format.html { render controller: "events", action: "index" }      
                    format.json { render json: @events.to_json(), status: :ok }					
				else
					render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
				end	
			end
		end
		
		def show
			@userId = User.find_by(token: session[:user_id])
			@event = Event.select(
				'events.id, 
				events.event_name, 
				c.name AS event_category,
				events.event_place, 
				events.event_address, 
				events.event_initial_date, 
				events.event_final_date, 
				t.name AS event_type,
				events.thumbnail'
			).joins(:user)
			.joins("INNER JOIN categories As c ON events.category_id = c.id")
			.joins("INNER JOIN type_events As t ON events.type_event_id = t.id")
			.where(users: {id: @userId.id}, events: {id: params[:id]})

			respond_to do |format|
				if !@userId.to_s.strip.empty?
					format.html { render controller: "events", action: "show" }      
                    format.json { render json: @events_by_user.to_json(), status: :ok }					
				else
					render json:{status: 'ERROR', message:'Token invalid'}, status: :unprocessable_entity
				end	
			end
		end
		
		def new
		end

		def create
			@userId = User.find_by(token: session[:user_id])
			@event = Event.create(
				event_name: params[:event_name],
				event_place: params[:event_place],
				event_address: params[:event_address],
				event_initial_date: params[:event][:event_initial_date],
				event_final_date: params[:event][:event_final_date],
				thumbnail: params[:thumbnail],
				user_id: @userId.id,
				category_id: params[:event_category],
				type_event_id: params[:event_type]
			)

			respond_to do |format|
				if @event.save
					format.html { redirect_to controller: "events", action: "index" }      
                    format.json { render json: @event.to_json(), status: :created }					
				else
					format.html { render controller: "events", action: "new" } 
					format.json { render json:{status: 'ERROR', message:'Event not saved'}, status: :unprocessable_entity }					
				end	
			end
		end
		
		def edit
			@event = Event.find(params[:id])
		end

		def update
			@user = User.find_by(token: session[:user_id])
			@event = Event.where(id: params[:id])
				.update(
					event_name: params[:event_name],
					event_place: params[:event_place],
					event_address: params[:event_address],
					event_initial_date: params[:event_initial_date],
					event_final_date: params[:event_final_date],
					thumbnail: params[:thumbnail],
					user_id: @user.id,
					category_id: params[:event_category],
					type_event_id: params[:event_type]
				)

			respond_to do |format|
				if @event
					format.html { redirect_to controller: "events", action: "index" }      
					format.json { render json: @event.to_json(), status: :accepted }	
				else
					format.html { render controller: "events", action: "edit" } 
					format.json { render json:{status: 'ERROR', message:'Event not saved'}, status: :unprocessable_entity }					
				end
			end		
		end
			
		def delete

		end 

		def destroy
			@user = User.find_by(token: session[:user_id])
			@event = Event.where(events: {user_id: @user.id}).where(events: {id: params[:id]})
			respond_to do |format|
				if !@user.to_s.strip.empty?
					@event.delete_all
					format.html { redirect_to controller: "events", action: "index" }       
					format.json { render json:{status: 'SUCCES', message:'Event deleted'}, status: :ok }
				else
					format.json { render json:{status: 'ERROR', message:'Event not exist to the user'}, status: :unprocessable_entity }
				end	
			end
		end

		private

		def event_params
			params.permit(
				:event_name,
				:event_place,
				:event_address,
				:event_initial_date,
				:event_final_date,
				:thumbnail
			);
		end
	end	
end