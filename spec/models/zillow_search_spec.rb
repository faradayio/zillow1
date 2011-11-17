require 'spec_helper'
require 'vcr'

describe ZillowSearch do
  describe '#perform' do
    it 'fetches zillow postings for the current city' do
      results = []
      search = ZillowSearch.new 'Minneapolis-St. Paul, MN'
      VCR.use_cassette('minneapolis', :record => :once) do
        results = search.perform
      end

      results.count.should == 99
    end
  end
end

