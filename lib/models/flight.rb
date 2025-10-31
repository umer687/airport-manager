# frozen_string_literal: true
require 'utils/validation'

module Models
  # Flight between airports with gate/runway assignments.
  class Flight
    include Utils::Validation
    STATUSES = %w[scheduled boarding departed arrived delayed cancelled on-time].freeze

    attr_accessor :number, :from, :to, :departs_at, :arrives_at, :status, :gate, :runway, :aircraft_tail, :delay_minutes
    attr_reader :errors

    def initialize(number:, from:, to:, departs_at:, arrives_at:, status: 'scheduled', gate: nil, runway: nil, aircraft_tail: nil)
      @number = number&.upcase
      @from = from&.upcase
      @to = to&.upcase
      @departs_at = departs_at
      @arrives_at = arrives_at
      @status = status
      @gate = gate
      @runway = runway
      @aircraft_tail = aircraft_tail
      @delay_minutes = 0
      @errors = []
    end

    def valid?
      @errors.clear
      @errors << "number required" unless present?(@number)
      @errors << "from IATA required" unless valid_iata?(@from)
      @errors << "to IATA required" unless valid_iata?(@to)
      @errors << "time order invalid" unless time_order?(@departs_at, @arrives_at)
      @errors << "status invalid" unless STATUSES.include?(@status)
      @errors.empty?
    end

    def to_s
      "Flight #{@number} #{@from}->#{@to} dep=#{@departs_at} arr=#{@arrives_at} status=#{@status} gate=#{@gate} runway=#{@runway}"
    end

    def delayed?
      @delay_minutes > 0
    end

    def apply_delay(minutes)
      raise "Cannot delay flight with status '#{@status}'" if %w[departed cancelled].include?(@status)
      @delay_minutes = minutes.to_i
      @status = "delayed" if @delay_minutes > 0
    end

    def reset_delay
      @delay_minutes = 0
      @status = "on-time" if @status == "delayed"
    end

    def to_h
      super_hash = {
        number: @number, from: @from, to: @to,
        departs_at: @departs_at&.utc&.iso8601,
        arrives_at: @arrives_at&.utc&.iso8601,
        status: @status, gate: @gate, runway: @runway,
        aircraft_tail: @aircraft_tail
      }
      super_hash[:delay_minutes] = @delay_minutes if @delay_minutes&.positive?
      super_hash
    end

    def self.from_h(h)
      new(
        number: h["number"],
        from: h["from"],
        to: h["to"],
        departs_at: h["departs_at"] && Time.parse(h["departs_at"]),
        arrives_at: h["arrives_at"] && Time.parse(h["arrives_at"]),
        status: h["status"],
        gate: h["gate"],
        runway: h["runway"],
        aircraft_tail: h["aircraft_tail"]
      ).tap do |f|
        f.delay_minutes = h["delay_minutes"].to_i if h["delay_minutes"]
      end
    end
  end
end
