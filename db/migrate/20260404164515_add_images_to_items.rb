class AddImagesToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :images, :text, array: true, default: []
  end
end
