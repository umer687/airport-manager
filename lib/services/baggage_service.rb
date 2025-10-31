# frozen_string_literal: true
module Services
  class BaggageService
    def initialize(store)
      @store = store
    end

    def add_bag(passenger_email, weight)
      passenger = @store.passengers.find { |p| p.email == passenger_email }
      raise "Passenger not found" unless passenger

      bag = Models::Bag.new(weight: weight)
      raise "Invalid bag" unless bag.valid?

      passenger.add_bag(bag)
      @store.save_all
      bag
    end

    def remove_bag(passenger_email, bag_id)
      passenger = @store.passengers.find { |p| p.email == passenger_email }
      raise "Passenger not found" unless passenger

      passenger.remove_bag(bag_id)
      @store.save_all
      true
    end

    def list_bags(passenger_email)
      passenger = @store.passengers.find { |p| p.email == passenger_email }
      passenger ? passenger.bags : []
    end
  end
end

