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
http.cert =OpenSSL::X509::Certificate.new(File.read("./client-admin.crt"))
http.key =OpenSSL::PKey::RSA.new((File.read("./client-admin.key")), "")
http.verify_mode = OpenSSL::SSL::VERIFY_NONE


# get oauthaccesstokens 
oauthaccesstokens = JSON.parse(http.request_get(oapi_url+"/oauthaccesstokens").body)['items']
# p oauthaccesstokens

# get users
users = JSON.parse(http.request_get(oapi_url+"/users").body)['items']
# p users

# get projects
projects = JSON.parse(http.request_get(oapi_url+"/projects").body)['items']
# p projects

# get buildconfigs 
buildconfigs = JSON.parse(http.request_get(oapi_url+"/buildconfigs").body)
# puts buildconfigs.to_yaml


# get builds 
builds = JSON.parse(http.request_get(oapi_url+"/builds").body)['items']
# p builds.first

# get persistentvolumes 
persistentvolumes = JSON.parse(http.request_get(api_url+"/persistentvolumes").body)['items']
# p persistentvolumes

# get persistentvolumeclaims 
persistentvolumeclaims = JSON.parse(http.request_get(api_url+"/persistentvolumeclaims").body)['items']
# p persistentvolumeclaims

# get clusternetworks 
clusternetworks = JSON.parse(http.request_get(oapi_url+"/clusternetworks").body)['items']
# p clusternetworks

# get hostsubnets 
hostsubnets = JSON.parse(http.request_get(oapi_url+"/hostsubnets").body)['items']
hostsubnets.each { |host| p host['hostIP'] + "--->" + host['subnet']  }

# get policybindings
policybindings = JSON.parse(http.request_get(oapi_url+"/namespaces/liujie15/policybindings").body)['items']
# p policybindings

# get pods
pods = JSON.parse(http.request_get(api_url+"/pods").body)['items']
# p pods.first
