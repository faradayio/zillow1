class EmissionEstimate < Weary::Base
  
  post 'emission' do |resource|
    resource.url = 'http://carbon.brighterplanet.com/residences.json'
    resource.requires = [ :'residence[zip_code][name]' ]
    resource.with = [ :'residence[floorspace_estimate]', :'residence[residence_class][name]', :'residence[bedrooms]', :'residence[bathrooms]' ]
  end

  class << self
    def of(listing)
      request = { :'residence[zip_code][name]' => listing.zipcode }
      request[:'residence[floorspace_estimate]'] = listing.floorspace.square_feet.to(:square_meters) if listing.floorspace
      request[:'residence[bedrooms]'] = listing.bedrooms if listing.bedrooms
      request[:'residence[bathrooms]'] = listing.bathrooms if listing.bathrooms
      request[:'residence[residence_class][name]'] = listing.residence_class if listing.residence_class
      new.emission(request).perform.parse['emission']
    end
  end
end
