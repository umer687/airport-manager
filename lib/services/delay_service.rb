# frozen_string_literal: true
require_relative '../models/delay_record'

module Services
  class DelayService
    DEFAULT_RATE_PER_MINUTE = 1.0 # adjust if you want

    def initialize(store)
      @store = store
    end

    # Record a delay, update flight state, and compute compensation per passenger.
    def record_delay(flight_number:, minutes:, reason: "", rate_per_minute: DEFAULT_RATE_PER_MINUTE)
      flight = find_flight(flight_number)
      raise "Flight not found" unless flight
      raise "Invalid minutes" if minutes.to_i < 0
      if %w[departed cancelled].include?(flight.status.to_s)
        raise "Cannot record delay for flight with status '#{flight.status}'"
      end

      comp = compute_compensation(minutes, rate_per_minute)
      rec = Models::DelayRecord.new(
        flight_number: flight_number,
        minutes_delayed: minutes.to_i,
        reason: reason,
        compensation_per_passenger: comp
      )
      raise "Invalid delay record" unless rec.valid?

      # If your Flight has delay_minutes / status helpers, use them; otherwise do safe assignments.
      if flight.respond_to?(:delay_minutes=)
        flight.delay_minutes = minutes.to_i
      end
      if minutes.to_i > 0
        flight.status = "delayed" if flight.respond_to?(:status=)
      elsif flight.respond_to?(:status=)
        flight.status = "on-time"
      end

      @store.delays << rec if @store.respond_to?(:delays)
      @store.save_all
      rec
    end

    def delete_delay(delay_id)
      raise "No delays store" unless @store.respond_to?(:delays)
      before = @store.delays.size
      @store.delays.reject! { |d| d.id == delay_id }
      @store.save_all
      @store.delays.size < before
    end

    def delays_for_flight(flight_number)
      return [] unless @store.respond_to?(:delays)
      @store.delays.select { |d| d.flight_number == flight_number }
    end

    def latest_delay_for_flight(flight_number)
      delays_for_flight(flight_number).max_by { |d| d.created_at }
    end

    def compute_compensation(minutes, rate_per_minute = DEFAULT_RATE_PER_MINUTE)
      (minutes.to_i * rate_per_minute.to_f).round(2)
    end

    private

    def find_flight(flight_number)
      return nil unless @store.respond_to?(:flights)
      @store.flights.find { |f| f.number == flight_number }
    end
  end
end
