class Teacher < Person
  attr_accessor :specialization

  def initialize(age, name, specialization = 'Unknown')
    super(age: age, name: name, parent_permission: true)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end
