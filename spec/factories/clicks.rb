FactoryBot.define do
  factory :click do
    link
    ip_address { "127.0.0.1" }
    user_agent { "Mozilla/5.0" }
  end
end
