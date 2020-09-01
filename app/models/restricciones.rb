class Restricciones
  attr_accessor :hijos_max, :edad_min, :edad_max, :conyuge

  def initialize(hijos_max, edad_min, edad_max, conyuge)
    @hijos_max = hijos_max
    @edad_min = edad_min
    @edad_max = edad_max
    @conyuge = conyuge
  end

  def tiene_alguna_restriccion?
    !@hijos_max.nil? ||
      !@edad_min.nil? ||
      !@edad_max.nil? ||
      !@conyuge.nil?
  end
end
