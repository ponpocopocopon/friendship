class AddColumnKlassFromFriendshipRelation  < ActiveRecord::Migration
  def self.up
    remove_index :friendship_relations, [:self_id, :friend_id]
    add_column :friendship_relations, :klass, :string, after: :id
    add_index :friendship_relations, [:klass, :self_id, :friend_id], :unique => true
  end

  def self.down
    remove_index :friendship_relations, [:klass, :self_id, :friend_id]
    add_index :friendship_relations, [:self_id, :friend_id], :unique => true
    remove_column :friendship_relations, :klass
  end
end
