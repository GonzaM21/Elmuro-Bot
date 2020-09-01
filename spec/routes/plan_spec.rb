require 'spec_helper'
require 'web_mock'
require 'cgi'

require File.dirname(__FILE__) + '/../../app/bot_client'

require_relative '../stubs'

describe 'PlanRepository' do
  it 'cuando se envia el mensaje /planes y no hay planes, no deberia haber opciones' do
    token = 'fake_token'

    stub_planes({ planes: [] })
    stub_get_updates(token, '/planes')
    stub_send_keyboard_message(token, 'Los planes disponibles son:', { 'inline_keyboard': [] })

    app = BotClient.new(token)

    app.run_once
  end

  it 'cuando se envia el mensaje /planes deberia mostrar las opciones que existen' do
    token = 'fake_token'

    stub_planes({ planes: [{ nombre: 'PlanJuventud', id: '1' }] })
    stub_get_updates(token, '/planes')
    stub_send_keyboard_message(
      token,
      'Los planes disponibles son:',
      { 'inline_keyboard': [[{ text: 'PlanJuventud', callback_data: '1' }]] }
    )

    app = BotClient.new(token)

    app.run_once
  end

  it 'cuando se envia el mensaje /plan a un plan sin restricciones ni coberturas, deberia solo mostrar el costo' do #rubocop: disable all
    token = 'fake_token'
    stub_planes({ planes: [{ nombre: 'Plan test', id: '1', cobertura_medicamentos: nil, cobertura_visitas: {} }] })
    stub_plan({
                nombre: 'Plan test',
                id: '1',
                costo: 100,
                cobertura_medicamentos: nil,
                cobertura_visitas: {
                  copago: nil,
                  limite: nil
                }
              }, 'Plan%20test')
    stub_get_updates(token, '/plan Plan test')
    stub_send_message(token, 'El plan Plan test tiene un costo mensual de: $100')

    app = BotClient.new(token)

    app.run_once
  end

  it 'cuando se envia el mensaje /plan a un plan con restricciones y sin coberturas, deberia solo mostrar el costo' do #rubocop: disable all
    token = 'fake_token'
    stub_planes({ planes: [{ nombre: 'Plan test', id: '1', cobertura_medicamentos: nil, cobertura_visitas: {} }] })
    stub_plan({
                nombre: 'Plan test',
                id: '1',
                costo: 100,
                cobertura_medicamentos: nil,
                cobertura_visitas: {
                  copago: nil,
                  limite: nil
                },
                restricciones: {
                  hijos_max: 6,
                  edad_min: 30,
                  edad_max: 70,
                  conyuge: true
                }
              }, 'Plan%20test')
    stub_get_updates(token, '/plan Plan test')
    stub_send_message(token, 'El plan Plan test tiene un costo mensual de: $100
Condiciones:
- El plan requiere conyuge
- La edad minima para afiliarse al plan es 30 años
- La edad maxima para afiliarse al plan es 70 años
- Debe tener hijos y la cantidad de hijos maxima es 6')

    app = BotClient.new(token)

    app.run_once
  end

  it 'cuando se envia el mensaje /plan a un plan con restricciones y coberturas, deberia solo mostrar el costo' do #rubocop: disable all
    token = 'fake_token'
    stub_planes({ planes: [{ nombre: 'Plan test', id: '1', cobertura_medicamentos: nil, cobertura_visitas: {} }] })
    stub_plan({
                nombre: 'Plan test',
                id: '1',
                costo: 100,
                cobertura_medicamentos: 50,
                cobertura_visitas: {
                  copago: 10,
                  limite: 5
                },
                restricciones: {
                  hijos_max: 6,
                  edad_min: 30,
                  edad_max: 70,
                  conyuge: true
                }
              }, 'Plan%20test')
    stub_get_updates(token, '/plan Plan test')
    stub_send_message(token, 'El plan Plan test tiene un costo mensual de: $100
y cuenta con cobertura de medicamentos del %50.
Tambien cuenta con cobertura con un limite de 5 visitas y un copago de $10.
Condiciones:
- El plan requiere conyuge
- La edad minima para afiliarse al plan es 30 años
- La edad maxima para afiliarse al plan es 70 años
- Debe tener hijos y la cantidad de hijos maxima es 6')

    app = BotClient.new(token)

    app.run_once
  end

  it 'cuando se envia el mensaje /plan a un plan con limite infinito, deberia solo mostrar el costo' do #rubocop: disable all
    token = 'fake_token'
    stub_planes({ planes: [{ nombre: 'Plan test', id: '1', cobertura_medicamentos: nil, cobertura_visitas: {} }] })
    stub_plan({
                nombre: 'Plan test',
                id: '1',
                costo: 100,
                cobertura_medicamentos: 50,
                cobertura_visitas: {
                  copago: 10,
                  limite: nil
                },
                restricciones: {
                  hijos_max: 6,
                  edad_min: 30,
                  edad_max: 70,
                  conyuge: true
                }
              }, 'Plan%20test')
    stub_get_updates(token, '/plan Plan test')
    stub_send_message(token, 'El plan Plan test tiene un costo mensual de: $100
y cuenta con cobertura de medicamentos del %50.
Tambien cuenta con cobertura con un limite infinito de visitas y un copago de $10.
Condiciones:
- El plan requiere conyuge
- La edad minima para afiliarse al plan es 30 años
- La edad maxima para afiliarse al plan es 70 años
- Debe tener hijos y la cantidad de hijos maxima es 6')

    app = BotClient.new(token)

    app.run_once
  end

  it 'cuando se envia el mensaje /plan con un nombre similar' do #rubocop: disable all
    token = 'fake_token'
    stub_planes({ planes: [{ nombre: 'Plan test', id: '1', cobertura_medicamentos: nil, cobertura_visitas: {} }] })
    stub_plan({
                nombre: 'Plan test',
                id: '1',
                costo: 100,
                cobertura_medicamentos: nil,
                cobertura_visitas: {
                  copago: nil,
                  limite: nil
                }
              }, CGI.escape('PlAn TÉsT'))
    stub_get_updates(token, '/plan PlAn TÉsT')
    stub_send_message(token, 'El plan Plan test tiene un costo mensual de: $100')

    app = BotClient.new(token)

    app.run_once
  end
end
