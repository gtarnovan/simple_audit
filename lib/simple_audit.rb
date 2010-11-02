require 'active_record'
require 'action_view'

require 'simple_audit/simple_audit'
require 'simple_audit/audit'
require 'simple_audit/helper'

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, SimpleAudit::Model
end

if defined?(ActionView::Base)
  ActionView::Base.send :include, SimpleAudit::Helper
end