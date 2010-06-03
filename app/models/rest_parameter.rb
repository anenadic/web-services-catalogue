# BioCatalogue: app/models/rest_parameter.rb
#
# Copyright (c) 2009, University of Manchester, The European Bioinformatics 
# Institute (EMBL-EBI) and the University of Southampton.
# See license.txt for details

class RestParameter < ActiveRecord::Base
  if ENABLE_CACHE_MONEY
    is_cached :repository => $cache
    index [ :submitter_type, :submitter_id ]
  end
  
  acts_as_trashable
  
  acts_as_annotatable
  
  validates_presence_of :name, 
                        :param_style
                        
  has_submitter
  
  validates_existence_of :submitter # User must exist in the db beforehand.

  if ENABLE_SEARCH
    acts_as_solr(:fields => [ :name, :description, :submitter_name, 
                              { :associated_service_id => :r_id },
                              { :associated_rest_method_id => :r_id } ] )
  end

  if USE_EVENT_LOG
    acts_as_activity_logged(:models => { :culprit => { :model => :submitter } })
  end

  # ===============
  # The :constrained_options field is a serialised array of values.
  # (See: http://www.salsaonrails.eu/2009/01/02/hash-serialization-in-an-activerecord-model for info)
  # ---------------
  
  serialize :constrained_options, Array
  
  def after_initialize
    self.constrained_options ||= [ ]
  end
  
  # ===============
  
  # get all the RestMethodParameters that use this RestParameter
  def rest_method_parameters
    RestMethodParameter.find_all_by_rest_parameter_id(self.id)
  end
  
  # For the given rest_method object, find duplicate entry based on 'param_name'
  def self.check_duplicate(rest_method, param_name, search_local_context=false)
    p = rest_method.request_parameters.find(:first, 
                                            :conditions => {:name => param_name, 
                                                            :is_global => !search_local_context})

    return p # RestParameter || nil
  end

  # Check that a given param exists for the given rest_service object
  def self.check_exists_for_rest_service(rest_service, param_name, search_local_context=false)
    param = nil
    
    rest_service.rest_resources.each do |resource|
      resource.rest_methods.each { |method| 
        param = RestParameter.check_duplicate(method, param_name, search_local_context)
        break unless param.nil?
      }
      break unless param.nil?
    end
    
    return param # RestParameter || nil
  end
  
  def associated_service_id
    BioCatalogue::Mapper.map_compound_id_to_associated_model_object_id(BioCatalogue::Mapper.compound_id_for(self.class.name, self.id), "Service")
  end

  def associated_rest_method_id
    return RestMethodParameter.find_by_rest_parameter_id(self.id).try(:rest_method_id)
  end

end
