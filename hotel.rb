require_relative "interactive"
require_relative "registered_guests"
require_relative "availability"

class Hotel

  include Interactive
  include RegisteredGuests
  include Availability

  attr_reader :all_rooms, :bookings, :available_rooms, :unavailable_rooms, :registered_guests

  def initialize()
    @all_rooms = {}
    @bookings = []
    @registered_guests = []
  end


  ################## ROOMS ##################

  def add_rooms(*rooms)
    rooms.each do |room| 
      @all_rooms[room.room_number] = room
    end
  end

  ################## BOOKING / CHECK IN/OUT ##################


  def add_booking(booking)
    allocate_room(booking) unless booking.room
    booking.calc_price()
    @bookings << booking
    booking.guest.add_booking(booking)
    update_registered_guests(booking.guest)
  end

  def allocate_room(booking)
    type = booking.num_of_guests
    available_rooms = available_rooms_on_dates(booking.dates, type)
    booking.room = available_rooms.values[0]
  end

  def hotel_check_in(bookings)
    bookings.each { |booking| booking.check_in }
  end

  def hotel_check_out(bookings)
    bookings.each { |booking| booking.check_out }
  end

  def bookings_checked_in
    @bookings.select { |booking| booking.checked_in == true }
  end

  def bookings_checked_out
    @bookings.select { |booking| booking.checked_in == false }
  end

  def guests_checked_in
    bookings_checked_in.map { |booking| booking.guest }
  end

  def guests_checked_out
    bookings_checked_out.map { |booking| booking.guest }
  end

  def total_guests_in_hotel
    bookings_checked_in.map { |booking| booking.num_of_guests }.reduce(:+)
  end

  def bookings_to_check_in(date = Date.today)
    bookings_checked_out.select { |booking| booking.dates[0] == date }
  end

  def bookings_to_check_out(date = Date.today)
    bookings_checked_in.select { |booking| booking.dates[-1].next == date }
  end

  ################## REVENUE ##################

  def revenue
    @bookings.map { |booking| booking.price }.reduce(:+)
  end

end

################## METHOD GRAVEYARD ##################
