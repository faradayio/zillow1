class Appearance < ActiveRecord::Base
  set_primary_key :composite_identifier
  
  belongs_to :listing
  
  class << self
    def today
      scoped :conditions => { :appeared_at => Date.today.to_time..Date.today.tomorrow.to_time }
    end
    
    def on(day)
      scoped :conditions => { :appeared_at => date.to_time..date.tomorrow.to_time }
    end
  end

  validates_presence_of :appeared_at
end
