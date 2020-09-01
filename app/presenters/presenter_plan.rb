class PresenterPlan
  def mensaje(plan) #rubocop: disable all
    respuesta = "El plan #{plan.nombre} tiene un costo mensual de: $#{plan.costo}"

    unless plan.cobertura_medicamentos.nil?
      respuesta += "
y cuenta con cobertura de medicamentos del %#{plan.cobertura_medicamentos}."
    end

    limite = 'de ' + plan.cobertura_limite_visitas.to_s
    limite = 'infinito de' if plan.cobertura_limite_visitas.nil?

    unless plan.cobertura_copago_visitas.nil?
      respuesta += "
Tambien cuenta con cobertura con un limite #{limite} visitas y un copago de $#{plan.cobertura_copago_visitas}."
    end
    return respuesta unless plan.tiene_restricciones?

    respuesta += '
Condiciones:'

    unless plan.conyuge_permitido.nil?
      respuesta += if plan.conyuge_permitido
                     "
- El plan requiere conyuge"
                   else
                     "
- El plan no admite conyuge"
                   end
    end

    unless plan.edad_minima_permitida.nil?
      respuesta += "
- La edad minima para afiliarse al plan es #{plan.edad_minima_permitida} años"
    end

    unless plan.edad_maxima_permitida.nil?
      respuesta += "
- La edad maxima para afiliarse al plan es #{plan.edad_maxima_permitida} años"
    end

    unless plan.cantidad_hijos_maxima_permitida.nil?
      respuesta += "
- Debe tener hijos y la cantidad de hijos maxima es #{plan.cantidad_hijos_maxima_permitida}"
    end

    respuesta
  end
end
