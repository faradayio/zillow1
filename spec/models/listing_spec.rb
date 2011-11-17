require 'spec_helper'
require 'crack/xml'

describe Listing do
  describe '.parse' do
    let(:data) do
      d = Crack::XML.parse(<<-XML)
<result><lastRefreshedDate>2011-11-16 18:02:16.152</lastRefreshedDate><property><zpid>2044967</zpid><links><homedetails>http://www.zillow.com/homedetails/1709-Selby-Ave-Saint-Paul-MN-55104/2044967_zpid/</homedetails></links><address><street>1709 Selby Ave</street><zipcode>55104</zipcode><city>Saint Paul</city><state>MN</state><latitude>44.946814</latitude><longitude>-93.172508</longitude></address><useCode>Single Family</useCode><lotSizeSqFt>4356</lotSizeSqFt><finishedSqFt>1408</finishedSqFt><bathrooms>2.0</bathrooms><bedrooms>5</bedrooms></property><images><count>0</count></images><price>210000</price></result>
      XML
      d['result']
    end

    it 'parses a standard listing' do
      listing = Listing.parse(data)
      listing.zpid.should == 2044967
      listing.zipcode.should == '55104'
      listing.bathrooms.should == 2.0
      listing.bedrooms.should == 5
      listing.floorspace.should == 1408
      listing.zillow_home_type.should == 'Single Family'
    end
    it 'skips irrelevant home types' do
      data['property']['usecode'] = 'multiFamily home'
      Listing.parse(data).should be_nil
    end
    it 'skips excessively large properties by floorspace' do
      data['property']['floorspace'] = 9999999
      Listing.parse(data).should be_nil
    end
    it 'skips excessively large properties by bathrooms' do
      data['property']['bathrooms'] = 9999999
      Listing.parse(data).should be_nil
    end
    it 'skips excessively large properties by bedrooms' do
      data['property']['bedrooms'] = 9999999
      Listing.parse(data).should be_nil
    end
  end
end

