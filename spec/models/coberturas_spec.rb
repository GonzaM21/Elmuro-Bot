require 'spec_helper'
require_relative '../../app/models/coberturas'
describe Coberturas do
  subject(:restricciones) { described_class.new }

  describe 'model' do
    it { is_expected.to respond_to(:medicamentos) }
    it { is_expected.to respond_to(:copago_visitas) }
    it { is_expected.to respond_to(:limite_visitas) }
  end
end
