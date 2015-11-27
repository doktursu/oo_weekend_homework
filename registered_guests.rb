module RegisteredGuests

  def update_registered_guests(guest)
    if @registered_guests.include?(guest)
      display_error "Guest already registered"
    else
      @registered_guests << guest
    end
  end

  def search_registered_guests(forename, surname)
    return display_error("No registered guests") if @registered_guests.length == 0

    search = @registered_guests.select { |registered_guest| registered_guest.forename == forename &&
      registered_guest.surname == surname }
    if search.length == 0
      display_error("Guest not found")
    else
      search[0]
    end
  end

end