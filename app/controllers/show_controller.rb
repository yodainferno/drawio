# frozen_string_literal: true

# ShowController
class ShowController < ApplicationController
  def show
    default_params
    return unless @id

    founded = Canva.find_by(id: @id)
    return @status = t(:show_status404) unless founded

    if (founded.active && !founded.private) || master_of?(founded)
      success_params(founded)
    elsif !founded.active
      @status = t(:show_status_deleted)
    elsif founded.private
      @status = t(:show_status_private)
    end
  end

  private

  def master_of?(founded)
    current_user && founded.user_id == current_user.id
  end

  def default_params
    @status = ''
    @id = params['id']
    @data = ''
    @creator = ''
    @name = ''
  end

  def success_params(founded)
    @status = ''
    @status = "#{t(:yours_art)}! <a href='/paint/#{@id}'>#{t(:fix)}</a>" unless founded.active && !founded.private
    @data = founded.data
    @creator = founded.user.email
    @name = founded.name
  end
end
