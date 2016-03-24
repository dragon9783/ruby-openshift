require 'net/http'
require 'net/https'
require 'uri'
require 'json'
require 'yaml'

base_url = "https://lab.asiainfodata.com:8443"
oapi_url = "/oapi/v1"
api_url = "/api/v1"

#initial http client
uri = URI.parse(base_url)
http = Net::HTTP.new(uri.host,uri.port)
http.use_ssl = true
http.cert =OpenSSL::X509::Certificate.new(File.read("./client-liujie.crt"))
http.key =OpenSSL::PKey::RSA.new((File.read("./client-liujie.key")), "")
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

cluster_path = "./cluster"
Dir.mkdir(cluster_path) if not File.exist?(cluster_path)

['namespaces','hosts','persistentvolumes'].each do |e|
  Dir.mkdir("#{cluster_path}/#{e}") if not File.exist?("#{cluster_path}/#{e}")
end


persistentvolumes = JSON.parse(http.request_get(api_url+"/persistentvolumes").body)['items']
persistentvolumes.each do |pv|
    File.open("#{cluster_path}/persistentvolumes/#{pv['metadata']['name']}", "w") { |file| file.write pv.to_yaml }
end if not persistentvolumes.empty?

hostsubnets = JSON.parse(http.request_get(oapi_url+"/hostsubnets").body)['items']
File.open("#{cluster_path}/#{hosts}/hostsubnets", "w") { |file| file.write hostsubnets.to_yaml }

projects = JSON.parse(http.request_get(oapi_url+"/projects").body)['items']

projects.each do |project|
  name = project['metadata']['name']
  namespaces_path = "#{cluster_path}/namespaces"

  Dir.mkdir("#{namespaces_path}/#{name}") if not File.exist?("#{namespaces_path}/#{name}")

  ['adminusers','buildconfigs','deploymentconfigs','persistentvolumeclaims'].each do |e|
    Dir.mkdir("#{namespaces_path}/#{name}/#{e}") if not File.exist?("#{namespaces_path}/#{name}/#{e}")
  end

  policybindings = JSON.parse(http.request_get(oapi_url+"/namespaces/#{name}/policybindings").body)['items']
  # p policybindings
  policybinding = policybindings.select { |pb| pb['metadata']['name'] == ":default" }.first
  if not ['openshift', 'openshift-infra', 'default'].include?(name) then
    rolebinding = policybinding['roleBindings'].select { |rb| rb['name'] == "admins" }.first
    users = rolebinding['roleBinding']['userNames']
    # p name + "--->" + users.to_s
  end
  File.open("#{namespaces_path}/#{name}/adminusers", "w") { |file| file.write users.to_yaml }

# export all buildconfigs in project
  buildconfigs = JSON.parse(http.request_get(oapi_url+"/namespaces/#{name}/buildconfigs").body)['items']
  buildconfigs.each do |bc|
    File.open("#{namespaces_path}/#{name}/buildconfigs/#{bc['metadata']['name']}", "w") { |file| file.write bc.to_yaml }
  end if not buildconfigs.empty?

# export all deploymentconfigs in project
  deploymentconfigs = JSON.parse(http.request_get(oapi_url+"/namespaces/#{name}/deploymentconfigs").body)['items']
  deploymentconfigs.each do |dc|
    File.open("#{namespaces_path}/#{name}/deploymentconfigs/#{dc['metadata']['name']}", "w") { |file| file.write dc.to_yaml }
  end if not deploymentconfigs.empty?

# export all pvcs in project
  persistentvolumeclaims = JSON.parse(http.request_get(api_url+"/namespaces/#{name}/persistentvolumeclaims").body)['items']
  # p persistentvolumeclaims
  persistentvolumeclaims.each do |pvc|
    # p pvc
    File.open("#{namespaces_path}/#{name}/persistentvolumeclaims/#{pvc['metadata']['name']}", "w") { |file| file.write pvc.to_yaml }
  end if not persistentvolumeclaims.empty?
  
end if not projects.empty?
