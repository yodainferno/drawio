# frozen_string_literal: true

class Canva < ApplicationRecord
  belongs_to :user

  DEFAULT_NAME = 'NONAME'
  
  validates :name, :data, presence: { message: 'не может быть пустым' } 

  def paint(current_user)    
    result_null = {
      id: 0,
      name: DEFAULT_NAME,
      active: true,
      private_doc: true,
      creator: nil,
      data: '[]',
      is_it_my: true,
      opened: false
    }

    founded = Canva.find_by(id: id)
    return result_null unless founded

    {
      creator: founded.user.email,
      id: id.to_i,
      data: founded.data,
      name: founded.name,
      active: founded.active,
      private_doc: founded.private,
      is_it_my: founded.user_id == current_user.id ? current_user : false,
      opened: !founded.private && founded.active
    }


  end
end
