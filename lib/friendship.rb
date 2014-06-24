require "friendship/engine"
module Friendship
  class Relation < ActiveRecord::Base
    module Levels
      #BLOCK     = -2
      CANCEL    = -1 
      PENDING   = 0
      NORMAL    = 1
    end

    scope :by_friend, -> {where("level >= ?", Levels::NORMAL)}
  
    # create friendship-level instances
    Levels.constants.each do |level_sym|
      class_eval <<-EOS
        def #{level_sym.to_s.downcase}?
          self.level == #{Levels.const_get(level_sym)}
        end
        scope :by_#{level_sym.to_s.downcase}, -> { where(level: #{Levels.const_get(level_sym)}) }
      EOS
    end
  
    def allow!
      if self.pending?
        self.level = Levels::NORMAL
        self.save!
      end
    end
  
    def deny!
      if self.pending?
        self.level = Levels::CANCEL
        self.save!
      end
    end
  
    #def block!
    #  self.level = Levels::BLOCK
    #  self.save!
    #end
  end

  module Model
    def self.included(base)
      base.class_variable_set(:@@require_friend_recognition, false) # フレンド登録に認証が必要か？
      base.class_variable_set(:@@possible_simplex_friend, false) # 一方的なフレンドが可能か？
      base.has_many :friendships, -> { where(klass: base) }, foreign_key: :self_id, class_name: "Friendship::Relation"
      base.extend(ClassMethods)
    end 

    
    module ClassMethods
      def set_require_friend_recognition
        self.class_variable_set(:@@require_friend_recognition, true)
      end
      def require_friend_recognition?
        self.class_variable_get(:@@require_friend_recognition)
      end
      def set_possible_simplex_friend
        self.class_variable_set(:@@possible_simplex_friend, true)
      end
      def possible_simplex_friend?
        self.class_variable_get(:@@possible_simplex_friend)
      end
    end

    def send_pending_friends
      ids = self.friendships.by_pending.pluck(:friend_id)
      self.class.where(id: ids)
    end

    def receive_pending_friends
      ids = Relation.where(friend_id: self.id).pluck(:self_id)
      self.class.where(id: ids)
    end

    def allow_friend!(user)
      pending_friendship = user.friendships.where(friend_id: self.id).first
      if pending_friendship
        pending_friendship.allow!
        unless self.class.possible_simplex_friend?
          self.friendships.create(klass: self.class, friend_id: user.id, level: Relation::Levels::NORMAL)
        end
      end
    end

    def deny_friend!(user)
      pending_friendship = self.friendships.where(friend_id: user.id).first
      pending_friendship.deny! if pending_friendship
    end

    #def block_users 
    #  self.friendships.by_block.pluck(:friend_id)
    #  self.class.where(id: ids)
    #end

    def friends
      ids = self.friendships.by_friend.pluck(:friend_id)
      self.class.where(id: ids)
    end

    def friend!(user)
      friend_ship = self.friendships.create(klass: self.class, friend_id: user.id)
      # 認証が不要なら直後に許可する
      user.allow_friend!(self) unless self.class.require_friend_recognition?
    end

    def unfriend!(user)
      self.friendships.where(friend_id: user.id).delete_all
      user.friendships.where(friend_id: self.id).delete_all unless self.class.possible_simplex_friend?
    end

    def friend?(user)
      self.friendships.where(friend_id: user.id).by_friend.exists?
    end

    def friend_by?(user)
      user.friend?(self)
    end

    #def block?(user)
    #  self.friendships.where(friend_id: user.id).by_pending.exists?
    #end

    #def block_by?(user)
    #  user.block?(self)
    #end

  end
end
