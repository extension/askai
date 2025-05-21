class Question < ApplicationRecord
  has_many :answers

  scope :approved, -> { where(approved: true) }
	scope :rejected, -> { where(status: 'rejected') }
	scope :pending, -> { where(status: 'pending') }
	scope :without_images, -> { where(image_present: false) }

end
