class User < ActiveRecord::Base
    has_many :microposts, dependent: :destroy
    before_save { self.email = email.downcase }
    before_create :create_ramdom_token
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
        uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, length: { minimum: 6 }

    def User.new_rememner_token
        SecureRandom.urlsafe_base64
    end

    def User.encrypt(token)
        Digest::SHA1.hexdigest token.to_s
    end

    def create_ramdom_token
        self.remember_token = User.encrypt(User.new_rememner_token)
    end
    private :create_ramdom_token

    def feed
        # このコードは準備段階
        # 11章で完成する
        Micropost.where("user_id = ?", id)
    end
end
