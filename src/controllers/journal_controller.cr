@[ADI::Register]
@[ARTA::Route("/api/journals")]
# Controller that enables to process the emotion journal.
class Kanjo::Controllers::JournalController < ATH::Controller
  # Dependency injection.
  def initialize(@journal_repository : Kanjo::Repositories::JournalRepository); end

  @[ARTA::Get("/")]
  # Returns an array of journals.
  def index : Array(Kanjo::Models::Journal)
    @journal_repository.find_all
  end

  @[ARTA::Get("/{date}")]
  # Returns the selected journal by its date.
  def show(date : String) : Kanjo::Models::Journal
    @journal_repository.find(date)
  end

  @[ARTA::Post("/create/{date}")]
  # Creates the journal.
  def create(date : String, content : String,
             emotion : Kanjo::Enums::Emotions, readonly : Bool) : ATH::Response
    current_date = Time.local
    parsed_date = Time.parse_local(date, "%F")

    Log.for("kanjo").debug &.emit(
      "Current and defined date",
      current_date: current_date, parsed_date: parsed_date
    )

    # Raise an exception if the user creates a journal in the future.
    if parsed_date > current_date
      raise ATH::Exception::BadRequest.new("Creating a journal in the future is not possible.")
    end

    @journal_repository.create(date, content, readonly, emotion)

    ATH::Response.new({
      :code    => 201,
      :message => "Journal has been successfully created.",
    }.to_json, status: 201)
  end

  @[ARTA::Put("/update/{date}")]
  # Updates the journal by its date.
  def update(date : String, content : String,
             emotion : Kanjo::Enums::Emotions, readonly : Bool) : ATH::Response
    # Verify that the journal is not readonly before updating
    journal = @journal_repository.find(date)

    if journal.readonly?
      raise ATH::Exception::BadRequest.new("Cannot modify a readonly journal.")
    end

    @journal_repository.update(date, content, readonly, emotion)

    ATH::Response.new({
      :code    => 200,
      :message => "Journal has been successfully updated.",
    }.to_json)
  end

  @[ARTA::Delete("/delete/{date}")]
  # Deletes the selected journal by its date.
  def delete(date : String) : ATH::Response
    @journal_repository.delete(date)

    ATH::Response.new({
      :code    => 200,
      :message => "Journal has been successfully deleted.",
    }.to_json)
  end
end
