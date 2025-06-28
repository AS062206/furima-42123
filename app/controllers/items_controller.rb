class ItemsController < ApplicationController
  
  def index
  end

  def new
    @item = Item.new

    @categories = Category.all
    @conditions = Condition.all
    @shipping_fees = ShippingFee.all
    @prefectures = Prefecture.all
    @shipping_durations = ShippingDuration.all
  end

  def create
  end

  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

end
