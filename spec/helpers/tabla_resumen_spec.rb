require 'spec_helper'
require_relative '../../app/models/afiliado'

describe 'Tabla de resumen' do
  it 'deberia devolver la tabla correctamente' do
    datos = [
      ['10/10/2020', 'Medicamentos', '$600'],
      ['11/10/2020', 'Traumatología - Hospital Alemán', '$1500'],
      ['13/10/2020', 'Internación - Hospital Alemán', '$40000']
    ]
    tabla = TablaResumen.new(datos).tabla
    expect(tabla).to eq(
      "Fecha      | Concepto                        | Costo
10/10/2020 | Medicamentos                    | $600
11/10/2020 | Traumatología - Hospital Alemán | $1500
13/10/2020 | Internación - Hospital Alemán   | $40000"
    )
  end
end
