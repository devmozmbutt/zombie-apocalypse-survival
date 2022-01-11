# frozen_string_literal: true

module Users
  class SurvivorsController < ApplicationController
    def index
      @q = User.ransack(params[:q])
      @survivors = @q.result(distinct: true).survivor.except_survivor(current_user).includes(:inventories)
    end
  end
end
