class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table(:subscriptions) do |t|
      t.integer :user_id
      t.integer :plan_id
    end

    add_index :subscriptions, :user_id, :unique => true
  end
end