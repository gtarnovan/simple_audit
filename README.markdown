# simple_audit

Simple auditing solution for ActiveRecord models. Provides an easy way of creating audit logs for complex model associations.
Instead of storing audits for all data aggregated by the audited model, you can specify a serializable representation of the model.
    
  * a helper method is provided to easily display the audit log
  * the Audit object provides a #delta method which computes the differences between two audits

In a nutshell:

    class Booking < ActiveRecord::Base
      simple_audit do |record|
        # data to be audited
        {
            :price => record.price,
            :period => record.period, 
            ...
        }
      end
    end
    
    # in your view
    <%= render_audits(@booking) %>

# Why ?

simple_audit is intended as a straightforward auditing solution for complex model associations. 
In a normalized data structure (which is usually the case when using SQL), a core business model will aggregate data from several associated entities.
More often than not in such cases, only the core model is of interest from an auditing point of view. 

So instead of auditing every entity separately, with simple_audit you decide for each audited model what data needs to be audited. 
This data will be serialized on every model update and the available helper methods will render a clear audit trail.

![Screenshot of helper result](http://github.com/gtarnovan/simple_audit/raw/master/screenshot.png)

# Installation & Configuration

## Rails 2.3.x

### Gem

    # in your config/environment.rb    
    config.gem 'simple_audit'
        
    # then install if you don't already have it
    rake gems:install

### Plugin
  
    ./script/plugin install http://github.com/gtarnovan/simple_audit

### Post installation
    # generate & run migration
    ./script/generate simple_audit_migration
    rake db:migrate

## Rails 3
    # in your Gemfile
    gem 'simple_audit'
    
    # then install
    bundle install

### Post installation
    # generate & run migration
    rails generate simple_audit:migration
    rake db:migrate

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
    <%= render_audits(@booking) %>
    ...     

## Sample styling
      .audits {
      	clear: both;
      }
      .audit {
      	-moz-border-radius:8px;
        -webkit-border-radius: 8px;
        background-color: #dfdfdf;
        padding: 6px;
        margin-bottom: 8px;
      	font-size: 12px;
      }
      .audit .action, .audit .user, .audit .timestamp{
      	float: left;
      	margin-right: 6px;
      }
      .audit .changes {
      	clear: both;
      	white-space: pre;
      }

      .audit .current {
      	margin-left: 6px;
      }
      .audit .previous {
      	margin-left: 6px;
      	text-decoration: line-through;
      }  

# Assumptions and limitations

  * Your user model is called User and the current user User.current
    See [sentient_user](http://github.com/bokmann/sentient_user) for more information.

    
## Customize auditing

By default after each save, all model's attributes and `belongs_to` associations (their `id` and `to_s` on these) are saved in the audits table.
You can customize the data which is saved by supplying a block which will return all relevant data for the audited model.

    # app/models/booking.rb
    
    class Booking < ActiveRecord::Base
        simple_audit do |record|
          {
            :state  => record.state, 
            :price  => record.price.format,
            :period => record.period.to_s,
            :housing_units => record.housing_units.collect(&:name).join('; '),
            ...
            }
        end
        ...
    end
    
You can also customize the attribute of the User model which will be stored in the audit.

    # default is :name
    simple_audit :username_method => :email
    
## Rendering audit trail

A helper method for displaying a list of audits is provided. It will render a decorated list of the provided audits;
only the differences between revisions will be shown, thus making the audit information easily readable.

![Screenshot of helper result](http://github.com/gtarnovan/simple_audit/raw/master/screenshot.png)
    

Copyright (c) 2010 [Gabriel Târnovan, Cubus Arts](http://cubus.ro "Cubus Arts"), released under the MIT license
