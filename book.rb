class Book\r
  attr_accessor :title, :author, :rentals, :id

  def initialize(title, author, id: Random.rand(1...1000))
    @title = title
    @author = author
    @rentals = []
    @id = id
  end

  def add_rental(rental)
    rentals << rental
  end

  def to_json(_options = {})
    {
      title: @title,
      author: @author,
      'book.id': @id
    }.to_json
  end
end
