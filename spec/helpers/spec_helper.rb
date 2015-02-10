require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require 'rspec'
def shared(desc, &block)
  RSpec.shared_examples desc, &block
end
require_relative '../../specs/abstract_spec/abstract_couch_db_spec'
require_relative '../../specs/abstract_spec/abstract_document_spec'
require_relative '../../specs/abstract_spec/abstract_query_spec'
require_relative '../../specs/abstract_spec/abstract_view_spec'
require_relative '../../specs/abstract_spec/init_abstract_couchdb_spec'
require_relative '../../lib/double/double_db'

