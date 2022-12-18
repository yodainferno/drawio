class User < ApplicationRecord
  has_many :canvas
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
