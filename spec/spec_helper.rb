
# Spec preparations, copied from couchrest model

require "bundler/setup"
require "rubygems"
require "rspec"

require File.join(File.dirname(__FILE__), '..','lib','couchrest_localised_properties')
# check the following file to see how to use the spec'd features.

unless defined?(COUCHHOST)
  COUCHHOST = "http://127.0.0.1:5984"
  TESTDB    = 'couchrest-localised-test'
  TEST_SERVER    = CouchRest.new COUCHHOST
  TEST_SERVER.default_database = TESTDB
  DB = TEST_SERVER.database(TESTDB)
end

class Basic < CouchRest::Model::Base
  use_database TEST_SERVER.default_database
end

def reset_test_db!
  DB.recreate! rescue nil 
  DB
end

RSpec.configure do |config|
  config.before(:all) { reset_test_db! }
  config.after(:all) do
    cr = TEST_SERVER
    test_dbs = cr.databases.select { |db| db =~ /^#{TESTDB}/ }
    test_dbs.each do |db|
      cr.database(db).delete! rescue nil
    end
  end
end
