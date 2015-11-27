require "pry-byebug"

require_relative "hotel"
require_relative "room"
require_relative "guest"
require_relative "booking"
require_relative "interactive"

# Create a hotel
hotel = Hotel.new()

# Create rooms
# 1 single room(s), 1 double room(s)
single_room = Room.new(1, :a01)
double_room = Room.new(2, :a02)
double_room_2 = Room.new(2, :a03)

# Add rooms to hotel
hotel.add_rooms(single_room, double_room, double_room_2)

# Create a guest
guest = Guest.new('Mr.', 'Sky', 'Su')
booking = Booking.new({
  :guest => guest,
  :num_of_guests => 2
  })

guest_2 = Guest.new('Mr.', 'Oscar', 'Brooks')
booking_2 = Booking.new({
  :guest => guest_2,
  :num_of_guests => 2
  })

guest_3 = Guest.new('Ms.', 'Evelyn', 'Utterson')
booking_3 = Booking.new({
  :guest => guest_3,
  :num_of_guests => 2
  })

guest_4 = Guest.new('Mr.', 'Jay', 'Chetty')
booking_4 = Booking.new({
  guest: guest_4, 
  room: single_room,
  num_of_guests: 1 
  })

# Add bookings
hotel.add_booking(booking)

binding.pry;''
