

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

require_relative '../common/couch_db/couch_db'

require_relative '../common/utils/keys'
require_relative '../../lib/common/couch_model/lazy_reference'
require_relative '../common/couch_model/couchstruct'
require_relative '../common/couch_model/couch_model'
