class Event < ApplicationRecord
    validates :name, presence:true
	validates :location, presence:true
	validates :address, presence:true
    validates :initial_date, presence:true
    validates :final_date, presence:true
    validates :thumbnail, presence:true

    belongs_to :user
    has_one :category
    has_one :event_type
end
