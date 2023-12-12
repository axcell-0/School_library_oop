require_relative 'app'

class Main
  def initialize
    @app = App.new
  end

  def run
    @app.run
  end
end

Main.new.run if __FILE__ == $PROGRAM_NAME
