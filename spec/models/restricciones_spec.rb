require 'spec_helper'
require_relative '../../app/models/restricciones'
describe Restricciones do
  subject(:restricciones) { described_class.new(1, 1, 100, true) }

  describe 'model' do
    it { is_expected.to respond_to(:hijos_max) }
    it { is_expected.to respond_to(:edad_min) }
    it { is_expected.to respond_to(:edad_max) }
    it { is_expected.to respond_to(:conyuge) }
  end

  describe 'tiene_alguna_restriccion' do
    it 'devuelve false Si no tiene restricciones' do
      restricciones = described_class.new(nil, nil, nil, nil)
      expect(restricciones.tiene_alguna_restriccion?).to be false
    end

    it 'devuelve true Si tiene restriccion' do
      restricciones = described_class.new(10, nil, nil, nil)
      expect(restricciones.tiene_alguna_restriccion?).to be true
    end
  end
end
