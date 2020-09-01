class Centro
  attr_accessor :nombre, :latitud, :longitud, :id

  def initialize(nombre, latitud, longitud, id)
    @nombre = nombre
    @latitud = latitud
    @longitud = longitud
    @id = id
  end
end
