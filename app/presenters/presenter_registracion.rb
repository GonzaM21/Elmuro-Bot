class PresenterRegistracion
  def mensaje(registracion) #rubocop: disable all
    return 'Registración exitosa' if registracion.exito

    case registracion.codigo_error
    when '8'
      'Registración fallida: este plan no admite hijos'
    when '7'
      'Registración fallida: supera el límite máximo de edad'
    when '6'
      'Registración fallida: no alcanza el límite mínimo de edad'
    when '5'
      'Registración fallida: este plan requiere tener hijos'
    when '4'
      'Registración fallida: supera el límite máximo de hijos'
    when '3'
      'Registración fallida: este plan requiere conyuge'
    when '2'
      'Registración fallida: este plan no admite conyuge'
    when '1'
      'Registración fallida: el plan no existe'
    else
      'No se pudo registrar'
    end
  end
end
