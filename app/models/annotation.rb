# BioCatalogue: app/models/annotation.rb
#
# Copyright (c) 2009, University of Manchester, The European Bioinformatics 
# Institute (EMBL-EBI) and the University of Southampton.
# See license.txt for details.

#=====
# This extends the Annotation model defined in the Annotations plugin.
#=====

require_dependency RAILS_ROOT + '/vendor/plugins/annotations/lib/app/models/annotation'

class Annotation < ActiveRecord::Base
  acts_as_trashable
  
  if USE_EVENT_LOG
    acts_as_activity_logged :models => { :culprit => { :model => :source },
                                         :referenced => { :model => :annotatable } }
  end
  
  if ENABLE_SEARCH
    acts_as_solr(:fields => [ :value ] )
  end
end