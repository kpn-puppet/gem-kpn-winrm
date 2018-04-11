require 'spec_helper'
RSpec.describe KpnWinrm do
  before :each do
    Windows::Host.stubs(:default).returns(
      'options' => {
        'ssh' => {
          'user' => 'Administrator',
          'password' => 'RootRoot',
        },
      },
    )
  end
  let(:pp) do
    <<-PP
      file{ 'testfile.txt' :
        ensure => present,
      }
    PP
  end

  # it 'apply_manifest_on_winrm' do
  #   expect(described_class.winrm_command(default, pp, catch_failures: true)).to eql('to be defined')
  # end
end
