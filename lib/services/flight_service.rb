module Services
  class FlightService
    def initialize(store)
      @store = store
    end

    def set_delay(flight_number, minutes)
      flight = @store.flights.find { |f| f.number == flight_number }
      raise "Flight not found" unless flight
      flight.apply_delay(minutes)
      @store.save_all
      flight
    end

    def reset_delay(flight_number)
      flight = @store.flights.find { |f| f.number == flight_number }
      raise "Flight not found" unless flight
      flight.reset_delay
      @store.save_all
      flight
    end

    def delayed_flights
      @store.flights.select(&:delayed?)
    end
  end
end
