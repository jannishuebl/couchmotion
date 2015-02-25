

module Kernel
  def motion_require(_)

  end
end
require_relative 'couch_db/couch_db'
require_relative 'couch_db/double_couch_db/double_couch_db'
require_relative 'couch_db/document/double_document/double_document'
require_relative 'couch_db/view/double_view/double_view'
require_relative 'couch_db/query/double_query/double_query'
require_relative 'couch_db/enumerator/double_enumerator/double_enumerator'
require_relative 'couch_db/manager/double_manager/double_manager'

require_relative '../general/couch_db/couch_db_facade'
require_relative '../general/couch_db/couch_db_impl'

require_relative '../general/utils/couchstruct'
require_relative '../general/couch_model'
require_relative '../general/lazy_reference'
