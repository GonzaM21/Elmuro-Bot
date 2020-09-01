require 'json'
require_relative 'plan_repository'
require_relative '../models/afiliado'
require_relative '../exceptions/no_afiliado_error'

class AfiliadoRepository
  attr_reader :mensaje, :exito, :codigo_error
  API_KEY = ENV['API_KEY'] || 'secret'

  def initialize
    @path = '/afiliados'
    url = ENV['ELMURO_API_URL']
    @conn = Faraday.new(url: url, headers: { 'Content-Type' => 'application/json', 'API_KEY' => API_KEY })
  end

  def save(afiliado)
    request = {
      "nombre": afiliado.nombre,
      "edad": afiliado.edad,
      "id_plan": afiliado.plan_id,
      "usuario": afiliado.usuario,
      "hijos": afiliado.cant_hijos,
      "conyuge": afiliado.tiene_conyuge
    }
    response = @conn.post(@path, request.to_json)
    @codigo_error = JSON.parse(response.body)['codigo']
    @exito = response.status == 201
  end

  def get_resumen(usuario)
    afiliado = buscar_afiliado_por_usuario(usuario)
    response = @conn.get(@path + '/' + afiliado.id.to_s + '/resumen')
    JSON.parse(response.body) if response.status == 200
  end

  def buscar_afiliado_por_usuario(usuario)
    response = @conn.get(@path)
    return nil if response.status != 200

    body = JSON.parse(response.body)
    lista_afiliados = crear_afiliados(body['afiliados'])
    buscar_afiliado(usuario, lista_afiliados)
  end

  def agregar_diagnostico(usuario)
    path = @path + "/#{usuario.id}/diagnosticos_covid"
    @conn.post(path)
  end

  private

  def buscar_afiliado(usuario, lista_afiliados)
    lista_afiliados.each do |afiliado|
      return afiliado if afiliado.usuario.eql? usuario
    end
    raise NoAfiliadoError
  end

  def crear_afiliados(afiliados)
    lista_afiliados = []
    afiliados.each do |afiliado|
      nuevo_afiliado = Afiliado.new(afiliado['nombre'], afiliado['edad'],
                                    afiliado['usuario'], afiliado['plan_id'],
                                    afiliado['id'])
      lista_afiliados.append(nuevo_afiliado)
    end
    lista_afiliados
  end
end
