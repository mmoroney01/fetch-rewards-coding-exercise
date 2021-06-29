class Transaction < ApplicationRecord
	validates :payer, { presence: true }
	validates :points, { presence: true } 
	validates :timestamp, { presence: true }
end
