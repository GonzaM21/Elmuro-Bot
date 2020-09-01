require 'spec_helper'
require_relative '../../app/models/plan'
require_relative '../../app/models/restricciones'
describe Plan do
  subject(:plan) { described_class.new('test', 100, 'restricciones', -1) }

  describe 'model' do
    it { is_expected.to respond_to(:nombre) }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:costo) }
  end

  describe 'con restricciones' do
    it 'Si el plan no tiene restricciones tiene_restricciones? deberia ser false' do
      plan_sin_restricciones = described_class.new('test', 20, nil, -1)
      expect(plan_sin_restricciones.tiene_restricciones?).to be false
    end

    it 'Si el plan tiene restricciones tiene_restricciones? deberia ser true' do
      restricciones = Restricciones.new(1, 1, 1, 1)
      plan_con_restricciones = described_class.new('test', 20, restricciones, -1)
      expect(plan_con_restricciones.tiene_restricciones?).to be true
    end

    it 'Si el plan tiene restricciones con hijos max 3 la cantidad maxima de hijo permitidas del plan es 3' do
      hijos_max = 3
      restricciones = Restricciones.new(hijos_max, 1, 1, 1)
      plan_con_restricciones = described_class.new('test', 20, restricciones, -1)
      expect(plan_con_restricciones.cantidad_hijos_maxima_permitida).to eq hijos_max
    end

    it 'Si el plan tiene restricciones con edad min 23 la edad minima permitida del plan es 23' do
      edad_min = 23
      restricciones = Restricciones.new(1, edad_min, 50, 1)
      plan_con_restricciones = described_class.new('test', 20, restricciones, -1)
      expect(plan_con_restricciones.edad_minima_permitida).to eq edad_min
    end

    it 'Si el plan tiene restricciones con edad max 23 la edad maxima permitida del plan es 23' do
      edad_max = 23
      restricciones = Restricciones.new(1, 1, edad_max, 1)
      plan_con_restricciones = described_class.new('test', 20, restricciones, -1)
      expect(plan_con_restricciones.edad_maxima_permitida).to eq edad_max
    end

    it 'Si el plan tiene restricciones con conyuge entonces conyuge_permitido devuelve false' do
      conyuge = false
      restricciones = Restricciones.new(1, 1, 1, conyuge)
      plan_con_restricciones = described_class.new('test', 20, restricciones, -1)
      expect(plan_con_restricciones.conyuge_permitido).to eq conyuge
    end
  end

  describe 'Con coberturas' do
    it 'Si el plan tiene coberturas de limite de visitas 3 entonces cuando le pido cobertura_limite_visitas devuelve 3' do
      cobertura_limite_visitas = 3
      coberturas = Coberturas.new(20, 20, cobertura_limite_visitas)
      plan_con_restricciones = described_class.new('test', 20, nil, -1, coberturas)
      expect(plan_con_restricciones.cobertura_limite_visitas).to eq cobertura_limite_visitas
    end

    it 'Si el plan tiene coberturas de copago de visitas 100 entonces si pido cobertura_copago de_visitas devuelve 100' do
      copago = 100
      coberturas = Coberturas.new(20, copago)
      plan_con_restricciones = described_class.new('test', 20, nil, -1, coberturas)
      expect(plan_con_restricciones.cobertura_copago_visitas).to eq copago
    end

    it 'Si el plan tiene coberturas de medicamentos 100% entonces si pido cobertura_de medicamentos devuelve 100' do
      cobertura_medicamentos = 100
      coberturas = Coberturas.new cobertura_medicamentos
      plan_con_restricciones = described_class.new('test', 20, nil, -1, coberturas)
      expect(plan_con_restricciones.cobertura_medicamentos).to eq cobertura_medicamentos
    end
  end
end
