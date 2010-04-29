module ApplicationHelper
  def link_to_zillow_statistical_area(statistical_area)
    link_to statistical_area.name, "http://www.zillow.com/homes/for_sale/#{statistical_area.name.sub(',', '').gsub(' ', '-')}/"
  end
  
  def safe_dom_id(obj)
    dom_id(obj).gsub(/[^a-zA-Z0-9_]/, '')
  end
end
