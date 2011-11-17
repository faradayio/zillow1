require 'open-uri'
require 'httparty'

class ZillowSearch
  include HTTParty
  base_uri 'www.zillow.com/webservice'

  attr_accessor :region_name, :postings

  ZWS_ID = 'X1-ZWz1brt72uscnf_9k5bc'
  
  def initialize(r)
    @region_name = r
  end

  def makeMeMove; posting_group('makeMeMove'); end
  def forSaleByOwner; posting_group('forSaleByOwner'); end
  def forSaleByAgent; posting_group('forSaleByAgent'); end
  def reportForSale; posting_group('reportForSale'); end

  def posting_group(name)
    (postings[name] && postings[name]['result']) ? postings[name]['result'] : []
  end
  
  def perform
    data = self.class.get('/GetRegionPostings.htm', :query => {
      'zws-id' => ZWS_ID,
      'citystatezip' => region_name
    })
    self.postings = data['regionPostings']['response']
    makeMeMove + forSaleByOwner + forSaleByAgent + reportForSale
  end
  
  def results
    @results ||= perform
  end
end
