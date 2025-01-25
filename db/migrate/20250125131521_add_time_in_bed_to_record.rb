class AddTimeInBedToRecord < ActiveRecord::Migration[8.0]
  def change
    add_column :records, :time_in_bed, :integer
  end
end
