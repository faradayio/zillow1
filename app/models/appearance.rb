class Appearance < ActiveRecord::Base
  set_primary_key :composite_identifier
  
  belongs_to :listing
  
  class << self
    def today
      scoped :conditions => { :appeared_at => Date.today.to_time..Date.today.tomorrow.to_time }
    end
    
    def on(day)
      day = Time.parse day if day.is_a?(String)
      scoped :conditions => { :appeared_at => day.to_time..day.tomorrow.to_time }
    end
  end

  validates_presence_of :appeared_at
end
