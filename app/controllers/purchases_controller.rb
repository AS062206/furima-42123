class PurchasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :redirect_if_item_purchased_or_seller, only: [:index, :create]

  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @purchase_address = PurchaseAddress.new
  end

  def create
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @purchase_address = PurchaseAddress.new(purchase_address_params)
    if @purchase_address.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def purchase_address_params
    params.require(:purchase_address).permit(
      :postal_code, :prefecture_id, :city, :address, :building, :phone_number, :token
    ).merge(user_id: current_user.id, item_id: @item.id)
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def redirect_if_item_purchased_or_seller
    if @item.purchase.present? || @item.user_id == current_user.id
      redirect_to root_path
    end
  end
end
