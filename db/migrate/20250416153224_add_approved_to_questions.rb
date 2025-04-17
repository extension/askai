class AddApprovedToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :approved, :boolean
  end
end
