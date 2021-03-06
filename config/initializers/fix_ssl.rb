require 'open-uri'
require 'net/https'

module Net
  class HTTP
    alias_method :original_use_ssl=, :use_ssl=

    def use_ssl=(flag)
      self.ca_file = '/etc/ssl/certs/Root_CA_Generalitat_Valenciana.crt'
      self.verify_mode = OpenSSL::SSL::VERIFY_PEER
      self.original_use_ssl = flag
    end
  end
end