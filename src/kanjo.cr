require "./enums/**"
require "./models/**"
require "./listeners/**"
require "./controllers/**"
require "./repositories/**"

# kanjo _(japanese word)_ is a web application that allows to write the emotion journal and assess
# your feelings in you daily life.
# This tool helps you track and reflect on your emotions through daily journaling. Features include:
# - Simple emotion logging
# - Emotion history tracking
# - Data privacy
module Kanjo
  # Version of Kanjo.
  VERSION = "0.1.0"

  # Opens the database while Kanjo is on.
  class Database
    class_getter db : DB::Database do
      DB.open ENV["DATABASE_URL"]
    end
  end

  # Responsible of rendering the views.
  class Crinja
    class_getter env : ::Crinja do
      env = ::Crinja.new

      env.loader = ::Crinja::Loader::FileSystemLoader.new(Dir.current + "/templates/")

      env
    end
  end

  # Renders the template.
  def self.render(path : String, data = nil) : ATH::Response
    ATH::Response.new(Kanjo::Crinja.env.get_template(path).render(data))
  end
end
