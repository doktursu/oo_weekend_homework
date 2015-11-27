module RegisteredGuests

  def update_registered_guests(guest)
    if @registered_guests.include?(guest)
      display_error "Guest already registered"
    else
      @registered_guests << guest
    end
  end

end