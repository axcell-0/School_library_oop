require 'securerandom'
require_relative 'nameable'
class Person < Nameable
  attr_accessor :name, :age, :rentals, :parent_permission
  attr_reader :id
  def initialize(name: 'Unknown', age: 0, parent_permission: true, id: nil)
    super()
    @id = id || generate_id
    @name = name
    @age = age
    @parent_permission = parent_permission
    @rentals = []
  end
  def can_use_services?
    of_age? || @parent_permission
  end
  def correct_name
    @name
  end
  def add_rental(rental)
    rentals << rental
  end
  def to_json(*args)
    {
      id: @id,
      name: @name,
      age: @age,
      parent_permission: @parent_permission
    }.to_json(*args)
  end

  private

  def of_age?
    @age >= 18
  end

  def generate_id
    Random.rand(1...1000)
  end
end
