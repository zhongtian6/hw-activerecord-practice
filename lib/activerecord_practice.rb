require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where("first = 'Candice'")
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where("email LIKE '%@%'")
  end
  # etc. - see README.md for more details

  def self.with_dot_org_email
    # return only customers with email addresses containing .org
    Customer.where("email LIKE '%@%.org'")
  end

  def self.with_invalid_email
    # return only customers with invalid email addresses (no @) but not blank
    Customer.where("email IS NOT NULL")
            .where("email <> ''")
            .where("email NOT LIKE '%@%'")
  end

  def self.with_blank_email
    # return only customers with blank email addresses
    Customer.where("email = '' OR email IS NULL")
  end

  def self.born_before_1980
    # return only customers born before 1980
    Customer.where("birthdate < '#{Time.parse("1980-01-01")}'")
  end

  def self.with_valid_email_and_born_before_1980
    # return only customers with valid email and born before 1980
    Customer.where("email LIKE '%@%'")
            .where("birthdate < '#{Time.parse("1980-01-01")}'")
  end

  def self.last_names_starting_with_b
    # return only customers with last name starting with b sort by birthdate
    Customer.where("last LIKE 'B%'")
            .order("birthdate")
  end

  def self.twenty_youngest
    # return first 20 youngest customers
    Customer.order("birthdate DESC")
            .limit(20)
  end

  def self.update_gussie_murray_birthdate
    # Update Gussie Murray's birthdate to Feb 08, 2004
    Customer.where("first = 'Gussie' AND last = 'Murray'")
            .update(birthdate: Time.parse("2004-02-08"))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email NOT LIKE '%@%'")
            .update(email: '')
  end

  def self.delete_meggie_herman
    Customer.where("first = 'Meggie' AND last = 'Herman'")
            .delete_all
  end

  def self.delete_everyone_born_before_1978
    Customer.where("birthdate < '#{Time.parse("1978-01-01")}'")
            .delete_all
  end
end
