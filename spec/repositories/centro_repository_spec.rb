require 'spec_helper'
require 'web_mock'

require File.dirname(__FILE__) + '/../../app/bot_client'

require_relative '../../app/exceptions/prestacion_inexistente_error'
require_relative '../stubs'

describe CentroRepository do
  it 'deberia devolverme una lista de centros para una prestacion' do #rubocop: disable all
    stub_centro_prestacion([{
                             nombre: 'centro test',
                             id: '1',
                             latitud: '-10.0',
                             longitud: '-10.0'
                           }], CGI.escape('Prestacion test'))

    centro = described_class.new.get_centros_de_prestacion('Prestacion test')[0]
    expect(centro.nombre).to eq('centro test')
    expect(centro.latitud).to eq('-10.0')
    expect(centro.longitud).to eq('-10.0')
    expect(centro.id).to eq('1')
  end

  it 'deberia devolverme una lista de centros para una prestacion con nombre similar' do #rubocop: disable all
    stub_centro_prestacion([{
                             nombre: 'centro test',
                             id: '1',
                             latitud: '-10.0',
                             longitud: '-10.0'
                           }], CGI.escape('PRESTACIóN TÉsT'))

    centro = described_class.new.get_centros_de_prestacion('PRESTACIóN TÉsT')[0]
    expect(centro.nombre).to eq('centro test')
    expect(centro.latitud).to eq('-10.0')
    expect(centro.longitud).to eq('-10.0')
    expect(centro.id).to eq('1')
  end
end
