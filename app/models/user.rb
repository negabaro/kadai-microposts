class User < ApplicationRecord
  
  before_save { self.email.downcase! }
  #validates :name, presence: true, length: { maximum: 50 }
  #validates :email, presence: true, length: { maximum: 255 },
  #                  forma: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
  #                  uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  
  has_many :reverse_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationship, source: :user
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  
  has_many :favorites
  has_many :active_favorite, through: :favorites, source: :user  #
  has_many :favorite_micropost, through: :favorites, source: :micropost  #
  
  def add_favorite(micropost)
    unless self.microposts == micropost
      self.favorites.find_or_create_by(micropost_id: micropost.id)
    end
  
  end
  
  def cancel_favorite(micropost)
    favorite = self.favorites.find_or_create_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end

  def likes
    #Microsoft.where()
    #Micropost.where(id: self.favorite_ids) < NG
    self.favorite_micropost
    
  end
  
  #あるユーザーがあるpostをお気に入りしたかチェック
  def is_favorite?(ohter_micropost)
    self.likes.include?(ohter_micropost)
  end
  

  
  
  
  
end
