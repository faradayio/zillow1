class Listing < ActiveRecord::Base
  set_primary_key :zpid
  
  belongs_to :statistical_area
  
  def calculate_emission!
    update_attributes :emission => EmissionEstimate.of(self)
  end
  
  class << self
    def zpid_from_url(url)
      url.match(/(\d*)_zpid/)[1].to_i
    end
  end
end
