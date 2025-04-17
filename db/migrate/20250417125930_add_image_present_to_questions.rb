class AddImagePresentToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :image_present, :boolean
  end
end
