class AddColoumnToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :user_activated, :boolean, default: false
  end
end
