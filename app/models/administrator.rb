class Administrator < ApplicationRecord
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable


  def name
  	return self.email 
  end
end
