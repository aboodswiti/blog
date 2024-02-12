class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :display_in_nav

      t.timestamps
    end
  end
end