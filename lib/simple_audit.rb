module Cubus
  module SimpleAudit
    
    def self.included(base)
      base.send :extend, ClassMethods
    end
  
    module ClassMethods
    
      # create a new Audit record
      # if no user is specified, try to use sentient_user's User.current

      def simple_audit(options = {})
        class_eval do 

          cattr_accessor :username_method
          self.username_method = (options[:username_method] || :name).to_s

          has_many :audits, :as => :auditable
          after_create {|record| audit(record, :create)}
          after_update {|record| audit(record, :update)}
        
        
        end
        send :include, InstanceMethods
      end
        
      def audit record, action = :update, user = nil
        user ||= User.current if User.respond_to?(:current)
        record.audits.create(:user => user, 
          :username => user.try(self.username_method), 
          :action => action.to_s, 
          :changes => record.audit_changes
        )
      end
    
    end
  
    module InstanceMethods
      def audit_changes
        self.attributes
      end
    end
  
  end

end

