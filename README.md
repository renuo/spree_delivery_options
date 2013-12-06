Your Grocer Spree Delivery Date 
=================

This gem is a fork from [spree_delivery_date](from 'https://github.com/sgringwe/spree_delivery_date'), and it has been updated to work with spree_core 2.1.3, as well as other changes. 

Requires user to enter a delivery date during checkout (delivery section).

* Shows delivery date during checkout confirmation.
* Shows delivery date when viewing or editing order as admin.
* Allows admin to filter orders by delivery date (date range).
* Allows admin to sort orders by delivery date.
* Adds delivery date column to orders index page table.


Installing
=======

Add the gem to your Gemfile

    $ gem 'yg_spree_delivery_date'

bundle with
  
    $ bundle update

and run

    $ rails g yg_spree_delivery_date:install

to install and (be asken to) run the migrations. This migration simply adds the delivery_date field to Spree::Order.

