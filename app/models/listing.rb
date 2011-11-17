class Listing < ActiveRecord::Base
  set_primary_key :zpid
  
  belongs_to :statistical_area
  has_many :appearances

  validates_presence_of :zpid

  def self.parse(data)
    data = data['property']
    return nil if data['usecode'] =~ /lot/ || data['usecode'] =~ /multi/ # skip irrelevant home types
    return nil if data['floorspace'].to_i > 10000 # skip excessively large properties
    return nil if data['bathrooms'].to_i > 20 # skip excessively large properties
    return nil if data['bedrooms'].to_i > 20 # skip excessively large properties

    zpid = data['zpid']
    listing = Listing.find_or_initialize_by_zpid(zpid)
    listing.zipcode = data['address']['zipcode']
    listing.bathrooms = data['bathrooms'].to_f.nonzero?
    listing.bedrooms = data['bedrooms'].to_i.nonzero?
    listing.floorspace = data['finishedSqFt'].to_i.nonzero?

    home_type = (data['useCode'] == 'unknown' ? nil : data['useCode'])
    listing.zillow_home_type = home_type

    listing
  end
  
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
