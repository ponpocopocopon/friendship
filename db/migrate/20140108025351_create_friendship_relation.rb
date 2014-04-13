class CreateFriendshipRelation < ActiveRecord::Migration
  def self.up
    create_table :friendship_relations do |t|
      t.integer :self_id
      t.integer :friend_id
      t.integer :level, default: 0
      t.timestamps
    end
    add_index :friendship_relations, [:self_id, :friend_id], :unique => true
    
  end

  def self.down
    drop_table :friendship_relations
  end
end
