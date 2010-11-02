module SimpleAudit #:nodoc:
  
  # Changes of the audited models will be stored here.
  class Audit < ActiveRecord::Base
    belongs_to :auditable,  :polymorphic => true
    belongs_to :user,       :polymorphic => true
    serialize  :change_log
  
    # Computes the differences of the change logs between two audits.
    #
    # Returns a hash containing arrays of the form 
    #   {
    #     :key_1 => [<value_in_other_audit>, <value_in_this_audit>],
    #     :key_2 => [<value_in_other_audit>, <value_in_this_audit>],
    #   } 
    def delta(other_audit)
    
      return self.change_log if other_audit.nil?
    
      {}.tap do |d|
        
        # first for keys present only in this audit
        (self.change_log.keys - other_audit.change_log.keys).each do |k|
          d[k] = [nil, self.change_log[k]]
        end
    
        # .. then for keys present only in other audit
        (other_audit.change_log.keys - self.change_log.keys).each do |k|
          d[k] = [other_audit.change_log[k], nil]
        end
    
        # .. finally for keys present in both, but with different values
        self.change_log.keys.each do |k|
          if self.change_log[k] != other_audit.change_log[k]
            d[k] = [other_audit.change_log[k], self.change_log[k]]
          end
        end
    
      end

    end
  end

end