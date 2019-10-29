#This Script runs the tests.
#For a input many corresponding tests are generated.
#And the obtained results are tested against the expected results.
#The conclusions are then written to a corrsponding log file.
require './http_methods.rb'
require_relative './utilty_methods.rb'
require 'nokogiri'
require 'net/http'
require 'net/ping'
require 'yaml'
require 'json'
require 'uri'
require 'mime/types'

inp = YAML.load(File.read("input.yml"))
#puts inp

inp = Utility.clean_input(inp)
if(not Utility.validate?(inp))
	abort 'The input adress is not reachable! Change the path or try again later :)'
end

#there can be one or many test files and each test file can contain multiple tests
#And each test can contain multiple stages

test_hash_array = YAML.load(File.read("test.conf"))



for test_hash in test_hash_array
  failed = false                 #To verify if the test has passed or failed 
	puts "Running the test for #{test_hash['test_name']} and id : #{test_hash['test_id']}" 
	test_hash['stages'].each do |stage,params|            

		puts "Running Stage #{stage}"
		final_url = Factory.make_final_url(inp,params['url'])
	
		
    #Make Request
		if(params['method'].upcase == 'GET')
			http,request = Requests.make_request(final_url,params['method'],nil)


		elsif(params['method'].upcase == 'POST')
			messege = Factory.make_messege(params['data'])
			http,request = Requests.make_request(final_url,params['method'],messege)


		elsif(params['method'].upcase == 'UPLOAD')
			post_data = get_file_data(params['data'],params['file'])
			http,request = Requests.make_request(final_url,params['method'],post_data)
		end
		

		#Set The Headers if available and send request
		request = Requests.set_headers(request,params)

		response = Requests.send_request(request,http)
		


		obtained_output = Requests.process_response(response)


		expected_output = params['output']
    
		#Compare the results
		failed, data = Test.test_response(expected_output,obtained_output)
    
		Test.make_log_file(failed,test_hash['test_id'],test_hash['test_name'],stage,data)
		
		break if failed
	end
	puts "=================================================================>"
end

