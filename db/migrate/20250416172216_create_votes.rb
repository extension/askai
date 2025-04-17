class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.references :question, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.string :voter_session_id
      t.integer :guessed_answer_id
      t.boolean :guessed_human_correctly

      t.timestamps
    end
  end
end
