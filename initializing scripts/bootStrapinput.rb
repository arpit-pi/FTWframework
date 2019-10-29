require 'yaml'
  
urls = 'https://www.newyorker.com/'


File.open('input.yml','w'){|f| f.puts urls.to_yaml}
