# frozen_string_literal: true
require_relative 'test_helper'
require 'storage/json_store'
require 'services/scheduling_service'
require 'models/flight'
require 'models/gate'
require 'models/runway'

class TestScheduler < Minitest::Test
  def setup
    @dir = File.join(Dir.pwd, "data_test_sched_#{rand(10000)}")
    Dir.mkdir(@dir) unless Dir.exist?(@dir)
    @store = Storage::JSONStore.new(@dir)
    @store.gates << Models::Gate.new(name: "A1")
    @store.runways << Models::Runway.new(name: "RWY1")

    dep1 = Time.now.utc + 3600
    arr1 = dep1 + 3600
    dep2 = dep1 + 600
    arr2 = dep2 + 3600
    @f1 = Models::Flight.new(number: "PK100", from: "KHI", to: "ISB", departs_at: dep1, arrives_at: arr1)
    @f2 = Models::Flight.new(number: "PK200", from: "KHI", to: "LHE", departs_at: dep2, arrives_at: arr2)
    @store.add_flight(@f1)
    @store.add_flight(@f2)
    @store.save_all
    @svc = Services::SchedulingService.new(@store)
  end

  def teardown
    Dir[@dir + "/*"].each { |f| File.delete(f) }
    Dir.rmdir(@dir)
  end

  def test_gate_conflict_detection
    ok, _ = @svc.assign_gate("PK100", "A1")
    assert ok, "first assignment should work"
    ok2, msg2 = @svc.assign_gate("PK200", "A1")
    refute ok2, "second assignment overlapping must fail"
    assert_match /conflict/i, msg2
  end

  def test_runway_conflict_detection
    ok, _ = @svc.assign_runway("PK100", "RWY1")
    assert ok, "first assignment should work"
    ok2, msg2 = @svc.assign_runway("PK200", "RWY1")
    refute ok2, "second assignment overlapping must fail"
    assert_match /conflict/i, msg2
  end
end
