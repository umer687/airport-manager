# frozen_string_literal: true
require 'json'
require 'time'
require 'models/airport'
require 'models/flight'
require 'models/aircraft'
require 'models/gate'
require 'models/runway'
require 'models/passenger'
require 'models/booking'
require 'models/ticket'
require 'models/staff'

module Storage
  # JSONStore persists domain objects into JSON files under a directory.
  class JSONStore
    attr_reader :dir

    def initialize(dir)
      @dir = dir
      Dir.mkdir(@dir) unless Dir.exist?(@dir)
      load_all
    end

    def airports; @airports ||= []; end
    def flights; @flights ||= []; end
    def aircraft; @aircraft ||= []; end
    def gates; @gates ||= []; end
    def runways; @runways ||= []; end
    def passengers; @passengers ||= []; end
    def bookings; @bookings ||= []; end
    def tickets; @tickets ||= []; end
    def staff; @staff ||= []; end

    def add_airport(a); airports << a; end
    def remove_airport(code); airports.reject! { |a| a.code == code }; end

    def add_flight(f); flights << f; end
    def remove_flight(num); flights.reject! { |f| f.number == num }; end

    def add_passenger(p); passengers << p; end
    def remove_passenger(email); passengers.reject! { |p| p.email == email }; end

    def add_booking(b); bookings << b; end
    def add_ticket(t); tickets << t; end
    def remove_ticket(id); tickets.reject! { |t| t.id == id }; end

    def save_all
      write_json("airports.json", airports.map(&:to_h))
      write_json("flights.json", flights.map(&:to_h))
      write_json("aircraft.json", aircraft.map(&:to_h))
      write_json("gates.json", gates.map(&:to_h))
      write_json("runways.json", runways.map(&:to_h))
      write_json("passengers.json", passengers.map(&:to_h))
      write_json("bookings.json", bookings.map(&:to_h))
      write_json("tickets.json", tickets.map(&:to_h))
      write_json("staff.json", staff.map(&:to_h))
      true
    end

    def load_all
      @airports = read_json("airports.json").map { |h| Models::Airport.from_h(h) }
      @flights = read_json("flights.json").map { |h| Models::Flight.from_h(h) }
      @aircraft = read_json("aircraft.json").map { |h| Models::Aircraft.from_h(h) }
      @gates = read_json("gates.json").map { |h| Models::Gate.from_h(h) }
      @runways = read_json("runways.json").map { |h| Models::Runway.from_h(h) }
      @passengers = read_json("passengers.json").map { |h| Models::Passenger.from_h(h) }
      @bookings = read_json("bookings.json").map { |h| Models::Booking.from_h(h) }
      @tickets = read_json("tickets.json").map { |h| Models::Ticket.from_h(h) }
      @staff = read_json("staff.json").map { |h| Models::Staff.from_h(h) }
    end

    def export_all(filename)
      data = {
        airports: airports.map(&:to_h),
        flights: flights.map(&:to_h),
        aircraft: aircraft.map(&:to_h),
        gates: gates.map(&:to_h),
        runways: runways.map(&:to_h),
        passengers: passengers.map(&:to_h),
        bookings: bookings.map(&:to_h),
        tickets: tickets.map(&:to_h),
        staff: staff.map(&:to_h)
      }
      write_json(filename, data)
      true
    end

    def import_all(filename)
      data = read_json(filename)
      return false unless data.is_a?(Hash)
      @airports = (data["airports"] || []).map { |h| Models::Airport.from_h(h) }
      @flights = (data["flights"] || []).map { |h| Models::Flight.from_h(h) }
      @aircraft = (data["aircraft"] || []).map { |h| Models::Aircraft.from_h(h) }
      @gates = (data["gates"] || []).map { |h| Models::Gate.from_h(h) }
      @runways = (data["runways"] || []).map { |h| Models::Runway.from_h(h) }
      @passengers = (data["passengers"] || []).map { |h| Models::Passenger.from_h(h) }
      @bookings = (data["bookings"] || []).map { |h| Models::Booking.from_h(h) }
      @tickets = (data["tickets"] || []).map { |h| Models::Ticket.from_h(h) }
      @staff = (data["staff"] || []).map { |h| Models::Staff.from_h(h) }
      save_all
    end

    private

    def path(file)
      File.join(@dir, file)
    end

    def read_json(file)
      p = path(file)
      return [] unless File.exist?(p)
      JSON.parse(File.read(p))
    rescue JSON::ParserError
      []
    end

    def write_json(file, obj)
      File.write(path(file), JSON.pretty_generate(obj))
    end
  end
end
