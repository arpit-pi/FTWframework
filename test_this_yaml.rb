require 'yaml'

hash_array = YAML.load(File.read("test.conf"))


hash_array[0]['stages'].each do |key,value|
	hash = value
	puts hash['output']
end
