require 'rubygems'
require 'test/unit'
require 'active_support/all'
require 'active_record'
require 'active_record/fixtures'
require 'action_controller'
require 'ruby-debug'
require 'ostruct'

require File.join(File.dirname(__FILE__), "..", "generators", "simple_audit_migration", "templates", "migration.rb")
require File.join(File.dirname(__FILE__), "..", "lib", "simple_audit")

ActiveRecord::Base.establish_connection({
  :adapter  => 'sqlite3',
  :database => ':memory:'
})

ActiveRecord::Migration.suppress_messages {
  ActiveRecord::Schema.define do
    suppress_messages do
      create_table "people", :force => true do |t|
        t.column "name",  :text
        t.column "email", :text
      end
      create_table "addresses", :force => true do |t|
        t.column "line_1", :text
        t.column "zip", :text
        t.column "type", :text
        t.references :person
      end
      create_table "users", :force => true do |t|
        t.column "name", :text
      end
    end
  end
  SimpleAuditMigration.migrate(:up)  
}

class Person < ActiveRecord::Base
  has_one :address
  simple_audit do |record|
    {
      :name => record.name,
      :address => { :line_1 => record.address.line_1, :zip => record.address.zip }
    }
  end
end

class Address < ActiveRecord::Base
  belongs_to :person
  simple_audit :username_method => :full_name
end

class HomeAddress < Address
  simple_audit :username_method => :short_name 
end

class User < ActiveRecord::Base
  def self.current; User.first ; end
  
  def name
    "name"
  end
  
  def full_name
    "full_name"
  end
  
  def short_name
    "short_name"
  end
  
end

User.create(:name => "some user")