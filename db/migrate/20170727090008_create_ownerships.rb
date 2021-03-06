class CreateOwnerships < ActiveRecord::Migration[5.0]
  def change
    create_table :ownerships do |t|
      t.string :type
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
      
      # user_idと item_id、そして、typeの組み合わせでuniqueであること
      t.index [:user_id, :item_id, :type], unique: true
    end
  end
end
