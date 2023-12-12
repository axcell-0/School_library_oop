class Teacher < Person
  attr_accessor :specialization

  def initialize(name:, age:, id:, specialization: 'Unknown', parent_permission: true)
    super(name: name, age: age, parent_permission: parent_permission, id: id)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end
