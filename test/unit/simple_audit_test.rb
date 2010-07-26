require 'test_helper'

class SimpleAuditTest < ActiveSupport::TestCase
  
  test "should audit entity creation" do
    assert_difference 'Audit.count', 2 do
      assert_difference 'Person.count', 2 do
        Person.create(:name => "Mihai Tarnovan", :email => "mihai.tarnovan@cubus.ro", :address => Address.new(:line_1 => "M. Viteazu nr. 11 sc. C ap.32"))
        Person.create(:name => "Gabriel Tarnovan", :email => "gabriel.tarnovan@cubus.ro", :address => Address.new(:line_1 => "Calea Lunga nr. 104 Sibiu 123500"))
      end
    end
  end
  
  test "should set correct action" do
    m = Person.create(:name => "Mihai Tarnovan", :email => "mihai.tarnovan@cubus.ro", :address => Address.new(:line_1 => "M. Viteazu nr. 11 sc. C ap.32"))
    assert_equal Audit.last.action, "create"
    m.name = "Mihai T."
    m.save
    assert_equal Audit.last.action, "update"
  end
  
  test "should audit only given fields" do
    m = Person.create(:name => "Mihai Tarnovan", :email => "mihai.tarnovan@cubus.ro", :address => Address.new(:line_1 => "M. Viteazu nr. 11 sc. C ap.32"))
    create_audit = Audit.last
    assert_difference 'Audit.count', 1 do
      m.email = "mihai.tarnovan@gmail.com"
      m.save
    end
    update_audit = Audit.last
    assert_equal update_audit.delta(create_audit), {}
  end
  
  test "should audit associated entity changes" do
    m = Person.create(:name => "Mihai Tarnovan", :email => "mihai.tarnovan@cubus.ro", :address => Address.new(:line_1 => "M. Viteazu nr. 11 sc. C ap.32", :zip => "550350"))
    create_audit = Audit.last
    assert_difference 'Audit.count', 1 do
      m.address = Address.new(:line_1 => "Bdul. Victoriei nr. 51", :zip => "550150")
      m.name = "Gigi Kent"
      m.email = "gigi@kent.ro"
      m.save
    end
    update_audit = Audit.last    
    assert_equal update_audit.delta(create_audit), { 
      :name => ["Mihai Tarnovan", "Gigi Kent"], 
      :address => [
        { :line_1 => "M. Viteazu nr. 11 sc. C ap.32", :zip => "550350" }, 
        { :line_1 => "Bdul. Victoriei nr. 51", :zip => "550150" }
      ]
    }
  end
  
end