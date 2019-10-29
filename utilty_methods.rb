#This file contains all the utillity functions required to set the tests up

module Utility
	def Utility.clean_input(inp)
=begin
'Cleans the input and brings it in a standard form'
=end
		if(inp[0,7].downcase=="http://")
      inp = inp[7,inp.length()]
		elsif(inp[0,8].downcase=="https://")
      inp = inp[8,inp.length()]
    end
    if(inp[-1]=='/')
      inp = inp[0,inp.length()-1]
    end
		if(inp[0,4].downcase != 'www.')
			inp = 'www.'+inp
		end
    return inp
	end

	def Utility.validate?(host)
		#To validate the host i.e. if it is reachable or not
   check = Net::Ping::External.new(host)
   check.ping?
	end
end



module Factory
	#This module manufatures all the necessary params for making a request
	def Factory.make_final_url(inp,rest)
		#Just a simple function that manufactures the final url
		final_url = "http://" + inp + rest
		return final_url
	end

	def Factory.make_messege(path_to_form)
		#To get the json mssg from the form-data in case of a POST request
		doc = Nokogiri::HTML(File.open(path_to_form))

		#Get the input tags
		tags = doc.xpath("//input")
		messege = {}

		for tag in tags
			name = tag.attr('name')
			value = tag.attr('value')
			type = tag.attr('type')
			if(type.upcase != 'SUBMIT')
				messege[name] = value
			end
		end
		return messege

	end

	def Factory.get_file_data(path_to_form,path_to_file)
		#1. we have to send the form data along with the file
		#2. Get the form data jsonify it
		#3. then get the file.
		post_body = []                 #Packet to be sent
		filename = path_to_file      
		messege = {}                   #Form Data
    doc = Nokogiri::HTML(File.open(path_to_form))
		#Get the input tags 
		tags = doc.xpath("//input")
		for tag in tags
			name = tag.attr('name')
			value = tag.attr('value')
			type = tag.attr('type')
			if(type.upcase == "FILE")
				name_tag = name
			elsif(type.upcase != "SUBMIT")
				messege[name] = value
			end
		end
		messege = messege.to_json

		# NOW we need to write the file and form data to post_body
		boundary = "Aab03x"
		post_body << "--#{boundary}\r\n"
  	post_body << "Content-Disposition: form-data; name=name_tag; filename=\"#{File.basename(file)}\"\r\n"
  	post_body << "Content-Type: #{MIME::Types.type_for(file)}\r\n\r\n"
    post_body << File.read(file)

  	# Add the JSON
    post_body << "--#{boundary}\r\n"
    post_body << messege
    post_body << "\r\n\r\n--#{boundary}--\r\n"
		return post_body

	end

end

