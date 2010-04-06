class ZillowSearch
  require 'open-uri'
  require 'json'
  
  attr_reader :region_name
  
  def initialize(r)
    @region_name = r
  end
  
  def perform
    JSON.parse(open("http://www.zillow.com/webservice/FMRWidget.htm?zws-id=X1-ZWz1c7urejqkgb_7x5fi&region=#{region_name}&status=forSale&status=makeMeMove&ranking=daysOnZillow&widget=fmrwidget_nfs&output=json").read)['response']['results']  
  end
  
  def results
    @results ||= perform
  end
end
