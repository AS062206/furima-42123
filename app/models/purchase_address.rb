class PurchaseAddress
  include ActiveModel::Model

  attr_accessor :item_id, :user_id, :postal_code, :prefecture_id, :city, :address, :building, :phone_number, :token

  with_options presence: true do
    validates :item_id
    validates :user_id
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "is invalid. Enter it as follows (e.g., 123-4567)" }
    validates :city
    validates :address
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "is invalid. Enter only numbers" }
    validates :token
  end
  validates :prefecture_id, numericality: { other_than: 0, message: "can't be blank" }

  def save
    return false unless valid?

    begin
      Payjp.api_key = ENV['PAYJP_SECRET_KEY']
      Payjp::Charge.create(
        amount: item.price,
        card: token,
        currency: 'jpy'
      )
    rescue Payjp::PayjpError => e
      errors.add(:base, "決済に失敗しました: #{e.message}")
      return false
    end

    begin
      ActiveRecord::Base.transaction do
        purchase = Purchase.create!(item_id: item_id, user_id: user_id)
        Address.create!(
          postal_code: postal_code,
          prefecture_id: prefecture_id,
          city: city,
          address: address,
          building: building,
          phone_number: phone_number,
          purchase_id: purchase.id
        )
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each { |msg| errors.add(:base, msg) }
      false
    rescue => e
      errors.add(:base, "An unexpected error occurred: #{e.message}")
      false
    end
  end
  
  private

  def item
    @item ||= Item.find(item_id)
  end
end