class Student < Person
  attr_accessor :classroom

  def initialize(name, age, id:, parent_permission: true, classroom: nil)
    super(name: name, age: age, parent_permission: parent_permission, id: id)
    @classroom = classroom
  end

  def play_hooky
    '¯\\_(ツ)_/¯'
  end

  def belongs_to_classroom?(classroom)
    @classroom == classroom
  end

  def assign_to_classroom(classroom)
    @classroom = classroom
    classroom.add_student(self)
  end
end
