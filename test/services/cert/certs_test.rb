require 'katello_test_helper'

module Katello
  class CertsTest < ActiveSupport::TestCase
    include VCR::TestCase

    def setup
      @org = get_organization
      Resources::Candlepin::Owner.create(@org.label, @org.name)
      @original_ssl_ca_file = SETTINGS[:katello][:candlepin][:ca_cert_file]
    end

    def teardown
      Resources::Candlepin::Owner.destroy(@org.label)
      SETTINGS[:katello][:candlepin][:ca_cert_file] = @original_ssl_ca_file
    end

    def test_inspect_cert
      cert = File.read(File.join(Katello::Engine.root, "test/fixtures/certs/real-cert.crt"))
      assert_equal({ "1.2.840.113549.1.1.1" => "rsaEncryption" }, Cert::Certs.inspect_cert(cert))
    end

    def test_inspect_cert_uses_the_ml_dsa_long_name
      cert = OpenSSL::X509::Certificate.new(File.read(File.join(Katello::Engine.root, "test/fixtures/certs/real-cert.crt")))
      rsa_oid = OpenSSL::ASN1::ObjectId.new("1.2.840.113549.1.1.1").to_der
      ml_dsa_oid = OpenSSL::ASN1::ObjectId.new("2.16.840.1.101.3.4.3.17").to_der
      ml_dsa_cert = OpenSSL::X509::Certificate.new(cert.to_der.gsub(rsa_oid, ml_dsa_oid))

      assert_equal({ "2.16.840.1.101.3.4.3.17" => "ML-DSA-44" }, Cert::Certs.inspect_cert(ml_dsa_cert.to_pem))
    end

    def test_verify_ueber_cert_no_change
      store = OpenSSL::X509::Store.new
      OpenSSL::X509::Store.stubs(:new).returns(store)
      store.expects(:add_file).with(@original_ssl_ca_file).returns
      store.expects(:verify).returns(true)
      @org.expects(:regenerate_ueber_cert).never
      Cert::Certs.verify_ueber_cert(@org)
    end

    def test_verify_ueber_cert_changes
      SETTINGS[:katello][:candlepin][:ca_cert_file] = File.join("#{Katello::Engine.root}", "/ca/redhat-uep.pem")
      @org.expects(:regenerate_ueber_cert).once
      Cert::Certs.verify_ueber_cert(@org)
    end
  end
end
