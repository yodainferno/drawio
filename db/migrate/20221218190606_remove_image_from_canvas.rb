class RemoveImageFromCanvas < ActiveRecord::Migration[7.0]
  def change
    remove_column :canvas, :preview
    add_column :canvas, :private, :boolean, :default => true
  end
end
