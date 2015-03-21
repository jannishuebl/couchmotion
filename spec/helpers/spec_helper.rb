if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'rspec'


def shared(desc, &block)
  RSpec.shared_examples desc, &block
end

require_relative 'hash'
require_relative '../../lib/double/double_db'
require_relative '../../specs/abstract_spec/abstract_couch_model_spec'
require_relative '../../specs/abstract_spec/abstract_couch_db_spec'
require_relative '../../specs/abstract_spec/abstract_document_spec'
require_relative '../../specs/abstract_spec/abstract_query_spec'
require_relative '../../specs/abstract_spec/abstract_view_spec'
require_relative '../../specs/abstract_spec/init_abstract_couchdb_spec'

