class ShowController < ApplicationController
  def show
    @status = ''

    @id = params['id']   
    @data = '[]'
    @creator = ''
    @name = ''


    if @id
      founded = Canva.find_by(id: @id)
      if founded
        if (founded.active && !founded.private) || (current_user && founded.user_id == current_user.id)
          @status = ''
          if !(founded.active && !founded.private)
            @status = "#{t(:yours_art)}! <a href='/paint/#{@id}'>#{t(:fix)}</a>"        
          end
          @data = founded.data
          @creator = founded.user.email
          @name = founded.name
        else
          # @status = "act #{founded.active} pr #{founded.private}; #{founded.user_id} == #{current_user.id}"
          if !founded.active
            @status = t(:show_status_deleted)        
          elsif founded.private
            @status = t(:show_status_private)            
          end
        end
          
      else
        @status = t(:show_status_404)
      end
    end
  end
end
