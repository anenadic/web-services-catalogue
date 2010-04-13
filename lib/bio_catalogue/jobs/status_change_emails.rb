# BioCatalogue: lib/bio_catalogue/jobs/status_change_emails
#
# Copyright (c) 2009, University of Manchester, The European Bioinformatics 
# Institute (EMBL-EBI) and the University of Southampton.
# See license.txt for details

module BioCatalogue
  module Jobs
    class StatusChangeEmails < Struct.new(:subject, :text, :emails)
      def perform
        emails.each { |e| StatusChangeMailer.deliver_text_to_email(subject, text, e) }
      end    
    end
  end
end