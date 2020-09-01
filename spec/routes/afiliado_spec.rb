require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../../app/bot_client'

require_relative '../stubs'

describe 'registracion' do #rubocop: disable all
  it 'cuando se envia el mensaje /registracion Plan, Juan, 20, recibo registración exitosa' do #rubocop: disable all
    token = 'fake_token'
    stub_registracion
    stub_plan({
                nombre: 'Plan',
                id: '1',
                costo: 100,
                cobertura_medicamentos: nil,
                cobertura_visitas: {
                  copago: nil,
                  limite: nil
                }
              }, 'Plan')
    stub_get_updates(token, '/registracion Plan, Juan, 20')
    stub_send_message(token, 'Registración exitosa')

    app = BotClient.new(token)

    app.run_once
  end

  it 'cuando no existe el plan, el bot debería devolver el mensaje correcto' do
    token = 'fake_token'
    stub_registracion
    stub_plan({}, 'Plan', 404)
    stub_get_updates(token, '/registracion Plan, Juan, 20')
    stub_send_message(token, 'El plan ingresado no existe')

    app = BotClient.new(token)

    app.run_once
  end

  describe 'Covid' do
    it 'Al consultar y no estar afiliado, se me informa que solo esta disponible para afiliados' do
      token = 'fake_token'
      stub_get_updates(token, '/diagnostico covid')
      stub_send_message(token, 'Disculple, esta funcionalidad solo está disponible para afiliados.')
    end

    it 'Al consultar y esta afiliado, le pregunta la temperatura' do #rubocop: disable all
      token = 'fake_token'

      stub_afiliados(afiliados: [{ nombre: 'Gonzalo',
                                   edad: 25,
                                   usuario: 'GonzaAM',
                                   plan_id: 1,
                                   tiene_conyuge: false,
                                   cant_hijos: 0,
                                   id: 1 }])

      stub_get_updates(token, '/diagnostico covid')
      stub_send_keyboard_message(
        token,
        'Cuál es tu temperatura corporal?',
        { 'inline_keyboard': [[{ text: '35 - 36', callback_data: '35 - 36' }],
                              [{ text: '36 - 37', callback_data: '36 - 37' }],
                              [{ text: '37 - 38', callback_data: '37 - 38' }],
                              [{ text: '38 - 39', callback_data: '38 - 39' }],
                              [{ text: '39 - 40', callback_data: '39 - 40' }]] }
      )
      app = BotClient.new(token)
      app.run_once
    end
  end
end
