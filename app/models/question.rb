class Question < ApplicationRecord
  has_many :answers

  scope :approved, -> { where(approved: true) }
	scope :rejected, -> { where(status: 'rejected') }
	scope :pending, -> { where(status: 'pending') }

	def promote_reviewed_answer_to_answer!(source:)
	  return if reviewed_and_edited_answer.blank?
	  return if answers.exists?(source_id: source.id)

	  answers.create!(
	    source: source,
	    text: reviewed_and_edited_answer,
	    author: "System (auto-promoted)",
	    approved: true,
	    user_submitted: false,
	    display_order: 1
	  )
	end
end
