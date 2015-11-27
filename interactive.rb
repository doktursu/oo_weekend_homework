require_relative "hotel"
require_relative "room"
require_relative "guest"
require_relative "booking"

module Interactive

  @bookings

  def make_booking
    puts "\n"
    display_header "Make a Booking"
    puts "\n"

    answer = prompt("Has the guest made a booking before? [y/n]: ").downcase.strip
    puts "\n"
    if answer == 'y'
      guest = retrieve_guest
      return if !guest
      puts "\n"
      puts "Found guest #{guest.full_name}"
      puts "\n"
    else 
      guest = instantiate_guest
      puts "\n"
      puts "Created guest #{guest.full_name}"
      puts "\n"
    end

    booking = instantiate_booking(guest)
    puts "\n"

    unless available?(booking)
      display_error("The room is not available")
      puts "\n"
    else
      add_booking(booking)
      puts "Booking successfully created"
      puts "\n"
      puts booking.format
      puts "\n"
    end
  end


  def display_availability
    puts "\n"
    display_header "Availability Tonight"
    puts "\n"
    puts "Total Single Rooms:\t#{num_of_available_rooms_of_type(1)}"
    puts rooms_to_string(available_rooms_of_type(1))
    puts "\n"
    puts "Total Double Rooms:\t#{num_of_available_rooms_of_type(2)}"
    puts rooms_to_string(available_rooms_of_type(2))
    puts "\n"
  end

  def display_bookings
    puts "\n"
    display_header "Bookings"
    puts "\n"
    puts @bookings.map { |booking| booking.format }.join("\n")
    puts "\n"
  end

  private

    def instantiate_booking(guest)
      display_header "Booking Details"
      num_of_guests = prompt_i("Number of guests [1~2]: ")
      day = prompt_i("Arrival day [1~31]: ")
      month = prompt_i("Arrival month [1~12]: ")
      year = prompt_i("Arrival year: ")
      nights = prompt_i("Number of nights: ")
      Booking.new({
        guest: guest, 
        num_of_guests: num_of_guests, 
        arrival_date: Date.new(year, month, day), 
        num_of_nights: nights
        })
    end

    def instantiate_guest
      display_header "Create a Guest"
      title = prompt("Title: ").capitalize
      forename = prompt "Forename: "
      surname = prompt "Surname: "
      Guest.new(title, forename, surname)
    end

    def retrieve_guest
      display_header "Search for Guest"
      forename = prompt "Forename: "
      surname = prompt "Surname: "
      search_registered_guests(forename, surname)
    end

    def prompt(args)
      print args
      gets.chomp.strip
    end

    def prompt_i(args)
      print args
      gets.chomp.strip.to_i
    end

    def display_header(args)
      puts args.center(62, ' ')
      puts '-'.center(62, '-')
    end

    def rooms_to_string(rooms)
      rooms.map { |room_number, room| room.format }.join("\n")
    end

end