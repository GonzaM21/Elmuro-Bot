require_relative './restricciones'
class Plan
  attr_accessor :nombre, :id, :costo

  def initialize(nombre, costo, restricciones = nil, id = nil, coberturas = nil)
    @id = id
    @nombre = nombre
    @costo = costo
    @restricciones = restricciones
    @coberturas = coberturas
  end

  def tiene_restricciones?
    !@restricciones.nil? && @restricciones.tiene_alguna_restriccion?
  end

  def cantidad_hijos_maxima_permitida
    @restricciones.hijos_max
  end

  def edad_minima_permitida
    @restricciones.edad_min
  end

  def edad_maxima_permitida
    @restricciones.edad_max
  end

  def conyuge_permitido
    @restricciones.conyuge
  end

  def cobertura_limite_visitas
    @coberturas.limite_visitas
  end

  def cobertura_copago_visitas
    @coberturas.copago_visitas
  end

  def cobertura_medicamentos
    @coberturas.medicamentos
  end
end
