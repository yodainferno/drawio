# frozen_string_literal: true

# InfoController
class InfoController < ApplicationController
  before_action :authenticate_user!

  def about; end
end
