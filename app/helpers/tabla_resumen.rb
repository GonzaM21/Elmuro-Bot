class TablaResumen
  def initialize(datos)
    @datos = datos
    @encabezado = %w[Fecha Concepto Costo]
    @concepto_mas_largo = ''
    @datos.each do |gasto|
      @concepto_mas_largo = gasto[1] if gasto[1].length > @concepto_mas_largo.length
    end
  end

  def tabla # rubocop: disable all
    tabla = (@encabezado[0]).to_s + padding_fecha + " | #{@encabezado[1]}" + padding_concepto(@encabezado[1]) + " | #{@encabezado[2]}"
    @datos.each do |gasto|
      tabla += "\n"
      tabla += (gasto[0]).to_s + " | #{gasto[1]}" + padding_concepto(gasto[1]) + " | #{gasto[2]}"
    end
    tabla
  end

  private

  def padding_concepto(palabra)
    ' ' * (@concepto_mas_largo.length - palabra.length)
  end

  def padding_fecha
    ' ' * 5
  end
end
