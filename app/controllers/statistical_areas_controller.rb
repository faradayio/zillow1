class StatisticalAreasController < ApplicationController
  def index
    @leaderboard = StatisticalArea.leaderboard
  end
  
  def status
    
  end
end
