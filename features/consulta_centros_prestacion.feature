# language: es

@wip
Característica: Consultas de centros por prestacion via telegram

  Escenario: TELE14 - Consulta exitosa de Centro por prestación
    Dado el centro con nombre "Hospital Alemán"
    Y el centro tiene la prestación "Traumatología"
    Cuando envio "/consulta traumatologia"
    Entonces recibo "Hospital Alemán - Coordenadas (X,X)"
    #TODO Agregar dirección

  Escenario: TELE15 - Consulta sin respuestas de Centro por prestación
    Dado el centro con nombre "Hospital Alemán"
    Y el centro tiene la prestación "Traumatología"
    Cuando envio "/consulta cirujia"
    Entonces recibo "No hay hospitales disponibles"