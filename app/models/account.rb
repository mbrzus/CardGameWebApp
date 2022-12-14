class Account < ActiveRecord::Base
  has_secure_password
  before_save :create_session_token
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 6 }
  validate :email_is_a_valid_address

  def self.create_account!(param_hash)
    param_hash[:email].downcase!
    Account.create!(param_hash)
  end

  def self.create_from_omniauth!(auth)
    create! do |account|
      account.provider = auth['provider']
      account.uid = auth['uid']
      account.oauth_username = auth['info']['nickname'] if account.provider == 'twitter'
      account.oauth_username = auth["info"]["email"] if account.provider == 'google_oauth2'
      account.username = account.oauth_username << '@' << account.provider
      account.email = 'oauthuser@email.com'
      account.password = 'AuthPassword!1'
    end
  end

  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

  def email_is_a_valid_address
    errors.add(:email, 'must be a valid address') unless email.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\Z/i)
  end

  def error_message
    error_message = ''
    %i[name username email password].each do |param|
      errors[param].each do |e|
        unless error_message.include?("#{param.to_s.capitalize} #{e}")
          error_message << "#{param.to_s.capitalize} #{e}, "
        end
      end
    end
    error_message.chomp(', ')
  end

end