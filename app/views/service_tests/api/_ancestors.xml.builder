# BioCatalogue: app/views/service_tests/api/_ancestors.xml.builder
#
# Copyright (c) 2010, University of Manchester, The European Bioinformatics 
# Institute (EMBL-EBI) and the University of Southampton.
# See license.txt for details

# <ancestors>
parent_xml.ancestors do
  
  # <service>
  parent_xml.service nil, 
    { :resourceName => display_name(service_test.service, false), :resourceType => "Service" },
    xlink_attributes(uri_for_object(service_test.service), :title => xlink_title("The parent Service that this test belongs to"))
  
end