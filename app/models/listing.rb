class Listing < ActiveRecord::Base
  set_primary_key :zpid
  
  belongs_to :statistical_area
  
  def calculate_emission!
    update_attributes :emission => EmissionEstimate.of(self)
  end
  
  def residence_class
    case zillow_home_type
    when 'condo'
      'Apartment in a building with 5 or more units'
    when 'manufactured'
      'Mobile home (manufactured home, trailer)'
    when 'singleFamily'
      'Single-family detached house (a one-family house detached from any other house)'
    end
  end
  
  def full_bathrooms
    bathrooms.floor
  end
  
  def half_bathrooms
    (bathrooms % 1 * 2).ceil
  end
  
  class << self
    def zpid_from_url(url)
      url.match(/(\d*)_zpid/)[1].to_i
    end
  end
end