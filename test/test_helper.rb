require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_support/test_case'
require 'active_record'
require 'active_record/fixtures'
require 'action_controller'
require 'ruby-debug'
require 'ostruct'

require File.join(File.dirname(__FILE__), "..", "generators", "simple_audit_migration", "templates", "migration.rb")
require File.join(File.dirname(__FILE__), "..", "lib", "app", "models", "audit")
require File.join(File.dirname(__FILE__), "..", "rails", "init")

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
        t.references :person
      end
      create_table "users", :force => true do |t|
        t.column "name", :text
      end
    end
  end
  CreateAudits.migrate(:up)  
}

class Person < ActiveRecord::Base
  has_one :address
  simple_audit
  def audit_changes
    {
      :name => self.name,
      :address => { :line_1 => self.address.line_1, :zip => self.address.zip }
    }
  end
end

class Address < ActiveRecord::Base
  belongs_to :person
end

class User < ActiveRecord::Base
  def self.current; User.first ; end
end

User.create(:name => "some user")