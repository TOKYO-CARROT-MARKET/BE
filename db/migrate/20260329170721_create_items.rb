class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.integer :price
      t.string :category
      t.string :region
      t.string :pickup_type
      t.date :available_from
      t.date :departure_date
      t.string :status

      t.timestamps
    end
  end
end
