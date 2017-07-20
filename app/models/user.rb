class User < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true

  # Overiding as_json to avoid sending out password hashes
  def as_json(_opts = {})
    { id: id, username: username }
  end

  # Ordinarily, these methods could go into a concern called Tokenizable
  # but for simplicity I have put them in the user model as this is the
  # only resource to tokenize

  # Decrypts a JSON web token, extracts user id and finds the user
  def self.from_token(token)
    jwt_data = JWT.decode token, User.secret_key, true, { :algorithm => 'HS256' }
    user_data = jwt_data.first
    user_id = user_data['id']
    # :find_by because we don't necessarily want to throw an error
    User.find_by(id: user_id)
  rescue JWT::DecodeError
    nil
  end

  # Gives an encrypted JSON web-token of the user
  def to_jwt
    @jwt ||= JWT.encode({ id: id }, User.secret_key, 'HS256')
  end

  private

  def self.secret_key
    ENV['SECRET_KEY_BASE']
  end
end
