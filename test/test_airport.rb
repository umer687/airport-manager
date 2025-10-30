# frozen_string_literal: true
require_relative 'test_helper'
require 'models/airport'

class TestAirport < Minitest::Test
  def test_valid_iata
    a = Models::Airport.new(code: "KHI", name: "Karachi")
    assert a.valid?, "Expected valid airport"
  end

  def test_invalid_iata
    a = Models::Airport.new(code: "K4", name: "Bad")
    refute a.valid?, "Airport with invalid IATA must be invalid"
  end
end
