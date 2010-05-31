class Audit < ActiveRecord::Base
  belongs_to :auditable,  :polymorphic => true
  belongs_to :user,       :polymorphic => true
  serialize :changes
  
  #
  # returns the differences of the to audits
  # result is a hash containing arrays of the form [<value_in_other_audit>, <value_in_this_audit>]
  # the values in this audit take precedence
  #  
  def delta(other)
    
    return self.changes if other.nil?
    
    d = {}
    
    (self.changes.keys - other.changes.keys).each do |k|
      d[k] = [nil, self.changes[k]]
    end
    
    (other.changes.keys - self.changes.keys).each do |k|
      d[k] = [other.changes[k], nil]
    end
    
    self.changes.keys.each do |k|
      if self.changes[k] != other.changes[k]
        d[k] = [other.changes[k], self.changes[k]]
      end
    end
    
    d

  end
  
  def changes
    self[:changes]
  end
  
end
