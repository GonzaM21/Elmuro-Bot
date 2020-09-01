# language: es

Característica: Charla básica

  Escenario: TELE17-DIAG1 - Diagnostico sin covid
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
    Cuando envia "/diagnostico covid"
    Entonces recibo "Cuál es tu temperatura corporal?"
    Cuando envío 37
    Entonces recibo "Percibiste una marcada pérdida de olfato de manera repentina?"
    Y envío "No"
    Entonces recibo "Percibiste una marcada pérdida del gusto de manera repentina?"
    Y envío "No"
    Entonces recibo "Tenés tos?"
    Y envío "No"
    Entonces recibo "Tenés dolor de garganta?"
    Y envío "No"
    Entonces recibo "Tenés dificultad respiratoria?"
    Y envío "No"
    Entonces recibo en formato de opciones
        """
        - Convivo con alguien que tiene COVID
        - En los últimos 14 días estuve cerca de alguien con COVID
        - Estoy embarazada
        - Tengo/tuve cancer
        - Tengo diabetes
        - Tengo enfermedad hepática
        - Tengo enfermedad renal crónica
        - Tengo alguna enfermedad respiratoria
        - Tengo alguna enfermedad cardiológica
        - Ninguna
        """
    Y elijo "Ninguna"
    Entonces recibo "Gracias por realizar el diagnóstico"


  Escenario: TELE18-DIAG2 - Diagnostico sospechoso de covid
    Dado el afiliado "Lionel Messi" afiliado a "PlanJuventud"
    Cuando envia "/diagnostico covid
    Entonces recibo "Cuál es tu temperatura corporal?"
    Cuando envío 37
    Entonces recibo "Percibiste una marcada pérdida de olfato de manera repentina?"
    Y envío "No"
    Entonces recibo "Percibiste una marcada pérdida del gusto de manera repentina?"
    Y envío "No"
    Entonces recibo "Tenés tos?"
    Y envío "Si"
    Entonces recibo "Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano"
    Y mi diagnostico es informado a la institución

  Escenario: TELE19-DIAG3 - Diagnostico covid tira error por persona no afiliada
    Dado que el usuario "locomalo" no está afiliado
    Cuando envia "/diagnostico covid"
    Entonces recibe "Disculple, esta funcionalidad solo está disponible para afiliados."
