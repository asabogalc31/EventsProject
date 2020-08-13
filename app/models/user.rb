class User < ApplicationRecord
    validates :username, presence:true
	validates :first_name, presence:true
	validates :last_name, presence:true
	validates :email, presence:true
	validates :password, presence:true
end
