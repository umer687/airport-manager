when "flight", "delay"
  number = ARGV[1]
  minutes = ARGV[2].to_i
  store = JSONStore.new
  service = Services::FlightService.new(store)
  flight = service.set_delay(number, minutes)
  puts "Flight #{flight.number} delayed by #{flight.delay_minutes} minutes (status: #{flight.status})"
