class Question < ApplicationRecord
  has_many :answers

  scope :approved, -> { where(approved: true) }
	scope :rejected, -> { where(status: 'rejected') }
	scope :pending, -> { where(status: 'pending') }

end
