class TrimmerDecorator < Decorator\r
  def correct_name
    @nameable.correct_name[0, 10].strip
  end
end
