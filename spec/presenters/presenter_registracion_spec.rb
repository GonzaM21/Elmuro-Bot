require 'spec_helper'
require_relative '../../app/models/plan'
require_relative '../../app/presenters/presenter_registracion'

describe 'Registracion Presenter' do
  it 'Deberia devolverme un mensaje de exito correcto' do
    reg = instance_double('reg', exito: true, codigo_error: nil)
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración exitosa')
  end

  it 'Deberia devolverme que supero el limite de edad para el codigo de error correspondiente' do
    reg = instance_double('reg', exito: false, codigo_error: '7')
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración fallida: supera el límite máximo de edad')
  end

  it 'Deberia devolverme que no alcanzo el minimo de edad para el codigo de error correspondiente' do
    reg = instance_double('reg', exito: false, codigo_error: '6')
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración fallida: no alcanza el límite mínimo de edad')
  end

  it 'Deberia devolverme que no alcanzo la minima cantidad de hijos para el codigo de error corresp' do
    reg = instance_double('reg', exito: false, codigo_error: '5')
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración fallida: este plan requiere tener hijos')
  end

  it 'Deberia devolverme que supero la cantidad maxima de hijos para el codigo de error corresp' do
    reg = instance_double('reg', exito: false, codigo_error: '4')
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración fallida: supera el límite máximo de hijos')
  end

  it 'Deberia devolverme que el plan requiere conyuge para el codigo de error correspondiente' do
    reg = instance_double('reg', exito: false, codigo_error: '3')
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración fallida: este plan requiere conyuge')
  end

  it 'Deberia devolverme que el plan no acepta conyuge para el codigo de error correspondiente' do
    reg = instance_double('reg', exito: false, codigo_error: '2')
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración fallida: este plan no admite conyuge')
  end

  it 'Deberia devolverme que el plan no acepta hijos para ese codigo de error' do
    reg = instance_double('reg', exito: false, codigo_error: '8')
    expect(PresenterRegistracion.new.mensaje(reg)).to eq('Registración fallida: este plan no admite hijos')
  end
end
