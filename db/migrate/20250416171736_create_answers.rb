class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :question, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true
      t.text :text
      t.text :html_response
      t.string :author
      t.integer :display_order
      t.boolean :user_submitted
      t.string :submitted_by
      t.boolean :approved

      t.timestamps
    end
  end
end

# NOTE:
# display_order is a static integer used to consistently randomize
# the display position of an answer (e.g., Answer A, B, C...).
# This helps prevent bias and ensures answer order is consistent
# across users once a question is published.