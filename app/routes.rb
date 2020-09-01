require File.dirname(__FILE__) + '/../lib/routing'

require_relative 'repositories/plan_repository'
require_relative 'models/plan'
require_relative 'models/afiliado'
require_relative 'presenters/presenter_plan'
require_relative 'presenters/presenter_registracion'
require_relative 'presenters/presenter_resumen'
require_relative 'repositories/afiliado_repository'
require_relative 'repositories/centro_repository'
require_relative 'exceptions/no_existe_el_plan_error'
require_relative 'exceptions/prestacion_inexistente_error'

SIN_HOSPITALES = 'No hay hospitales disponibles'.freeze
PRESTACION_INEXISTENTE = 'Ups, la prestacion consultada no se encuentra'.freeze

class Routes #rubocop: disable all
  include Routing

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{message.from.first_name}")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.first_name}")
  end

  on_message '/planes' do |bot, message|
    resp = PlanRepository.new.get
    keyboard = resp.map do |plan|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: plan.nombre, callback_data: plan.id)
    end
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
    bot.api.send_message(chat_id: message.chat.id, text: 'Los planes disponibles son:', reply_markup: markup)
  end

  on_response_to 'Los planes disponibles son:' do |bot, message|
    respuesta = 'utilice el comando /plan {nombre del plan} para mas info'
    bot.api.send_message(chat_id: message.message.chat.id, text: respuesta)
  end

  on_message_pattern %r{/registracion (?<plan>[^,]*), (?<nombre>[^,]*), (?<edad>[^,]*)(, hijos-(?<cant_hijos>[^,]*))?(, (?<tiene_conyuge>conyuge)?)?} do |bot, message, args| # rubocop: disable Layout/LineLength
    begin
      plan_id = PlanRepository.new.get_id(args['plan'])
      afiliado = Afiliado.new(
        args['nombre'], args['edad'].to_i, message.from.username, plan_id, nil, args['cant_hijos'], args['tiene_conyuge'] == 'conyuge'
      )
      reg = AfiliadoRepository.new
      reg.save afiliado
      mensaje = PresenterRegistracion.new.mensaje(reg)
    rescue NoExisteElPlanError
      mensaje = 'El plan ingresado no existe'
    end
    bot.api.send_message(chat_id: message.chat.id, text: mensaje)
  end

  on_message '/resumen' do |bot, message|
    resumen = AfiliadoRepository.new.get_resumen message.from.username
    mensaje = PresenterResumen.new.mensaje(resumen)
    bot.api.send_message(chat_id: message.chat.id, text: mensaje, parse_mode: 'Markdown')
  rescue NoAfiliadoError
    bot.api.send_message(chat_id: message.chat.id, text: 'Ups, Usted no esta afliado a ningun plan')
  end

  on_message_pattern %r{/consulta (?<prestacion>.*)} do |bot, message, args|
    centros = CentroRepository.new.get_centros_de_prestacion(args['prestacion'])
    if !centros.empty?
      centros.each do |centro|
        mensaje = centro.nombre + ' - coordenadas (' + centro.latitud.to_s + ', ' + centro.longitud.to_s + ')'
        bot.api.send_message(chat_id: message.chat.id, text: mensaje)
      end
    else
      bot.api.send_message(chat_id: message.chat.id, text: SIN_HOSPITALES)
    end

  rescue PrestacionInexistenteError
    bot.api.send_message(chat_id: message.chat.id, text: PRESTACION_INEXISTENTE)
  end

  on_message_pattern %r{/plan (?<plan>.*)} do |bot, message, args|
    begin
      plan = PlanRepository.new.buscar_por_nombre args['plan']
      respuesta = PresenterPlan.new.mensaje plan
    rescue NoExisteElPlanError
      respuesta = 'El plan ingresado no existe'
    end
    bot.api.send_message(chat_id: message.chat.id, text: respuesta)
  end

  on_message '/diagnostico covid' do |bot, message|
    @usuario = AfiliadoRepository.new.buscar_afiliado_por_usuario message.from.username
    opciones = ['35 - 36', '36 - 37', '37 - 38', '38 - 39', '39 - 40']
    keyboard = opciones.map do |opcion|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: opcion, callback_data: opcion)
    end
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
    bot.api.send_message(chat_id: message.chat.id, text: 'Cuál es tu temperatura corporal?', reply_markup: markup)
  rescue NoAfiliadoError
    bot.api.send_message(chat_id: message.chat.id, text: 'Disculple, esta funcionalidad solo está disponible para afiliados.')
  end

  on_response_to 'Cuál es tu temperatura corporal?' do |bot, message|
    temp = message.data

    if temp.eql?('35 - 36') || temp.eql?('36 - 37')
      opciones = %w[Si No]
      keyboard = opciones.map do |opcion|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: opcion, callback_data: opcion)
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Percibiste una marcada pérdida de olfato de manera repentina?', reply_markup: markup)
    else
      AfiliadoRepository.new.agregar_diagnostico(@usuario)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano')
    end
  end

  on_response_to 'Percibiste una marcada pérdida de olfato de manera repentina?' do |bot, message|
    respuesta = message.data

    if respuesta.eql?('No')
      opciones = %w[Si No]
      keyboard = opciones.map do |opcion|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: opcion, callback_data: opcion)
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Percibiste una marcada pérdida del gusto de manera repentina?', reply_markup: markup)
    else
      AfiliadoRepository.new.agregar_diagnostico(@usuario)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano')
    end
  end

  on_response_to 'Percibiste una marcada pérdida del gusto de manera repentina?' do |bot, message|
    respuesta = message.data

    if respuesta.eql?('No')
      opciones = %w[Si No]
      keyboard = opciones.map do |opcion|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: opcion, callback_data: opcion)
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Tenés tos?', reply_markup: markup)
    else
      AfiliadoRepository.new.agregar_diagnostico(@usuario)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano')
    end
  end

  on_response_to 'Tenés tos?' do |bot, message|
    respuesta = message.data

    if respuesta.eql?('No')
      opciones = %w[Si No]
      keyboard = opciones.map do |opcion|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: opcion, callback_data: opcion)
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Tenés dolor de garganta?', reply_markup: markup)
    else
      AfiliadoRepository.new.agregar_diagnostico(@usuario)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano')
    end
  end

  on_response_to 'Tenés dolor de garganta?' do |bot, message|
    respuesta = message.data

    if respuesta.eql?('No')
      opciones = %w[Si No]
      keyboard = opciones.map do |opcion|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: opcion, callback_data: opcion)
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Tenés dificultad respiratoria?', reply_markup: markup)
    else
      AfiliadoRepository.new.agregar_diagnostico(@usuario)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano')
    end
  end

  on_response_to 'Tenés dificultad respiratoria?' do |bot, message|
    respuesta = message.data

    if respuesta.eql?('No')
      opciones = ['Convivo con alguien que tiene COVID', 'En los últimos 14 días estuve cerca de alguien con COVID',
                  'Estoy embarazada', 'Tengo/tuve cancer', 'Tengo diabetes', 'Tengo enfermedad hepática',
                  'Tengo enfermedad renal crónica', 'Tengo alguna enfermedad respiratoria',
                  'Tengo alguna enfermedad cardiológica', 'Ninguna']
      keyboard = opciones.map do |opcion|
        Telegram::Bot::Types::InlineKeyboardButton.new(text: opcion, callback_data: opcion)
      end
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Selecione alguna de las opciones:', reply_markup: markup)
    else
      AfiliadoRepository.new.agregar_diagnostico(@usuario)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano')
    end
  end

  on_response_to 'Selecione alguna de las opciones:' do |bot, message|
    respuesta = message.data

    if respuesta.eql?('Convivo con alguien que tiene COVID') || respuesta.eql?('En los últimos 14 días estuve cerca de alguien con COVID')
      AfiliadoRepository.new.agregar_diagnostico(@usuario)
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Usted es un caso sospechoso de COVID. Por favor acerquese a su centro médico más cercano')
    else
      bot.api.send_message(chat_id: message.message.chat.id, text: 'Gracias por realizar el diagnóstico')
    end
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
