require 'spec_helper'
require_relative '../../app/models/afiliado'

describe Afiliado do
  subject(:afiliado) { described_class.new('test', 1, 'pepe', 1, 1, 5, true) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:edad) }
    it { is_expected.to respond_to(:usuario) }
    it { is_expected.to respond_to(:plan_id) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:cant_hijos) }
    it { is_expected.to respond_to(:tiene_conyuge) }
  end
end
