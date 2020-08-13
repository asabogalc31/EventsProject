class User < ApplicationRecord
	has_many :events, dependent: :destroy
	
    validates :username, presence:true
	validates :first_name, presence:true
	validates :last_name, presence:true
	validates :email, presence:true
	validates :password, presence:true
end
