class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :name
      t.string :description
      t.references :certificates, index: true
      t.boolean :can_be_rented_by_other_companies, default: false
      t.integer :rental_price_pr_day

      t.timestamps
    end
  end
end
