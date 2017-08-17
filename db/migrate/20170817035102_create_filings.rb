class CreateFilings < ActiveRecord::Migration[5.0]
  def change
    create_table :filings do |t|
      t.string :name
      t.string :ticker
      t.integer :year
      t.integer :quarter
      t.integer :total_rev
      t.timestamps
    end
  end
end
