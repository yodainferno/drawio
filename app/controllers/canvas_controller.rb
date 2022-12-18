class CanvasController < ApplicationController
  def paint
    @data = '[]'
    @id = 0
    if params['id']
      founded = Canva.find_by(id: params['id'])
      @data = founded.data if founded
      @id = params['id']
    end
  end

  def save_paint
    @status = false
    @id = 0
    if params['line_points']

      canva = Canva.find_by(id: params['id']) # todo проверка на то, что ты - владелец
      if canva
        # обновление, если уже есть такая
        canva.update(data: params['line_points'])
      else
        # новая конва
        new_canva = User.find_by(id: current_user.id).canvas.create(
          name: 'new work',
          data: params['line_points'],
          active: true
        )
        @id = new_canva.id
      end
      @status = true
    end

    if @id != 0
      redirect_to "/paint/#{@id}"
    end
  end

  def my
    @data = User.find_by(id: current_user.id).canvas.order(id: :desc).limit(10)
    render 'gallery'
  end

  def gallery
    @data = Canva.all().where('active = TRUE').order(id: :desc).limit(10)
  end
end
