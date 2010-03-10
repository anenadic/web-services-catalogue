# BioCatalogue: app/controllers/rest_representations_controller.rb
#
# Copyright (c) 2009, University of Manchester, The European Bioinformatics 
# Institute (EMBL-EBI) and the University of Southampton.
# See license.txt for details.

class RestRepresentationsController < ApplicationController
  before_filter :disable_action, :only => [ :index, :show, :edit ]

  before_filter :login_required
  
  before_filter :find_rest_representation, :only => [ :destroy ]
  before_filter :find_rest_method, :except => [ :destroy ]
  
  before_filter :authorise, :only => [ :destroy ]

  def new_popup     
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def add_new_representations    
    resource = @rest_method.rest_resource # for redirection
    service = resource.rest_service.service # for redirection
    
    count = @rest_method.add_representations(params[:rest_representations], current_user, :http_cycle => params[:http_cycle])
    
    respond_to do |format|
      flash[:notice] = "#{count} new representation" + (count==1 ? ' was':'s were') + ' added'
      format.html { redirect_to "#{service_url(service)}#rest_method_#{@rest_method.id}" }
    end
  end

  def destroy
    success_msg = "Representation <b>#{@rest_representation.content_type}</b> has been deleted"
    url_to_redirect_to = get_redirect_url()
    
    destroy_method_rep_map()
    
    is_not_used = RestMethodRepresentation.find(:all, :conditions => {:rest_representation_id => @rest_representation.id}).empty?
    @rest_representation.destroy if is_not_used
    
    respond_to do |format|
      flash[:notice] = success_msg
      format.html { redirect_to url_to_redirect_to }
      format.xml  { head :ok }
    end
  end
  
  
  # ========================================
  
  
  protected
  
  def authorise    
    unless BioCatalogue::Auth.allow_user_to_curate_thing?(current_user, @rest_representation, :rest_method => RestMethod.find(params[:rest_method_id]))
      error_to_back_or_home("You are not allowed to perform this action")
      return false
    end

    return true
  end

  
  # ========================================
  
  
  private
  
  def find_rest_method
    @rest_method = RestMethod.find(params[:rest_method_id])
  end

  def find_rest_representation
    @rest_representation = RestRepresentation.find(params[:id])
  end
  
  def get_redirect_url()
    method_rep_map = RestMethodRepresentation.find(:first, 
                         :conditions => {:rest_representation_id => @rest_representation.id, 
                         :rest_method_id => params[:rest_method_id]})

    rest_method = RestMethod.find(params[:rest_method_id])
    resource = rest_method.rest_resource
    service = resource.rest_service.service
        
    return "#{service_url(service)}#rest_method_#{params[:rest_method_id]}"
  end
  
  def destroy_method_rep_map() # USES params[:rest_method_id], params[:http_cycle], and @rest_representation.id
    method_rep_map = RestMethodRepresentation.find(:first, 
                         :conditions => {:rest_representation_id => @rest_representation.id, 
                         :rest_method_id => params[:rest_method_id],
                         :http_cycle => params[:http_cycle]})
    method_rep_map.destroy
  end

end