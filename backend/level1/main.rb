require "json"
require "date"

class Rentals
  
  attr_reader :rental_options

  def initialize(input_file)
    input_data = JSON.parse(File.read(input_file))
    @rental_options = Hash.new
    @rental_options["rentals"] = []
    @car_data = input_data["cars"]
    @rental_data = input_data["rentals"]
    @car_data.each {|car|
      @rental_data.each { |rental|
        if car["id"]  == rental["car_id"]
          end_date, start_date = rental["end_date"], rental["start_date"]
          # + 1 because the start/date itself also counts
          duration = 1 + (Date.parse(end_date) - Date.parse(start_date)).to_i
          total_price = car["price_per_day"] * duration
          total_price += (car["price_per_km"] * rental["distance"])
          rental_hash = Hash["id", rental["id"]]
          rental_hash["price"] = total_price 
          @rental_options["rentals"] << rental_hash
        end
      }
    }
  end

end

rental = Rentals.new("data.json")
File.write("output.json", JSON.pretty_generate(rental.rental_options))
