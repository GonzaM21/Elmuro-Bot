Dado('el plan con nombre {string} con costo unitario ${int}') do |_string, _int|
  next
end

Dado("restricciones edad min {int}, edad max {int}, hijos max {int}, conyuge {string}") do |_int, _int2, _int3, _string| #rubocop: disable all
  next
end

Cuando('envio {string}') do |_string|
  next
end

Entonces('recibo {string}') do |_string|
  next
end

Cuando('le envio {string} al bot') do |_string|
  next
end

Entonces('recibo un mensaje que contiene {string}') do |_string|
  next
end
