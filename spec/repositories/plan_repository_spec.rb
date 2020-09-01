require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../../app/bot_client'

require_relative '../../app/repositories/plan_repository'
require_relative '../stubs'
require_relative '../../app/exceptions/no_existe_el_plan_error'

describe 'PlanRepository' do
  it 'deberia devolverme un plan cuando existe' do
    stub_plan({
                nombre: 'Plan Test',
                id: '1',
                costo: '100'
              }, 'Plan Test')
    plan = PlanRepository.new.buscar_por_nombre('Plan Test')
    expect(plan.nombre).to eq('Plan Test')
    expect(plan.id).to eq('1')
    expect(plan.costo).to eq('100')
  end

  it 'deberia lanzar un error cuando no existe el plan' do
    stub_plan({}, 'vacio', 404)
    expect { PlanRepository.new.buscar_por_nombre('vacio') }.to raise_error(NoExisteElPlanError)
  end

  it 'dado que existe el plan "Plan test" cuando lo busco deberia encontrarlo' do
    stub_planes({ planes: [{ nombre: 'Plan test', id: '1', costo: '100' }] })
    stub_plan({
                nombre: 'Plan Test',
                id: '1',
                costo: '100'
              }, 'Plan Test')
    plan = PlanRepository.new.buscar_por_nombre('Plan Test')
    expect(plan.nombre).to eq('Plan Test')
    expect(plan.id).to eq('1')
    expect(plan.costo).to eq('100')
  end

  describe 'Coberturas' do
    it 'dado que el plan "Test" tiene coberturas cuando lo busco puedo verificarlo' do # rubocop: disable all
      stub_plan({
                  nombre: 'Plan Test',
                  id: '1',
                  costo: '100',
                  cobertura_visitas: {
                    limite: 1,
                    copago: 2
                  },
                  cobertura_medicamentos: 50
                }, 'Plan Test')
      plan_buscado = PlanRepository.new.buscar_por_nombre('Plan Test')
      expect(plan_buscado.cobertura_limite_visitas).to eq(1)
      expect(plan_buscado.cobertura_copago_visitas).to eq(2)
      expect(plan_buscado.cobertura_medicamentos).to eq(50)
    end
  end
end
