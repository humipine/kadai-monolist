class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save { self.email.downcase! }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
             format: { with: VALID_EMAIL_REGEX },
             uniqueness: { case_sensitvive: false }
  validates :password, presence: true, length: { minimum: 6 }
  
  has_many :ownerships
  has_many :items, through: :ownerships
  
  # Userが、wantを通して、複数のItemオブジェクトと関連している。
  has_many :wants, class_name: 'Want'
  has_many :want_items, through: :wants, class_name: 'Item', source: :item
  # Userが Haveを通して、複数のItemオブジェクトと関連していることを表している
  has_many :havings, class_name: 'Have'
  has_many :having_items, through: :havings, class_name: 'Item', source: :item
  
  
  
  
  # ハッシュ化されたパスワード
  has_secure_password

  
  def want(item)
    @item_id = item.id
    @owns = self.havings.where(item_id: item.id)
    @rec_count = @owns.count
    if @rec_count > 0
      self.delete_from_having(item)
      @count_have = 0
    end

    self.wants.find_or_create_by(item_id: item.id)
    @count_want = self.want_items.count
    
  end
  
  def unwant(item)
    want = self.wants.find_by(item_id: item.id)
    want.destroy if want
    @count_want = 0
    @count_have = 0
    
  end
  
  def want?(item)
    self.want_items.include?(item)
  end
  
  # Want→ Haveに変更する＝ほしいものを手に入れる
  def buy(item)
    
    @owns = self.wants.where(item_id: item.id)
    @rec_count = @owns.count
    if @rec_count > 0
      self.unwant(item)
      @count_want = 0
    end
    
    self.havings.find_or_create_by(item_id: item.id)
    @count_have = self.having_items.count

  end
  
  # Haveを削除する（つまり捨てる）
  def delete_from_having(item)
    having = self.havings.find_by(item_id: item.id)
    having.destroy if having
    
    @count_have = 0
    @count_want = 0
    
  end
  
  # 持っているかどうか確認する
  def having?(item)
    self.having_items.include?(item)
  end
  
end
