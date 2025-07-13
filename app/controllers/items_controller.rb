class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_item, only: [:show, :edit, :update]

  def index
    @items = Item.order(created_at: :desc)
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
    @item = Item.new(item_params)

    if @item.save
      redirect_to root_path
    else
      @categories = Category.all
      @conditions = Condition.all
      @shipping_fees = ShippingFee.all
      @prefectures = Prefecture.all
      @shipping_durations = ShippingDuration.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    unless current_user == @item.user
      redirect_to root_path
    end

    @categories = Category.all
    @conditions = Condition.all
    @shipping_fees = ShippingFee.all
    @prefectures = Prefecture.all
    @shipping_durations = ShippingDuration.all
  end

  def update
    unless current_user == @item.user
      redirect_to root_path
    end

    if @item.update(item_params)
      redirect_to item_path(@item)
    else
      @categories = Category.all
      @conditions = Condition.all
      @shipping_fees = ShippingFee.all
      @prefectures = Prefecture.all
      @shipping_durations = ShippingDuration.all
      render :edit
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :name,
      :description,
      :category_id,
      :condition_id,
      :shipping_fee_id,
      :prefecture_id,
      :shipping_duration_id,
      :price,
      :image
    ).merge(user_id: current_user.id)
  end
end
