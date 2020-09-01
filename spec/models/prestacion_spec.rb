require 'spec_helper'
require_relative '../../app/models/prestacion'
describe Prestacion do
  subject(:prestacion) { described_class.new('test', 1000, 1) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:costo) }
    it { is_expected.to respond_to(:id) }
  end
end
