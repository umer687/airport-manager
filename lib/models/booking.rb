# frozen_string_literal: true
module Models
  class Booking
    attr_accessor :id, :flight_number, :passenger_email, :created_at

    def initialize(id:, flight_number:, passenger_email:, created_at: Time.now.utc)
      @id = id
      @flight_number = flight_number
      @passenger_email = passenger_email
      @created_at = created_at
    end

    def to_h
      { id: @id, flight_number: @flight_number, passenger_email: @passenger_email, created_at: @created_at.utc.iso8601 }
    end

    def self.from_h(h)
      new(id: h["id"], flight_number: h["flight_number"], passenger_email: h["passenger_email"], created_at: Time.parse(h["created_at"]))
    end

    def to_s
      "Booking #{@id} flight=#{@flight_number} passenger=#{@passenger_email}"
    end
  end
end
