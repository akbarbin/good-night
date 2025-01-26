class RenameClockInAtAndClockOutAtToRecords < ActiveRecord::Migration[8.0]
  def up
    rename_column :records, :clock_in_at, :clocked_in_at
    rename_column :records, :clock_out_at, :clocked_out_at
  end

  def down
    rename_column :records, :clocked_in_at, :clock_in_at
    rename_column :records, :clocked_out_at, :clock_out_at
  end
end
