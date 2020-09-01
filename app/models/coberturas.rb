class Coberturas
  attr_reader :medicamentos, :copago_visitas, :limite_visitas

  def initialize(medicamentos = 0, copago = 0, limite = nil)
    @medicamentos = medicamentos
    @copago_visitas = copago
    @limite_visitas = limite
  end
end
