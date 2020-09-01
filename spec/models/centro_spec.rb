require 'spec_helper'
require_relative '../../app/models/centro'
describe Centro do
  subject(:centro) { described_class.new('test', '0.0', '0.0', 1) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:latitud) }
    it { is_expected.to respond_to(:longitud) }
    it { is_expected.to respond_to(:id) }
  end
end
