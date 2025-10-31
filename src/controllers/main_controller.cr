# The main controller
class App::Controllers::MainController < ATH::Controller
  # Sends the Crystal and Athena Framework versions
  @[ARTA::Get("/versions")]
  def versions : Hash(Symbol, String)
    {
      :crystal => Crystal::VERSION,
      :athena  => Athena::Framework::VERSION,
    }
  end
end
