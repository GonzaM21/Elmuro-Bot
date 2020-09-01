def stub_get_updates(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Gonzalo', "last_name": 'Marino', "username": 'GonzaAM', "language_code": 'en' }, #rubocop: disable all
                                                 "chat": { "id": 141_733_544, "first_name": 'Gonzalo', "last_name": 'Marino', "username": 'GonzaAM', "type": 'private' }, #rubocop: disable all
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] } #rubocop: disable all

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def stub_send_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'Testing el muro', "username": 'testelmurobot' }, #rubocop: disable all
                       "chat": { "id": 141_733_544, "first_name": 'Gonzalo', "last_name": 'Marino', "username": 'GonzaAM', "type": 'private' }, #rubocop: disable all
                       "date": 1_557_782_999, "text": message_text } } #rubocop: disable all

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def stub_send_keyboard_message(token, message_text, keyboard_markup) #rubocop: disable all
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' }, #rubocop: disable all
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' }, #rubocop: disable all
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544',
              'reply_markup' => keyboard_markup.to_json,
              'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def stub_planes(response)
  stub_request(:get, 'http://elmuro-api-test/planes')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: 200, body: response.to_json, headers: {})
end

def stub_registracion
  stub_request(:post, 'http://elmuro-api-test/afiliados')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: 201, body: { "ok": true }.to_json, headers: {})
end

def stub_plan(response, nombre, status = 200)
  stub_request(:get, "http://elmuro-api-test/planes?nombre=#{nombre}")
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: status, body: response.to_json, headers: {})
end

def stub_prestacion(response, status = 200)
  stub_request(:get, 'http://elmuro-api-test/prestaciones')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: status, body: { prestaciones: response }.to_json, headers: {})
end

def stub_afiliados(response, status = 200)
  stub_request(:get, 'http://elmuro-api-test/afiliados')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: status, body: response.to_json, headers: {})
end

def stub_resumen(id_afiliado, response, status = 200)
  stub_request(:get, 'http://elmuro-api-test/afiliados/' + id_afiliado.to_s + '/resumen')
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: status, body: response.to_json, headers: {})
end

def stub_centro_prestacion(response, prestacion, status = 200)
  stub_request(:get, "http://elmuro-api-test/centros?prestacion=#{prestacion}")
    .with(
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: status, body: { centros: response }.to_json, headers: {})
end

def stub_crear_afiliado(datos_afiliado, status_rta = 201, body_rta = {})
  stub_request(:post, 'http://elmuro-api-test/afiliados')
    .with(
      body: datos_afiliado.to_json,
      headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Faraday v1.0.1'
      }
    )
    .to_return(status: status_rta, body: body_rta.to_json, headers: {})
end
