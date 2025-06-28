class Item < ApplicationRecord
  has_one_attached :image

  private
  
  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)
  end

end
