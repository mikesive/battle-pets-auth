FactoryGirl.define do
  factory :user do
    # Ordinarily one should use something like Faker for
    # generating fake data like emails, urls etc
    username 'testuser'
    password_digest SecureRandom.hex(32)
  end
end
