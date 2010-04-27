Process.exit

ZWS_ID = 'X1-ZWz1c7urejqkgb_7x5fi'

# Retrieve recent for-sale listsings for Atlanta, GA in JSON:
'http://www.zillow.com/webservice/FMRWidget.htm?zws-id=X1-ZWz1c7urejqkgb_7x5fi&region=Atlanta+GA&status=forSale&status=makeMeMove&ranking=daysOnZillow&widget=fmrwidget_nfs&output=json'

# Retrieve recently-sold listings for Atlanta, GA in JSON:
# just use 'rsh' instead of 'nfs'

=begin
PAGES

homepage aka statistical_areas/index
------------------------------------

rankings table
  - place #
  - name (link to zillow listings)
  - avg annual footprint
  - time series footprint sparkline
  - (later: avg monthly energy cost)
  
overlaid time series line graphs
  - avg. home footprint: line for each SA
  - (later: avg monthly energy cost)
  
middleware promotional footer


later: statistical_areas/show
----------------------

overlaid time series line graphs
table of listings used

later: listings/show
----------------------

- big button to zillow listing
- attributes as parsed

=end
