module UserHelper
  def to_read_shelf_fetched user
    if user.to_read_shelf
      user.to_read_shelf.count
    else
      "Fetching books..."
    end
  end
end
