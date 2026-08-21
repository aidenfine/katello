module Cert
  module Certs
    def self.ueber_cert(organization)
      organization.debug_cert
    end

    def self.ca_cert
      File.read(Setting[:ssl_ca_file])
    end

    def self.candlepin_client_ca_cert
      File.read(backend_ca_cert_file(:candlepin))
    end

    def self.ssl_client_cert
      @ssl_client_cert ||= OpenSSL::X509::Certificate.new(File.read(ssl_client_cert_filename))
    end

    def self.ssl_client_cert_filename
      Setting[:ssl_certificate]
    end

    def self.ssl_client_key
      @ssl_client_key ||= OpenSSL::PKey.read(File.read(ssl_client_key_filename))
    end

    def self.ssl_client_key_filename
      Setting[:ssl_priv_key]
    end

    def self.backend_ca_cert_file(backend)
      SETTINGS.dig(:katello, backend, :ca_cert_file) || Setting[:ssl_ca_file]
    end

    def self.verify_ueber_cert(organization)
      ueber_cert = OpenSSL::X509::Certificate.new(self.ueber_cert(organization)[:cert])
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_file backend_ca_cert_file(:candlepin)
      organization.regenerate_ueber_cert unless cert_store.verify ueber_cert
    end

    # cert_mapping takes in a File and will return a hash with the key being an OID and the value being the human readable name.
    def self.cert_mapping(cert)
      certificate = OpenSSL::X509::Certificate.new(cert)
      tbs_certificate = OpenSSL::ASN1.decode(certificate.to_der).value.first

      # fields array will have the structure of this.
      # 0 version [0] MAY EXIST
      # 1 serialNumber
      # 2 signature
      # 3 issuer
      # 4 validity
      # 5 subject
      # 6 subjectPublicKeyInfo

      fields = tbs_certificate.value
      # version offset compensates the index number so if version does not exist we still resolve the correct oid index
      version_offset = fields.first.tag_class == :CONTEXT_SPECIFIC ? 0 : -1
      algorithm_oid = fields[6 + version_offset].value.first.value.first
      algorithm_name = algorithm_oid.ln

      { algorithm_oid.oid => algorithm_name }
    end
  end
end
