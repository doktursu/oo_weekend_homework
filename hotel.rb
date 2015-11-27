require_relative "interactive"
require_relative "registered_guests"

class Hotel

  include Interactive
  include RegisteredGuests

  attr_reader :all_rooms, :bookings, :available_rooms, :unavailable_rooms
  # , :available_rooms, :guests

  def initialize()
    @all_rooms = {}
    # @available_single_rooms = {}
    # @available_double_rooms = {}
    @available_rooms = {}
    @unavailable_rooms = {}
    @bookings = {}
    # @booking_id = 0
    @guests = {}
    @registered_guests = []
  end


  ################## ROOMS ##################

  def add_rooms(*rooms)
    rooms.each { |room| @all_rooms[room.room_number] = room }
  end

  def num_of_available_rooms_of_type(type = nil)
    return all_rooms.length if !type
    rooms_of_type(type).length
  end

  def rooms_of_type(type = nil)
    return all_rooms.length if !type
    all_rooms.select { |room_number, room| room.type == type }
  end

  ################## UNAVAILABLE ROOMS ##################

  def update_unavailable_rooms(room)
    if @unavailable_rooms.has_key?(room.room_number)
      @unavailable_rooms.delete(room.room_number)
    else
      @unavailable_rooms[room.room_number] = room
    end
  end

  ################## AVAILABLE ROOMS ##################


  def type_available?(type)
    if num_of_available_rooms_of_type(type) > 0
      return true
    else
      return false
    end
  end

  def update_available_rooms(room)
    if @all_rooms.has_key?(room.room_number)
      @all_rooms.delete(room.room_number)
    else
      @all_rooms[room.room_number] = room
    end
  end

  ################## BOOKING / CHECK IN/OUT ##################

  # def create_booking(booking)
  #   if available?(booking)
  #     add_booking(booking)
  #   else
  #     display_error("The room is not available")
  #     puts "\n"
  #   end
  # end

  def available?(booking)
    type = booking.num_of_guests
    type_available?(type)
  end

  def add_booking(booking)
    allocate_room(booking)
    @bookings[booking.room.room_number] = booking
    booking.guest.add_booking(booking)
    update_registered_guests(booking.guest)
    update_available_rooms(booking.room)
    update_unavailable_rooms(booking.room)
  end

  def allocate_room(booking)
    type = booking.num_of_guests
    rooms_arr = @all_rooms.values.select { |room| room.type == type }
    booking.room = rooms_arr[0]
  end

  def search_booking(options = {})
  end

end

################## ERROR MESSAGE ##################

def display_error(value)
  puts "Error: #{value}"
end

################## METHOD GRAVEYARD ##################


# def num_of_available_rooms
#   all_rooms.length
# end

# def num_of_available_single_rooms
#   single_rooms.length
# end

# def num_of_available_double_rooms
#   double_rooms.length
# end

# def single_rooms
#   all_rooms.select { |room_number, room| room.type == 1 }
# end

# def double_rooms
#   all_rooms.select { |room_number, room| room.type == 2 }
# end