require 'spec_helper'
require_relative '../../app/presenters/presenter_resumen'

describe 'Presenter Resumen' do
  it 'Deberia devolverme el mensaje correcto para un resumen sin detalle' do #rubocop: disable all
    resumen = {
      'nombre' => 'pepe',
      'plan_nombre' => 'PlanCoberturas',
      'costo_plan' => 500,
      'saldo_adicional' => 0,
      'total_a_pagar' => 500,
      'detalle' => []
    }
    expect(PresenterResumen.new.mensaje(resumen)).to eq(
      "Nombre: pepe
Plan: PlanCoberturas
Costo plan: $500
Saldo adicional: $0
Total a pagar: $500"
    )
  end

  it 'Deberia devolverme el mensaje correcto para un resumen con' do #rubocop: disable all
    resumen = {
      'nombre' => 'pepe',
      'plan_nombre' => 'PlanCoberturas',
      'costo_plan' => 500,
      'saldo_adicional' => 0,
      'total_a_pagar' => 500,
      'detalle' => [
        { 'fecha' => '20/10/2020', 'concepto' => 'Medicamentos', 'costo' => 500 }
      ]
    }
    expect(PresenterResumen.new.mensaje(resumen)).to eq(
      "Nombre: pepe
Plan: PlanCoberturas
Costo plan: $500
Saldo adicional: $0
Total a pagar: $500

```
Fecha      | Concepto     | Costo
20/10/2020 | Medicamentos | $500```"
    )
  end
end
