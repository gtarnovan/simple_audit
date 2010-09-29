class SimpleAuditMigrationGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.migration_template 'migration.rb', "db/migrate", :migration_file_name => 'simple_audit_migration'
    end
  end
  
end