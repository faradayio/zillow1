class EmissionEstimate < Weary::Base
  
  post 'emission' do |resource|
    resource.url = 'http://carbon.brighterplanet.com/residences.json'
    resource.requires = [ :'residence[zip_code][name]' ]
    resource.with = [ :'residence[floorspace_estimate]', :'residence[residence_class]' ]
  end

  class << self
    def of(listing)
      new.emission( :'residence[zip_code][name]' => listing.zipcode,
                    :'residence[floorspace_estimate]' => listing.floorspace,
                    :'residence[residence_class]' => listing.residence_class ).perform.parse['emission']
    end
  end
end
