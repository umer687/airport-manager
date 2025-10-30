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
require 'storage/json_store'
require 'services/booking_service'
require 'services/scheduling_service'

# CLI provides a simple text UI for the app.
class CLI
  def initialize
    @store = Storage::JSONStore.new(File.expand_path('../data', __dir__))
    @booking_service = Services::BookingService.new(@store)
    @scheduling = Services::SchedulingService.new(@store)
  end

  def run
    puts "Welcome to Airport Management System (Pure Ruby)"
    loop do
      puts "\nMain Menu:"
      puts "1) Airports"
      puts "2) Flights"
      puts "3) Passengers"
      puts "4) Bookings"
      puts "5) Scheduling"
      puts "6) Save All"
      puts "7) Export/Import"
      puts "0) Exit"
      print "Choose: "
      case gets&.strip
      when "1" then menu_airports
      when "2" then menu_flights
      when "3" then menu_passengers
      when "4" then menu_bookings
      when "5" then menu_scheduling
      when "6" then @store.save_all
      when "7" then menu_export_import
      when "0" then break
      else
        puts "Invalid option."
      end
    end
    puts "Goodbye."
  end

  def menu_airports
    loop do
      puts "\nAirports:"
      puts "1) List"; puts "2) Add"; puts "3) Remove"; puts "0) Back"
      print "Choose: "
      case gets&.strip
      when "1"
        @store.airports.each { |a| puts a.to_s }
      when "2"
        print "Code (IATA 3 letters): "; code = gets&.strip&.upcase
        print "Name: "; name = gets&.strip
        a = Models::Airport.new(code: code, name: name)
        if a.valid?
          @store.add_airport(a)
          puts "Added."
        else
          puts "Invalid airport: #{a.errors.join(', ')}"
        end
      when "3"
        print "Code to remove: "; code = gets&.strip&.upcase
        @store.remove_airport(code)
      when "0" then break
      else puts "Invalid"
      end
    end
  end

  def menu_flights
    loop do
      puts "\nFlights:"
      puts "1) List"; puts "2) Add"; puts "3) Remove"; puts "0) Back"
      print "Choose: "
      case gets&.strip
      when "1"
        @store.flights.each { |f| puts f.to_s }
      when "2"
        print "Number: "; number = gets&.strip&.upcase
        print "From (IATA): "; from = gets&.strip&.upcase
        print "To (IATA): "; to = gets&.strip&.upcase
        print "Departure (YYYY-MM-DD HH:MM): "; dep = Time.parse(gets&.strip).utc rescue nil
        print "Arrival (YYYY-MM-DD HH:MM): "; arr = Time.parse(gets&.strip).utc rescue nil
        flight = Models::Flight.new(number: number, from: from, to: to, departs_at: dep, arrives_at: arr)
        if flight.valid?
          @store.add_flight(flight)
          puts "Added."
        else
          puts "Invalid flight: #{flight.errors.join(', ')}"
        end
      when "3"
        print "Number to remove: "; number = gets&.strip&.upcase
        @store.remove_flight(number)
      when "0" then break
      else puts "Invalid"
      end
    end
  end

  def menu_passengers
    loop do
      puts "\nPassengers:"
      puts "1) List"; puts "2) Add"; puts "3) Remove"; puts "0) Back"
      print "Choose: "
      case gets&.strip
      when "1"
        @store.passengers.each { |p| puts p.to_s }
      when "2"
        print "Name: "; name = gets&.strip
        print "Email: "; email = gets&.strip
        p = Models::Passenger.new(name: name, email: email)
        if p.valid?
          @store.add_passenger(p)
          puts "Added."
        else
          puts "Invalid passenger: #{p.errors.join(', ')}"
        end
      when "3"
        print "Email to remove: "; email = gets&.strip
        @store.remove_passenger(email)
      when "0" then break
      else puts "Invalid"
      end
    end
  end

  def menu_bookings
    loop do
      puts "\nBookings:"
      puts "1) List"; puts "2) Create"; puts "3) Cancel"; puts "0) Back"
      print "Choose: "
      case gets&.strip
      when "1"
        @store.bookings.each { |b| puts b.to_s }
      when "2"
        print "Flight #: "; number = gets&.strip&.upcase
        print "Passenger Email: "; email = gets&.strip
        ticket = @booking_service.book(number, email)
        if ticket
          puts "Ticket issued: #{ticket.to_s}"
        else
          puts "Booking failed."
        end
      when "3"
        print "Ticket ID: "; id = gets&.strip
        if @booking_service.cancel(id)
          puts "Cancelled."
        else
          puts "Cancel failed."
        end
      when "0" then break
      else puts "Invalid"
      end
    end
  end

  def menu_scheduling
    loop do
      puts "\nScheduling:"
      puts "1) Assign Gate"; puts "2) Assign Runway"; puts "0) Back"
      print "Choose: "
      case gets&.strip
      when "1"
        print "Flight #: "; number = gets&.strip&.upcase
        print "Gate Name: "; gate = gets&.strip&.upcase
        ok, msg = @scheduling.assign_gate(number, gate)
        puts msg
      when "2"
        print "Flight #: "; number = gets&.strip&.upcase
        print "Runway Name: "; rw = gets&.strip&.upcase
        ok, msg = @scheduling.assign_runway(number, rw)
        puts msg
      when "0" then break
      else puts "Invalid"
      end
    end
  end

  def menu_export_import
    puts "1) Export all to data/export.json"
    puts "2) Import from data/export.json"
    print "Choose: "
    case gets&.strip
    when "1" then @store.export_all("export.json")
    when "2" then @store.import_all("export.json")
    else puts "Invalid"
    end
  end
end
