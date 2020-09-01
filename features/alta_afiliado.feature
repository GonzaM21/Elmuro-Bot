# language: es

Característica: Alta de afiliado a un plan

  Escenario: TELE4 - Registración exitosa de afiliado de 18 años, sin hijos, sin conyuge
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, conyuge "no"
    Cuando envio "/registracion PlanJuventud, Miriam Perez, 18"
    Entonces recibo "Registración exitosa"

  Escenario: TELE5 - Registración fallida de afiliado de 28 años, sin hijos, sin conyuge a plan juventud
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
    Cuando envio "/registracion PlanJuventud, Miriam Perez, 28"
    Entonces recibo "Registración fallida: supera el límite máximo de edad"

  Escenario: TELE6 - Registración fallida de afiliado de 8 años, sin hijos, sin conyuge a plan juventud
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
    Cuando envio "/registracion PlanJuventud, Miriam Perez, 8"
    Entonces recibo "Registración fallida: no alcanza el límite mínimo de edad"

  Escenario: TELE7 - Registración fallida de afiliado de 18 años, con hijos, sin conyuge a plan juventud
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
    Cuando envio "/registracion PlanJuventud, Miriam Perez, 18, hijos-1"
    Entonces recibo "Registración fallida: este plan no admite hijos"

  Escenario: TELE8 - Registración fallida de afiliado de 18 años, sin hijos, con conyuge a plan juventud
    Dado el plan con nombre "PlanJuventud" con costo unitario $500
    Y restricciones edad min 15, edad max 20, hijos max 0, admite conyuge "no"
    Cuando envio "/registracion PlanJuventud, Miriam Perez, 18, conyuge"
    Entonces recibo "Registración fallida: este plan no admite conyuge"

  Escenario: TELE9 - Registración exitosa de afiliado de 28 años, sin hijos, sin conyuge a plan 310
    Dado el plan con nombre "Plan310" con costo unitario $1000
    Y restricciones edad min 21, edad max 99, hijos max 0, admite conyuge "no"
    Cuando envio "/registracion Plan310, Miriam Perez, 28"
    Entonces recibo "Registración exitosa"

  Escenario: TELE10 - Registración exitosa de afiliado de 28 años, con hijos, sin conyuge a plan familiar
    Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
    Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
    Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28, hijos-1"
    Entonces recibo "Registración exitosa"

  Escenario: TELE11 - Registración exitosa de afiliado de 28 años, con hijos, con conyuge a plan familiar
    Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
    Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
    Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28, hijos-1, conyuge"
    Entonces recibo "Registración exitosa"

  Escenario: TELE12 - Registración fallida de afiliado de 28 años, sin hijos, sin conyuge a plan familiar
    Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
    Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
    Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28"
    Entonces recibo "Registración fallida: este plan requiere tener hijos"

  Escenario: TELE13 - Registración fallida de afiliado de 28 años, sin hijos, con conyuge a plan familiar
    Dado el plan con nombre "PlanFamiliar" con costo unitario $2000
    Y restricciones edad min 15, edad max 99, hijos max 6, admite conyuge "si"
    Cuando envio "/registracion PlanFamiliar, Miriam Perez, 28, conyuge"
    Entonces recibo "Registración fallida: este plan requiere tener hijos"

  Escenario: TELE17 - Registración exitosa de afiliado de 28 años, sin hijos, con conyuge a plan pareja
    Dado el plan con nombre "PlanPareja" con costo unitario $1800
    Y restricciones edad min 15, edad max 99, hijos max 0, requiere conyuge "si"
    Cuando envio "/registracion PlanPareja, Miriam Perez, 28, conyuge"
    Entonces recibo "Registración exitosa"

  Escenario: TELE18 - Registración fallida de afiliado de 28 años, con hijos, con conyuge a plan pareja
    Dado el plan con nombre "PlanPareja" con costo unitario $1800
    Y restricciones edad min 15, edad max 99, hijos max 0, requiere conyuge "si"
    Cuando envio "/registracion PlanPareja, Miriam Perez, 28, hijos-1, conyuge"
    Entonces recibo "Registración fallida: este plan no admite hijos"

  Escenario: TELE19 - Registración fallida de afiliado de 28 años, con hijos, sin conyuge a plan pareja
    Dado el plan con nombre "PlanPareja" con costo unitario $1800
    Y restricciones edad min 15, edad max 99, hijos max 0, requiere conyuge "si"
    Cuando envio "/registracion PlanPareja, Miriam Perez, 28, hijos-1"
    Entonces recibo "Registración fallida: este plan no admite hijos"
