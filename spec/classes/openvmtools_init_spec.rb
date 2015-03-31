require 'spec_helper'

describe 'openvmtools', :type => 'class' do

  context 'on a non-supported osfamily' do
    let(:params) {{}}
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'foo'
    }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported osfamily, non-vmware platform' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'foo',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7.0',
      :operatingsystemmajrelease => '7'
    }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported osfamily, vmware platform, non-supported operatingsystem' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '6.0',
      :operatingsystemmajrelease => '6'
    }
    end
    it { should_not contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should_not contain_service('vmtoolsd') }
  end

  context 'on a supported osfamily, vmware platform, default parameters' do
    let(:params) {{}}
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7.0',
      :operatingsystemmajrelease => '7'
    }
    end
    it { should contain_package('open-vm-tools') }
    it { should_not contain_package('open-vm-tools-desktop') }
    it { should contain_service('vmtoolsd') }
  end

  context 'on a supported operatingsystem, vmware platform, custom parameters' do
    let :facts do {
      :virtual                   => 'vmware',
      :osfamily                  => 'RedHat',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '7.0',
      :operatingsystemmajrelease => '7'
    }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent' }}
      it { should contain_package('open-vm-tools').with_ensure('absent') }
      it { should contain_service('vmtoolsd').with_ensure('stopped') }
    end

    describe 'with_desktop => true' do
      let(:params) {{ :with_desktop => true }}
      it { should contain_package('open-vm-tools-desktop').with_ensure('present') }
    end
  end

end
