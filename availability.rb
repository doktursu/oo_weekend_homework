require 'date'

module Availability

  # def display_availability_on_date(dates = nil, type = nil)
  #   dates ||= [Date.today]
  #   puts "\n"
  #   display_header "Availability on #{dates.join(", ")}"
  #   puts "\n"
  #   single_rooms = available_rooms_on_date(dates, 1)
  #   puts "Total Single Rooms:\t#{single_rooms.length}"
  #   puts rooms_to_string(single_rooms)
  #   puts "\n"
  #   double_rooms = available_rooms_on_date(dates, 2)
  #   puts "Total Double Rooms:\t#{double_rooms.length}"
  #   puts rooms_to_string(double_rooms)
  #   puts "\n"
  # end
  def available?(booking)
    type = booking.num_of_guests
    available_rooms = available_rooms_on_dates(booking.dates, type)
    return false unless available_rooms
    return true
  end

  def available_rooms_on_dates(dates, type = nil)
    rooms = rooms_of_type(type)
    @bookings.each do |booking|
      unless (booking.dates & dates).empty?
        rooms.delete(booking.room.room_number)
      end
    end
    rooms
  end

  def bookings_on_date(date)
    @bookings.select do |booking|
      booking.dates.include?(date)
    end
  end

  def rooms_of_type(type = nil)
    return @all_rooms if !type
    @all_rooms.select { |room_number, room| room.type == type }
  end

end

# def num_of_available_rooms_of_type(type = nil)
#   return @available_rooms.length if !type
#   available_rooms_of_type(type).length
# end



# def display_availability
#   puts "\n"
#   display_header "Availability Tonight"
#   puts "\n"
#   puts "Total Single Rooms:\t#{num_of_available_rooms_of_type(1)}"
#   puts rooms_to_string(available_rooms_of_type(1))
#   puts "\n"
#   puts "Total Double Rooms:\t#{num_of_available_rooms_of_type(2)}"
#   puts rooms_to_string(available_rooms_of_type(2))
#   puts "\n"
# end