# frozen_string_literal: true
require 'securerandom'

module Services
  class BookingService
    def initialize(store)
      @store = store
    end

    def book(flight_number, passenger_email)
      flight = @store.flights.find { |f| f.number == flight_number }
      passenger = @store.passengers.find { |p| p.email == passenger_email }
      return nil unless flight && passenger
      return nil if flight.status == 'departed' # business rule

      # capacity check
      cap = aircraft_capacity_for(flight)
      booked = @store.tickets.count { |t| booking_for(t)&.flight_number == flight.number }
      return nil if cap && booked >= cap

      # ✅ NEW: baggage weight validation
      aircraft = @store.aircraft.find { |a| a.tail_number == flight.aircraft_tail }
      if aircraft && aircraft.respond_to?(:max_baggage_weight) && passenger.respond_to?(:total_baggage_weight)
        if passenger.total_baggage_weight > aircraft.max_baggage_weight
          raise "Baggage limit exceeded for #{passenger.email}"
        end
      end

      # booking creation
      b = Models::Booking.new(id: SecureRandom.uuid, flight_number: flight.number, passenger_email: passenger.email)
      @store.add_booking(b)
      seat = "#{('A'..'F').to_a.sample}#{rand(1..30)}"
      t = Models::Ticket.new(id: SecureRandom.uuid, booking_id: b.id, seat: seat)
      @store.add_ticket(t)
      @store.save_all
      t
    end

    def cancel(ticket_id)
      ticket = @store.tickets.find { |t| t.id == ticket_id }
      return false unless ticket
      @store.remove_ticket(ticket.id)
      @store.save_all
      true
    end

    private

    def aircraft_capacity_for(flight)
      return nil unless flight.aircraft_tail
      ac = @store.aircraft.find { |a| a.tail_number == flight.aircraft_tail }
      ac&.capacity
    end

    def booking_for(ticket)
      @store.bookings.find { |b| b.id == ticket.booking_id }
    end
  end
end
