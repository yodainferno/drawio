class AddForeignKeyToCanvas < ActiveRecord::Migration[7.0]
  def change
    add_reference :canvas, :user
  end
end
