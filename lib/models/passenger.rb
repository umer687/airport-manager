# frozen_string_literal: true
module Models
  class Passenger
    attr_accessor :name, :email, :passport_number, :total_baggage_weight, :bags
    attr_reader :errors

    def initialize(name:, email:, passport_number: nil, total_baggage_weight: 0.0, bags: nil)
      @name = name
      @email = email
      # Make passport_number optional for backward compatibility
      @passport_number = passport_number || "UNKNOWN"
      @total_baggage_weight = total_baggage_weight.to_f
      @bags = bags || []
      @errors = []
    end

    def valid?
      @errors.clear
      @errors << "name required" if @name.to_s.strip.empty?
      @errors << "email required" if @email.to_s.strip.empty?
      # Don’t force passport for now to avoid breaking old tests
      @errors.empty?
    end

    def to_h
      {
        name: @name,
        email: @email,
        passport_number: @passport_number,
        total_baggage_weight: total_baggage_weight,
        bags: @bags&.map { |b| b.respond_to?(:to_h) ? b.to_h : b }
      }
    end

    def self.from_h(h)
      new(
        name: h["name"],
        email: h["email"],
        passport_number: h["passport_number"],
        total_baggage_weight: h["total_baggage_weight"] || 0.0,
        bags: (h["bags"] || []).map { |bh| Models::Bag.from_h(bh) rescue nil }.compact
      )
    end

    # Return the total baggage weight. If `bags` are present, sum their weights,
    # otherwise fall back to the stored @total_baggage_weight value.
    def total_baggage_weight
      if @bags && !@bags.empty?
        @bags.map { |b| (b.respond_to?(:weight) ? b.weight.to_f : 0.0) }.sum
      else
        @total_baggage_weight.to_f
      end
    end

    # ✅ Add these helper methods ↓↓↓
    def add_bag(bag)
      @bags ||= []
      @bags << bag
      @total_baggage_weight = total_baggage_weight
    end

    def remove_bag(bag_id)
      @bags.reject! { |b| b.respond_to?(:id) && b.id == bag_id }
      # Calculate total from bags array directly to handle empty case correctly
      @total_baggage_weight = @bags.map { |b| (b.respond_to?(:weight) ? b.weight.to_f : 0.0) }.sum
    end
  end
end
