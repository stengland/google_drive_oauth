require 'google_drive_oauth'
require 'vcr'
require 'pry'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

describe GoogleDrive::OAuth do
  let(:my_options) {{
    client_id: '478899299614-91kb33lr539o6rjgb513l75q9gktap6s.apps.googleusercontent.com',
    client_secret: '4TrXN3ksEWrQ_VBPV60BezwP',
    refresh_token: '1/WVbj1g9SSTIUCSwfPqxnTi1eKYji0JpmFglNF2_ivJI'
  }}
  subject(:google_drive_oauth) { GoogleDrive::OAuth.new(my_options) }

  describe 'auth_url' do
    it "is a google account url" do
      expect(subject.auth_url).to eq 'https://accounts.google.com/o/oauth2/auth?client_id=478899299614-91kb33lr539o6rjgb513l75q9gktap6s.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive+https%3A%2F%2Fspreadsheets.google.com%2Ffeeds%2F'
    end
  end

  describe '#get_token', vcr: true do
    it 'fetches a new token from google' do
      my_code = '4/ALCU_YJmxE-ciVtbtX0kjI40tOJ8YNuK3Upg_0hMC2A.8mqF_IZbG-sUWmFiZwPfH03fnvqFmQI'
      expect(google_drive_oauth.get_token(my_code)).to be_a OAuth2::AccessToken
    end
  end

  describe '#drive_session', vcr: true do
    it 'loads and returns a drive session' do
      expect(google_drive_oauth.drive_session).to be_a GoogleDrive::Session
    end
  end

end
