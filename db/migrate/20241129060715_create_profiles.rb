class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :email
      t.string :phoneno
      t.string :username
      t.string :bio
      t.string :password_digest
      
      t.references :user

      t.timestamps
    end
  end
end
