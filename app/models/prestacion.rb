class Prestacion
  attr_accessor :nombre, :costo, :id

  def initialize(nombre, costo, id)
    @nombre = nombre
    @costo = costo
    @id = id
  end
end
