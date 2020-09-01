require 'spec_helper'
require_relative '../../app/models/plan'
require_relative '../../app/presenters/presenter_registracion'

describe 'Registracion Presenter' do
  it 'Deberia devolverme un mensaje de exito correcto' do
    reg = instance_double('reg', exito: true, codigo_error: nil)
    expect(described_class.new.mensaje(reg)).to eq('Registración exitosa')
  end
end
