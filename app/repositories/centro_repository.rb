require 'json'
require_relative '../models/prestacion'
require_relative '../models/centro'
require_relative '../exceptions/prestacion_inexistente_error'

class CentroRepository
  API_KEY = ENV['API_KEY'] || 'secret'

  def initialize
    url = ENV['ELMURO_API_URL']
    @path = '/prestaciones'
    @conn = Faraday.new(url: url, headers: { 'Content-Type' => 'application/json', 'API_KEY' => API_KEY })
  end

  def get_centros_de_prestacion(nombre_prestacion)
    prestacion = CGI.escape nombre_prestacion
    response = @conn.get("/centros?prestacion=#{prestacion}")
    body = JSON.parse(response.body)
    raise PrestacionInexistenteError if response.status == 400

    crear_centros(body['centros'])
  end

  private

  def crear_centros(centros)
    lista_centros = []
    centros.each do |centro|
      nuevo_centro = Centro.new(centro['nombre'], centro['latitud'], centro['longitud'], centro['id'])
      lista_centros.append(nuevo_centro)
    end
    lista_centros
  end
end
