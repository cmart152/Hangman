require 'json'

name = "chet"
filename = "saved/#{name}.json"

File.open(filename, 'r') do
puts JSON.generate('["h","f","e","c"]')
end