require 'spec_helper'
require 'web_mock'
# Uncomment to use VCR
# require 'vcr_helper'

require File.dirname(__FILE__) + '/../app/bot_client'

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

describe 'BotClient' do
  it 'Cuando se envia el mensaje /start deberia recibir un Hola' do
    token = 'fake_token'

    stub_get_updates(token, '/start')
    stub_send_message(token, 'Hola, Gonzalo')

    app = BotClient.new(token)

    app.run_once
  end

  it 'Cuando se envia el mensaje /stop deberia recibir un Chau' do
    token = 'fake_token'

    stub_get_updates(token, '/stop')
    stub_send_message(token, 'Chau, Gonzalo')

    app = BotClient.new(token)

    app.run_once
  end
end
