class CreateRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :records do |t|
      t.datetime :clock_in_at
      t.datetime :clock_out_at
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
