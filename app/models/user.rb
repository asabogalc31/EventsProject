class User < ApplicationRecord
    has_many :events, dependent: :destroy
	
	validates :username, presence:true
	validates_uniqueness_of :username  

	validates :first_name, presence:true
	validates :last_name, presence:true
	validates :email, presence:true
	validates_uniqueness_of :email  
	validates :password, presence:true

	def self.authenticate(username, password)
		user = find_by(username: username)
		if user && user.password == password
			return user
		else
			nil
		end
	end
end
