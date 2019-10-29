module Requests
	#This module consists of all the HTTP methods
	
	def Requests.make_request(final_url,method,payload = nil)
		#make the request based upon the method i.e GET, POST ,UPLOAD
		uri = URI.parse(final_url)
		http = Net::HTTP.new(uri.host , uri.port)

		method.upcase!

		if(method == 'GET')
			request = Net::HTTP::Get.new(uri.request_uri)
		
		elsif(method == 'POST')
			request = Net::HTTP::Post.new(uri.request_uri)
			request.set_form_data(payload)
		elsif(method == 'UPLOAD')
			request = Net::HTTP::Post.new(uri.request)
			request.body = payload.join
		end
		return http,request
	end

	def Requests.set_headers(request,hash)
		if(hash.key?("header"))
			temp = hash["header"]
			header_keys = temp.keys
			for key in header_keys
				request[key] = temp[key]
			end
		end
		return request
	end

	def Requests.send_request(request,http)
		begin
			response = http.request(request)
		rescue	Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			puts "Unable to get a response: #{e}"
			response = nil
		end
		return response
	end

	def Requests.process_response(response)
		output = {}
		if(response)
			#We can get the headers code and messege from the response
			#For now we will get the status code and the messege from the response
			output['code'] = response.code
			output['message'] = response.message
			output['class_name'] = response.class.name
		end
		return output
	end

end

module Test

	def Test.test_response(expected_output,obtained_output)
		failed = false
		data = []
		comparable_fields = expected_output.keys
		for field in comparable_fields
			if(expected_output[field] != obtained_output[field])
				 failed = true
			end
			data << "#{field} => expected : #{expected_output[field]} , obtained : #{obtained_output[field]}"
		end
    return failed,data
	end

	def Test.make_log_file(failed, pid, pname, stage, data)
		to_be_written = []
		to_be_written << "Process Name: #{pname}"
		to_be_written << "Process id: #{pid}"
		if(failed)
			to_be_written << "FAILURE"
			to_be_written << "Faliure Detected at stage #{stage}"
		else
			to_be_written << "PASSED"
			to_be_written << "Stage #{stage} passed"
		end
		to_be_written << data

		for info in to_be_written
			puts info
		end
    File.open("#{pid}_.log","a"){|f| f.puts to_be_written.to_yaml}
	end
end
