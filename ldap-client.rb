require 'rubygems'
require 'net/ldap'


user, psw = "", ""
ldap = Net::LDAP.new
ldap.host = "172.30.158.138"
ldap.port = 389

ldap.auth "cn=xxx,dc=xxx,dc=xxx","xxx"

result = ldap.bind_as(:base => "dc=xxx,dc=xxx",
                      :filter => "(uid=#{user})",:password => psw)
if result
  puts "Authenticated #{result.first.dn}"
else
  puts "Authentication FAILED."
end

filter = Net::LDAP::Filter.eq("ou", "*")
treebase = "dc=xxx, dc=xxx"
p treebase
ldap.search(:base => treebase, :filter => filter) do |entry|
  puts "DN: #{entry.dn}"
  uid, userpassword = entry['uid'].first, entry['userpassword'].first
  puts uid, userpassword
  bind_filter = Net::LDAP::Filter.eq("uid", "#{uid}")
  result = ldap.bind_as(:base => "dc=openstack,dc=org",:filter => bind_filter,:password => userpassword)
  if result
    puts "Authenticated #{result.first.dn}"
  else
    puts "Authentication FAILED."
  end
#  entry.each do |attribute, values|
#    puts "   #{attribute}:"
#    values.each do |value|
#      puts "      --->#{value}"
#    end
#  end
end
