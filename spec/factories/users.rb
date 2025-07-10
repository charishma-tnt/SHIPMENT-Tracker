FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :admin do
      admin { true }
      role { "admin" }
    end

    trait :customer do
      role { "customer" }
      after(:create) do |user|
        user.customer = create(:customer, email: user.email, name: "Customer #{user.email.split('@').first}")
        user.save
      end
    end

    trait :delivery_partner do
      role { "delivery_partner" }
      after(:create) do |user|
        user.delivery_partner = create(:delivery_partner, name: "Delivery Partner #{user.email.split('@').first}")
        user.save
      end
    end
  end
end
