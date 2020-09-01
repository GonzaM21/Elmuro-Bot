class Afiliado
  attr_accessor :nombre, :edad, :usuario, :plan_id, :id, :cant_hijos, :tiene_conyuge

  def initialize(nombre, edad, usuario, plan_id, id = nil, cant_hijos = nil, tiene_conyuge = nil)
    @nombre = nombre
    @edad = edad
    @usuario = usuario
    @plan_id = plan_id
    @id = id
    @cant_hijos = cant_hijos ? cant_hijos.to_i : 0
    @tiene_conyuge = tiene_conyuge
  end
end
