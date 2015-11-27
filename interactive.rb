require_relative "hotel"
require_relative "room"
require_relative "guest"
require_relative "booking"

module Interactive

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


  def check_availability
    puts "\n"
    display_header "Availability"
    puts "\n"
    puts "Total Single Rooms:\t#{num_of_available_rooms_of_type(1)}"
    puts "Total Double Rooms:\t#{num_of_available_rooms_of_type(2)}"
    puts "\n"
  end

  private

    def instantiate_booking(guest)
      display_header "Booking Details"
      num_of_guests = prompt("Number of guests (1~2): ").to_i
      Booking.new({guest: guest, num_of_guests: num_of_guests})
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
      search_guest(forename, surname)
    end

    def search_guest(forename, surname)
      return display_error("No registered guests") if @registered_guests.length == 0

      search = @registered_guests.select { |registered_guest| registered_guest.forename == forename &&
        registered_guest.surname == surname }
      if search.length == 0
        display_error("Guest not found")
      else
        search[0]
      end
    end

    def prompt(args)
      print args
      gets.chomp.strip
    end

    def display_header(args)
      puts args.center(62, ' ')
      puts '-'.center(62, '-')
    end

end