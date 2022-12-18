class CanvasController < ApplicationController
  DEFAULT_NAME = "NONAME"

  def paint
    @id = 0; @name = DEFAULT_NAME; @active = true; @private_doc = true
    @is_it_my = true
    
    @data = '[]'

    if params['id']
      id = params['id']

      founded = Canva.find_by(id: id)
      @is_it_my = founded.user_id == current_user.id

      if founded
        @id = founded.id
        @data = founded.data
        @name = founded.name
        @active = founded.active
        @private_doc = founded.private
      end
    end
  end

  def save_paint
    id = 0; name = ''; active = true; private_doc = true
    data = params['line_points']
        
    if data
      id = params['id'] ? params['id'] : 0
      name = params['name'] ? params['name'] : DEFAULT_NAME
      active = !(params['active'] == '0')
      private_doc = !(params['private'] == '0')

      canva = User.find_by(id: current_user.id).canvas.find_by(id: id)
      if canva
        # обновление, если уже есть такая
        canva.update(
          name: name,
          data: data,
          active: active,
          private: private_doc,
        )
      else
        # новая конва
        new_canva = User.find_by(id: current_user.id).canvas.create(
          name: name,
          data: data,
          active: active,
          private: private_doc,
        )
        id = new_canva.id
      end
    end

    if id != 0
      redirect_to "/paint/#{id}"
    end
  end

  def my
    @data = User.find_by(id: current_user.id).canvas.order(active: :desc, id: :desc).limit(100)
    @show_deleted = true
    render 'gallery'
  end

  def gallery
    @show_deleted = false
    @data = Canva.all().where('active = TRUE AND private = FALSE').order(id: :desc).limit(100)
  end
end
