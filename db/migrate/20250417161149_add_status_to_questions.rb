class AddStatusToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :status, :string, default: "draft"
  end
end
