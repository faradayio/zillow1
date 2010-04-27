module ApplicationHelper
  def link_to_zillow_statistical_area(statistical_area)
    link_to statistical_area.name, "http://www.zillow.com/homes/for_sale/#{statistical_area.name.sub(',', '').gsub(' ', '-')}/"
  end
end
