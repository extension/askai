class CreateSources < ActiveRecord::Migration[8.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :provider
      t.boolean :is_human

      t.timestamps
    end
  end
end
