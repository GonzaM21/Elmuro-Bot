# language: es

Característica: Consulta de resumen

  Escenario: TELE16.1 - Consulta de resumen
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud" con costo $5000
    Cuando envío "/resumen"
    Entonces recibo:
    """
    Nombre: Lionel Messi
    Plan: PlanJuventud
    Costo plan: $ 5000
    Saldo adicional: $0
    Total a pagar: $5000
    """

  Escenario: Consulta de resumen de no afiliado
    Dado que no estoy afiliado
    Cuando consulto el resumen
    Entonces se me informa que no estoy afiliado

  Escenario: TELE16 - Consulta de resumen
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud" con costo $5000
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 01/01/2020
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 10/01/2020
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 20/01/2020
    Cuando envío "/resumen"
    Entonces recibo:
    """
    Nombre: Lionel Messi
    Plan: PlanJuventud
    Costo plan: $ 5000
    Saldo adicional: $1200
    Total a pagar: $6200

    Fecha      | Concepto                        | Costo
    01/01/2020 | Traumatología - Hospital Alemán | $0
    10/01/2020 | Traumatología - Hospital Alemán | $0
    20/01/2020 | Traumatología - Hospital Alemán | $1200
    """

  Escenario: TELE20 - Consulta de resumen con medicamentos
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud" con costo $5000
    Y que se registró una atención por la prestación "Traumatologia" en el centro "Hospital Alemán" el dia 01/01/2020
    Y que se registró una compra de medicamentos por $1000 el dia 20/01/2020
    Y que se registró una compra de medicamentos por $1000 el dia 21/01/2020
    Cuando envío "/resumen"
    Entonces recibo:
    """
    Nombre: Lionel Messi
    Plan: PlanJuventud
    Costo plan: $ 5000
    Saldo adicional: $1600
    Total a pagar: $6600

    Fecha      | Concepto                        | Costo
    01/01/2020 | Traumatología - Hospital Alemán | $0
    20/01/2020 | Medicamentos                    | $800
    21/01/2020 | Medicamentos                    | $800
    """
