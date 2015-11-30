require "pry-byebug"
require "date"

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
hotel.add_rooms(single_room, double_room, double_room_2, Room.new(1, :a04), Room.new(1, :a05), Room.new(2, :a06))

# Create a guest
guest = Guest.new('Mr.', 'Sky', 'Su')
booking = Booking.new({
  :guest => guest,
  :num_of_guests => 2,
  arrival_date: Date.new(2015, 11, 27),
  num_of_nights: 9 
  })

guest_2 = Guest.new('Mr.', 'Oscar', 'Brooks')
booking_2 = Booking.new({
  guest: guest_2,
  num_of_guests: 2,
  arrival_date: Date.new(2015, 11, 30),
  num_of_nights: 2
  })

guest_3 = Guest.new('Ms.', 'Evelyn', 'Utterson')
booking_3 = Booking.new({
  :guest => guest_3,
  :num_of_guests => 1,
  arrival_date: Date.new(2015, 11, 29),
  num_of_nights: 5
  })

guest_4 = Guest.new('Mr.', 'Jay', 'Chetty')
booking_4 = Booking.new({
  guest: guest_4, 
  room: single_room,
  num_of_guests: 1,
  arrival_date: Date.new(2015, 11, 27),
  num_of_nights: 3 
  })

guest_5 = Guest.new('Ms.', 'Valerie', 'Gibson')
booking_5 = Booking.new({
  :guest => guest_5,
  :num_of_guests => 2,
  arrival_date: Date.new(2015, 12, 01),
  num_of_nights: 4 
  })

# Add bookings

hotel.add_booking(booking)
hotel.hotel_check_in([booking])
hotel.add_booking(booking_2)
# hotel.hotel_check_in([booking_2])
hotel.add_booking(booking_3)
hotel.hotel_check_in([booking_3])
hotel.add_booking(booking_4)
hotel.hotel_check_in([booking_4])
hotel.add_booking(booking_5)
# hotel.hotel_check_in([booking_5])

while true
  hotel.hotel_menu()
end

binding.pry;''


