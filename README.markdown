# SimpleAudit

Simple auditing solution for ActiveRecord models. Provides an easy way of creating audit logs for complex model associations.
Instead of storing audits for all data aggregated by the audited model, you can specify a serializable representation of the model.
    
  * a helper method is provided to easily display the audit log
  * the Audit object provides a #delta method which computs the differences between two audits

# Installation & Configuration

## As a gem
    
    gem install simple_audit

and require it
    
    config.gem 'simple_audit'

## As a plugin
  
    ./script/plugin install http://github.com/gtarnovan/simple_audit

## Database

Create a migration with this content:

    class CreateAudits < ActiveRecord::Migration
      def self.up
        create_table :audits do |t|
          t.belongs_to :auditable,  :polymorphic => true
          t.belongs_to :user,       :polymorphic => true

          t.string :username
          t.string :action
          t.text   :changes
          t.timestamps

        end

        add_index :audits, [:auditable_id, :auditable_type], :name => 'auditable_index'
        add_index :audits, [:user_id, :user_type], :name => 'user_index'
        add_index :audits, :created_at    
      end

      def self.down
        drop_table :audits
      end
    end
    

# Usage

Audit ActiveRecord models. Somewhere in your (backend) views show the audit logs.
    
    # in your model
    # app/models/booking.rb
    
    class Booking < ActiveRecord::Base
        simple_audit
        ...
    end
    
    # in your view
    # app/views/bookings/booking.html.erb
    
    ...
    <%= render_audits(@booking.audits) %>
    ...     

# Assumptions and limitations

  * Your user model is called User and the current user User.current
    See [sentient_user](http://github.com/bokmann/sentient_user) for more information.

  * You have to write your own tests (fow now)
  

    
## Customize auditing

By default after each save, all model's attributes are saved in the audits table.
You can customize the data which is saved by overriding the audit_changes method. All relevant data for the audited model should be included here.

    # app/models/booking.rb
    
    class Booking < ActiveRecord::Base
        simple_audit
    
        def audit_changes
          {
            :state  => self.state, 
            :price  => self.price.format,
            :period => self.period.to_s,
            :housing_units => housing_units.collect(&:name).join('; '),
            ...
            }
        end
        ...
    end
    
You can also customize the attribute of the User model which will be stored in the audit.

    # default is :name
    simple_audit :username_method => :email
    
## Rendering audit 

A helper method for displaying a list of audits is provided. It will render a decorated list of the provided audits;
only the differences between revisions will be shown, thus making the audit information easily readable.

![Screenshot of helper result](/screenshot.png)
    

Copyright (c) 2010 [Gabriel Târnovan, Cubus Arts](http://cubus.ro "Cubus Arts"), released under the MIT license
