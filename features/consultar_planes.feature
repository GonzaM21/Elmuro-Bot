# language: es

Característica: Consultar planes
  
  Escenario: TELE1 - Consultar lista de planes
    Cuando le envio "/planes" al bot
    Entonces recibo un mensaje que contiene "Los planes disponibles son"

  Escenario: TELE2 - Consulta de plan PlanJuventud cuando está cargado
    Dado que existe el plan "PlanJuventud"
    Cuando envio "/plan PlanJuventud"
    Entonces recibo la información del "PlanJuventud"

  Escenario: TELE2.1 - Consulta de un plan mayusculas
    Dado que existe el plan "PlanJuventud"
    Cuando envio "/plan planjuventud"
    Entonces recibo la información del "PlanJuventud"

  Escenario: TELE3 - Consulta de plan PlanJuventud cuando no está cargado
    Cuando envío "/plan PlanJuventud"
    Entonces recibo "El plan ingresado no existe"
