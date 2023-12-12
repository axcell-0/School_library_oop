require_relative 'app'

class Main
  def initialize
    @app = App.new
  end

  def run
    @app.load_data_if_needed
    @app.run
  end
end

Main.new.run if __FILE__ == $PROGRAM_NAME
