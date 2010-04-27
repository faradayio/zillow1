class StatisticalAreasController < ApplicationController
  def index
    @leaderboard = StatisticalArea.leaderboard
  end
end
