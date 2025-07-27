FactoryBot.define do
  factory :purchase_address, class: 'PurchaseAddress' do

    item_id        { 1 } 
    user_id        { 1 }
    postal_code    { '123-4567' }
    prefecture_id  { 14 } # 1（---）以外
    city           { '横浜市緑区' }
    address        { '青山1-1-1' }
    building       { '〇〇ビル103' }
    phone_number   { '09012345678' }
    token          { 'tok_abcdefg12345' }
  end
end