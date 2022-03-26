class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :user_id, default: "", null: false
      t.string :password_digest, default: "", null: false

      t.timestamps
    end
  end
end
