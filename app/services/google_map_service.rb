require 'net/http'
require 'json'

class GoogleMapService
  def self.get_location(user_location)
    puts "user_location - #{user_location}"
    begin 
      response = Net::HTTP.get_response(URI.parse(url(user_location)))
      json_response = JSON.parse(response.body)
      puts "json_response - #{json_response}"
      (json_response["status"].eql? "OK") ? location(json_response) : "others"
    rescue 
      "others"
    end
  end

  private
  def self.url(user_location)
    "http://maps.google.com/maps/api/geocode/json?address=#{cleanup(user_location)}&sensor=false" 
  end

  def self.location(json_response)
    json_response["results"].first["address_components"].select {|comp| comp["types"].include? "administrative_area_level_1" }.first["long_name"]
  end


  def self.cleanup(user_location)
    user_location.strip.gsub("\\",",").gsub("/",",").gsub(" ","").gsub("[","").gsub("]","")
  end
end
