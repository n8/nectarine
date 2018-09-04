class CreateSnails < ActiveRecord::Migration[5.2]
  def change
    create_table :snails do |t|

      t.timestamps
    end
  end
end
