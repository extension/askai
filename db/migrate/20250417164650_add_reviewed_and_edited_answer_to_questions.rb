class AddReviewedAndEditedAnswerToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :reviewed_and_edited_answer, :text
  end
end
