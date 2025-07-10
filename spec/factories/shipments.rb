FactoryBot.define do
  factory :shipment do
    customer { nil }
    source { "MyString" }
    target { "MyString" }
    item_details { "MyText" }
    status { "MyString" }
    delivery_partner { nil }
  end
end
