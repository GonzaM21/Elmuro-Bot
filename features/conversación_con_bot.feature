# language: es

Característica: Charla básica

  Escenario: Saludo
  Dado que mi nombre de usuario es "Diego"
  Cuando le envió "/start" al bot
  Entonces recibo el mensaje "Hola, Diego"

  Escenario: Despedida
  Dado que mi nombre de usuario es "Diego"
  Cuando le envió "/stop" al bot
  Entonces recibo el mensaje "Chau, Diego"
