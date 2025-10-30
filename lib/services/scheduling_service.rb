# frozen_string_literal: true
module Services
  class SchedulingService
    def initialize(store)
      @store = store
    end

    def assign_gate(flight_number, gate_name)
      flight = @store.flights.find { |f| f.number == flight_number }
      gate = @store.gates.find { |g| g.name == gate_name }
      return [false, "Flight or gate not found"] unless flight && gate
      return [false, "Invalid flight times"] unless flight.departs_at && flight.arrives_at

      conflict = @store.flights.any? do |f|
        next if f.number == flight.number || f.gate != gate.name
        overlap?(f.departs_at, f.arrives_at, flight.departs_at, flight.arrives_at)
      end
      return [false, "Gate conflict detected"] if conflict

      flight.gate = gate.name
      @store.save_all
      [true, "Gate assigned"]
    end

    def assign_runway(flight_number, runway_name)
      flight = @store.flights.find { |f| f.number == flight_number }
      rw = @store.runways.find { |r| r.name == runway_name }
      return [false, "Flight or runway not found"] unless flight && rw
      return [false, "Invalid flight times"] unless flight.departs_at && flight.arrives_at

      conflict = @store.flights.any? do |f|
        next if f.number == flight.number || f.runway != rw.name
        overlap?(f.departs_at, f.arrives_at, flight.departs_at, flight.arrives_at)
      end
      return [false, "Runway conflict detected"] if conflict

      flight.runway = rw.name
      @store.save_all
      [true, "Runway assigned"]
    end

    private

    def overlap?(a_start, a_end, b_start, b_end)
      (a_start...a_end).cover?(b_start) || (b_start...b_end).cover?(a_start)
    end
  end
end
