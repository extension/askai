class AddFullConversationThreadToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :full_conversation_thread, :text
  end
end
