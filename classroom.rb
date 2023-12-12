class Classroom\r
  attr_accessor :label, :students

  def initialize(label)
    @label = label
    @students = []
  end

  def add_student(student)
    students << student
    student.classroom = self if student.is_a?(Student)
  end
end
