require "date"

require_relative "hotel"
require_relative "room"
require_relative "guest"
require_relative "booking"

module Interactive

  def hotel_menu
    puts "\n"
    puts "Hotel Menu".center(62, ' ')
    display_header "#{Time.now}"
    puts "\n"

    puts """1: Make a Booking
2: Check In
3: Check Out
4: Search Booking
5: Check Availability
6: Daily Log
7: View Registered Guests
8: View Revenue
0: Exit"""
    puts "\n"
    answer = prompt_i("Select option: ")

    case answer
    when 1
      make_booking
    when 2
      check_in
    when 3
      check_out
    when 4
      search_bookings
    when 5
      check_availability
    when 6
      view_log
    when 7
      view_registered_guests
    when 8
      view_revenue
    when 0
      exit
    else
      display_error("Invalid option")
    end
  end

  def make_booking
    puts "\n"
    display_header "Make a Booking"
    puts "\n"

    answer = prompt("Has the guest made a booking before? [y/n]: ").downcase.strip
    puts "\n"
    if answer == 'y'
      guest = retrieve_guest
      return unless guest
      puts "\n"
      puts "Found guest #{guest.full_name}"
      puts "\n"
    else 
      guest = instantiate_guest
      return unless guest
      puts "\n"
      puts "Created guest #{guest.full_name}"
      puts "\n"
    end

    booking = instantiate_booking(guest)
    return unless booking
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
    display_header "Check Availability"
    puts "\n"

    answer = prompt("Availability for only tonight? [y/n]: ").downcase.strip
    puts "\n"
    if answer == 'y'
      dates = [Date.today]
    else 
      day = prompt_i("Arrival day [1~31]: ")
      month = prompt_i("Arrival month [1~12]: ")
      year = prompt_i("Arrival year: ")
      nights = prompt_i("Number of nights: ")
      arrival_date = Date.new(year, month, day)
      dates = (0...nights).map { |n| arrival_date.next_day(n) }
    end

    puts "\n"
    puts "Availability for".center(62, ' ')
    display_header "#{dates.join(", ")}"
    puts "\n"
    single_rooms = available_rooms_on_dates(dates, 1)
    puts "Total Single Rooms:\t#{single_rooms.length}"
    puts rooms_to_string(single_rooms)
    puts "\n"
    double_rooms = available_rooms_on_dates(dates, 2)
    puts "Total Double Rooms:\t#{double_rooms.length}"
    puts rooms_to_string(double_rooms)
    puts "\n"
  end

  def search_bookings
    puts "\n"
    display_header "Search Bookings"
    puts "\n"

    answer = prompt_i("Search by? [1: Guest, 2: Date, 3: Display All]: ")
    puts "\n"
    if answer == 1
      guest = retrieve_guest()
      return unless guest
      bookings = guest.bookings
    elsif answer == 2
      day = prompt_i("Booking day [1~31]: ")
      month = prompt_i("Booking month [1~12]: ")
      year = prompt_i("Booking year: ")
      date = create_date(year, month, day)
      return unless date
      bookings = select_bookings_by_date(date)
    else
      bookings = nil
    end

    display_bookings(bookings)
  end

  def check_in(guest = nil)
    puts "\n"
    display_header "Check In"
    puts "\n"

    guest ||= retrieve_guest
    return unless guest
    puts "\n"
    puts "Found guest #{guest.full_name}"
    puts "\n"

    bookings = guest.bookings
    return display_error("Guest has no bookings") if bookings == []
    display_bookings(bookings)

    bookings_today = bookings.select { |booking| booking.dates.include?(Date.today) }
    return display_error("No bookings for today") if bookings_today == [] 

    answer = prompt("Check in? [y/n]: ").downcase.strip
    if answer == 'y'
      hotel_check_in(bookings_today)

      display_bookings(bookings_today)
      puts "#{guest.full_name} successfully checked in"
    end
  end

  def check_out(guest = nil)
    puts "\n"
    display_header "Check out"
    puts "\n"

    guest ||= retrieve_guest
    return unless guest
    puts "\n"
    puts "Found guest #{guest.full_name}"
    puts "\n"

    bookings = guest.bookings
    return display_error("Guest has no bookings") if bookings == []
    display_bookings(bookings)

    bookings_today = bookings.select { |booking| (booking.dates & [Date.today, Date.today.prev_day]).length > 0 }
    return display_error("No bookings for today") if bookings_today == [] 

    answer = prompt("Check out? [y/n]: ").downcase.strip
    if answer == 'y'
      hotel_check_out(bookings_today)

      display_bookings(bookings_today)
      puts "#{guest.full_name} successfully checked out"
    end
  end

  def view_log
    today = Date.today

    puts "\n"
    display_header "Hotel Log on #{today}"
    puts "\n"

    display_header "Total Guests in Hotel: #{total_guests_in_hotel()}"
    display_bookings(bookings_checked_in)


    display_header "Bookings to Check In Today"
    display_bookings(bookings_to_check_in)

    display_header "Bookings to Check Out Today"
    display_bookings(bookings_to_check_out)
  end

  def view_revenue
    puts "\n"
    display_header "Hotel Revenue: £#{revenue()}"
    puts "\n"
  end

  def view_registered_guests
    puts "\n"
    display_header "Registered Guests"
    puts "\n"

    @registered_guests.sort_by { |guest| guest.surname }.each { |guest| puts guest.full_name}
  end

  private

    def instantiate_booking(guest)
      display_header "Booking Details"
      puts "\n"
      num_of_guests = prompt_i("Number of guests [1~2]: ")
      day = prompt_i("Arrival day [1~31]: ")
      month = prompt_i("Arrival month [1~12]: ")
      year = prompt_i("Arrival year: ")
      date = create_date(year, month, day)
      return unless date
      nights = prompt_i("Number of nights: ")
      Booking.new({
        guest: guest, 
        num_of_guests: num_of_guests, 
        arrival_date: date,
        num_of_nights: nights
        })
    end

    def instantiate_guest
      display_header "Create a Guest"
      puts "\n"
      title = prompt("Title: ").capitalize
      forename = prompt "Forename: "
      surname = prompt "Surname: "
      Guest.new(title, forename, surname)
    end

    def retrieve_guest
      display_header "Search for Guest"
      puts "\n"
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

    def display_error(value)
      puts "\n"
      puts "Error: #{value}"
    end

    def rooms_to_string(rooms)
      rooms.map { |room_number, room| room.format }.join("\n")
    end

    def select_bookings_by_date(date)
      @bookings.select { |booking| booking.dates.include?(date) }
    end

    def create_date(year, month, day)
      begin
        Date.new(year, month, day)
      rescue ArgumentError
        puts "\n"
        display_error("Date not valid")
      end
    end

    def display_bookings(bookings = nil)
      bookings ||= @bookings
      puts "\n"
      display_header "Bookings"
      puts "\n"
      puts bookings.map { |booking| booking.format }.join("\n\n")
      puts "\n"
    end

end