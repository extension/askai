class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.integer :faq_id
      t.string :title
      t.text :text
      t.string :state
      t.string :county
      t.datetime :original_asked_at

      t.timestamps
    end
  end
end
