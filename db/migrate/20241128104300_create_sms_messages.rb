class CreateSmsMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :sms_messages do |t|
      t.string :mobile_number
      t.string :message
      t.references :user

      t.timestamps
    end
  end
end
