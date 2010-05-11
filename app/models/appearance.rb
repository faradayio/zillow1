class Appearance < ActiveRecord::Base
  set_primary_key :composite_identifier
  
  belongs_to :listing
  
  named_scope :today, :conditions => { :appeared_at => Date.today.to_time..Date.today.tomorrow.to_time }
  named_scope :on, lambda { |date| { :conditions => { :appeared_at => date.to_time..date.tomorrow.to_time } } }
end
