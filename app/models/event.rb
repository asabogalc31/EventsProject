class Event < ApplicationRecord
    validates :event_name, presence:true
	validates :event_place, presence:true
	validates :event_address, presence:true
    validates :event_initial_date, presence:true
    validates :event_final_date, presence:true
    validates :thumbnail, presence:true

    belongs_to :user
    has_one :category
    has_one :type_event
end
