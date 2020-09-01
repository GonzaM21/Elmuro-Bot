require_relative '../helpers/tabla_resumen'

class PresenterResumen
  def mensaje(resumen)
    mensaje = "Nombre: #{resumen['nombre']}"
    mensaje += "\nPlan: #{resumen['plan_nombre']}"
    mensaje += "\nCosto plan: $#{resumen['costo_plan']}"
    mensaje += "\nSaldo adicional: $#{resumen['saldo_adicional']}"
    mensaje += "\nTotal a pagar: $#{resumen['total_a_pagar']}"

    return mensaje if resumen['detalle'].length.zero?

    agregar_detalle(mensaje, resumen)
  end

  private

  def agregar_detalle(mensaje, resumen)
    tabla = armar_tabla(resumen)
    mensaje += "\n\n```\n" + tabla + '```'
    mensaje
  end

  def armar_tabla(resumen)
    datos = []
    resumen['detalle'].each do |gasto|
      datos << [gasto['fecha'], gasto['concepto'], "$#{gasto['costo']}"]
    end
    TablaResumen.new(datos).tabla
  end
end
