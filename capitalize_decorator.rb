class CapitalizeDecorator < Decorator\r
  def correct_name
    @nameable.correct_name.upcase
  end
end
