require 'json'
require 'cgi'
require_relative '../models/plan'
require_relative '../models/coberturas'
require_relative '../exceptions/no_existe_el_plan_error'

class PlanRepository
  API_KEY = ENV['API_KEY'] || 'secret'

  def initialize
    url = ENV['ELMURO_API_URL']
    @path = '/planes'
    @planes = {}
    @conn = Faraday.new(url: url, headers: { 'Content-Type' => 'application/json', 'API_KEY' => API_KEY })
  end

  def get
    response = @conn.get(@path)
    body = JSON.parse(response.body)
    crear_planes(body['planes'])
  end

  def buscar_por_nombre(nombre)
    plan = CGI.escape nombre
    response = @conn.get(@path + "?nombre=#{plan}")
    raise NoExisteElPlanError unless response.status == 200

    crear_plan JSON.parse(response.body)
  end

  def get_id(nombre_plan)
    plan = buscar_por_nombre(nombre_plan)
    plan.id
  end

  private

  def crear_planes(planes)
    return planes if planes.length.zero?

    lista_planes = []
    planes.each do |plan|
      nuevo_plan = crear_plan plan
      lista_planes.append(nuevo_plan)
    end
    lista_planes
  end

  def crear_plan(plan_info)
    restricciones = crear_restricion plan_info['restricciones'] unless plan_info['restricciones'].nil?
    cobertura_visitas = plan_info['cobertura_visitas']
    cobertura_medicamentos = plan_info['cobertura_medicamentos']
    coberturas = crear_coberturas(cobertura_visitas, cobertura_medicamentos) unless cobertura_visitas.nil? && cobertura_medicamentos.nil?
    Plan.new(plan_info['nombre'], plan_info['costo'], restricciones, plan_info['id'], coberturas)
  end

  def crear_restricion(plan_restricciones)
    Restricciones.new(plan_restricciones['hijos_max'],
                      plan_restricciones['edad_min'],
                      plan_restricciones['edad_max'],
                      plan_restricciones['conyuge'])
  end

  def crear_coberturas(cobertura_visitas, cobertura_medicamentos)
    Coberturas.new(cobertura_medicamentos,
                   cobertura_visitas['copago'],
                   cobertura_visitas['limite'])
  end
end
