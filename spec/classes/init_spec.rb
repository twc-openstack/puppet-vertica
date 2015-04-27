require 'spec_helper'
describe 'vertica' do

  context 'with defaults for all parameters' do
    it { should contain_class('vertica') }
  end
end
