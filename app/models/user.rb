class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  def self.find_for_oauth(auth, current_user)
        # 이미 있는 계정인지 확인한다.
        email = auth.info.email
        user = User.where(:email => email).first
        
        if not self.where(email: auth.info.email).exists?
            # 계정이 없다면 새로운 데이터를 생성한다.
            if user.nil?
                user = User.new(name: auth.info.name, email: email ? auth.info.email : "#{auth.uid}@#{auth.provider}.com", password: Devise.friendly_token[0,20])
                user.save!
            end
        end
    user
  end
end
