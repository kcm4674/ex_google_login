# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(request.env["omniauth.auth"], current_user) # ← 해당 함수 작성 시, app/models/user.rb의 def self.find_for_oauth 함수로 이동 (기존의 User 모델 내에 계정이 있는지 검사, 없으면 새로 계정 생성)
        
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:kakao, :naver, :facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
