class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total, precision: 10, scale: 2, default: 0.0, null: false
      t.string :status, default: 'pending', null: false
      t.datetime :ordered_at

      
      t.timestamps
    end
  end
end
