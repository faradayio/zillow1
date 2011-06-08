class Listing < ActiveRecord::Base
  set_primary_key :zpid
  
  belongs_to :statistical_area
  has_many :appearances

  validates_presence_of :zpid
  
  def calculate_emission!
    update_attributes! :emission => EmissionEstimate.of(self)
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
  
  class << self
    def zpid_from_url(url)
      url.match(/(\d*)_zpid/)[1].to_i
    end
  end
end
