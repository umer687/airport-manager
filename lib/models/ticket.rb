# frozen_string_literal: true
module Models
  class Ticket
    attr_accessor :id, :booking_id, :seat

    def initialize(id:, booking_id:, seat:)
      @id = id
      @booking_id = booking_id
      @seat = seat
    end

    def to_h; { id: @id, booking_id: @booking_id, seat: @seat }; end
    def self.from_h(h); new(id: h["id"], booking_id: h["booking_id"], seat: h["seat"]); end
    def to_s; "Ticket #{@id} booking=#{@booking_id} seat=#{@seat}"; end
  end
end
