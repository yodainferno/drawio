class CreateCanvas < ActiveRecord::Migration[7.0]
  def change
    create_table :canvas do |t|
      t.string :name, default: 'noname' 
      t.text :data, null: false
      t.boolean :active, default: true
      t.text :preview

      t.timestamps
    end
  end
end
 