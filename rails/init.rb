require 'simple_audit'

%w{ models helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), '..', 'lib', 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

ActiveRecord::Base.send :include, Cubus::SimpleAudit
ActionController::Base.send :helper, :simple_audit
