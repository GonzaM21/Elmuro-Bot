require 'spec_helper'
require_relative '../../app/models/plan'
require_relative '../../app/presenters/presenter_plan'
require_relative '../../app/models/restricciones'
describe PresenterPlan do
  it 'El mensaje de un plan sin restricciones debe contener el costo del plan unicamente' do
    restricciones = Restricciones.new(nil, nil, nil, nil)
    cobertura = Coberturas.new(nil, nil, nil)
    plan = Plan.new('test', 300, restricciones, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300')
  end

  it 'El mensaje de un plan tiene restriccion no admite conyuge' do
    restricciones = Restricciones.new(nil, nil, nil, false)
    cobertura = Coberturas.new(nil, nil, nil)
    plan = Plan.new('test', 300, restricciones,  -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
Condiciones:
- El plan no admite conyuge')
  end

  it 'El mensaje de un plan tiene restriccion pide conyuge' do
    restricciones = Restricciones.new(nil, nil, nil, true)
    cobertura = Coberturas.new(nil, nil, nil)
    plan = Plan.new('test', 300, restricciones, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
Condiciones:
- El plan requiere conyuge')
  end

  it 'El mensaje de un plan tiene restriccion 20 años de edad minima' do
    restricciones = Restricciones.new(nil, 20, nil, nil)
    cobertura = Coberturas.new(nil, nil, nil)
    plan = Plan.new('test', 300, restricciones, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
Condiciones:
- La edad minima para afiliarse al plan es 20 años')
  end

  it 'El mensaje de un plan tiene restriccion 20 años de edad maxima' do
    restricciones = Restricciones.new(nil, nil, 20, nil)
    cobertura = Coberturas.new(nil, nil, nil)
    plan = Plan.new('test', 300, restricciones, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
Condiciones:
- La edad maxima para afiliarse al plan es 20 años')
  end

  it 'El mensaje de un plan tiene restriccion 6 hijos maximo' do
    restricciones = Restricciones.new(6, nil, nil, nil)
    cobertura = Coberturas.new(nil, nil, nil)
    plan = Plan.new('test', 300, restricciones, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
Condiciones:
- Debe tener hijos y la cantidad de hijos maxima es 6')
  end

  it 'El mensaje de un plan tiene todas las restricciones posibles' do
    restricciones = Restricciones.new(6, 30, 70, true)
    cobertura = Coberturas.new(nil, nil, nil)
    plan = Plan.new('test', 300, restricciones, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
Condiciones:
- El plan requiere conyuge
- La edad minima para afiliarse al plan es 30 años
- La edad maxima para afiliarse al plan es 70 años
- Debe tener hijos y la cantidad de hijos maxima es 6')
  end

  it 'El mensaje de un plan %50 de cobertura de medicamentos' do
    cobertura = Coberturas.new(50, nil)
    plan = Plan.new('test', 300, nil, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
y cuenta con cobertura de medicamentos del %50.')
  end

  it 'El mensaje de un plan con cobertura de visitas' do
    cobertura = Coberturas.new(50, 10, 20)
    plan = Plan.new('test', 300, nil, -1, cobertura)
    expect(described_class.new.mensaje(plan)).to eq('El plan test tiene un costo mensual de: $300
y cuenta con cobertura de medicamentos del %50.
Tambien cuenta con cobertura con un limite de 20 visitas y un copago de $10.')
  end
end
