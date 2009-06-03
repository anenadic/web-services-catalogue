# BioCatalogue: app/controllers/favourites_controller.rb
#
# Copyright (c) 2009, University of Manchester, The European Bioinformatics 
# Institute (EMBL-EBI) and the University of Southampton.
# See license.txt for details.

#=====
# This extends the Favourites controller defined in the Favourites plugin.
#=====

require_dependency RAILS_ROOT + '/vendor/plugins/favourites/lib/app/controllers/favourites_controller'

class FavouritesController < ApplicationController
  
  # Disable some of the actions provided in the controller in the plugin.
  before_filter :disable_action, :only => [ :index, :show, :edit ]
  
end