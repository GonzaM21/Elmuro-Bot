require 'spec_helper'
require 'web_mock'
require 'json'
require File.dirname(__FILE__) + '/../../app/bot_client'

require_relative '../../app/repositories/afiliado_repository'
require_relative '../../app/models/afiliado'
require_relative '../stubs'
require_relative '../../app/exceptions/no_afiliado_error'

describe AfiliadoRepository do
  let(:repository) { described_class.new }

  describe 'Resumen' do
    it 'si estoy registrado me deberia traer el resumen' do
      stub_afiliados({ afiliados: [{ id: 1, nombre: 'Jorge', edad: 30, usuario: 'Jorgito', id_plan: 1 }] })
      stub_resumen(1, { nombre: 'Jorge',
                        plan: 'Plan Salud',
                        costo_plan: 3000,
                        saldo_adicional: 0,
                        total_a_pagar: 3000 })
      resumen = repository.get_resumen('Jorgito')
      expect(resumen).to eq({ 'nombre' => 'Jorge', 'plan' => 'Plan Salud', 'costo_plan' => 3000,
                              'saldo_adicional' => 0, 'total_a_pagar' => 3000 })
    end

    it 'deberia recibir un mensaje de error si consulto el resumen de alguien no afiliado' do
      stub_afiliados({ afiliados: [] })
      stub_resumen(-1, { message: 'El id no corresponde a un afilliado' }, 400)
      expect { repository.get_resumen('Jorgito') }.to raise_error(NoAfiliadoError)
    end
  end

  describe 'Crear un afiliado' do
    it 'deberia enviarle todos los campos de un afiliado a la api' do
      stub_crear_afiliado({
                            nombre: 'Pedro', edad: 30, id_plan: 1, usuario: '@pepe', hijos: 2, conyuge: true
                          })
      afiliado = Afiliado.new('Pedro', 30, '@pepe', 1, nil, 2, true)
      reg = described_class.new
      reg.save(afiliado)
      expect(reg.exito).to be true
    end
  end
end
