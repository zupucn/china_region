class CreateChinaRegions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :china_regions do |t|
      t.string :code, null: false
      t.string :name
      t.timestamps
    end

    add_index :china_regions, :code, unique: true
    add_index :china_regions, :name
  end

  def self.down
    drop_table :china_regions
  end
end
