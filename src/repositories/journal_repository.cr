@[ADI::Register]
# Repository that is responsible of creating, updating and deleting the emotion journals.
class Kanjo::Repositories::JournalRepository
  # Retrieves all saved journals.
  def find_all : Array(Kanjo::Models::Journal)
    query = <<-SQL
    SELECT `date`, `content`, `readonly`, `emotion` FROM journals;
    SQL

    Kanjo::Models::Journal.from_rs(Kanjo::Database.db.query(query))
  end

  # Retrieves the journal by its date.
  def find(date : String) : Kanjo::Models::Journal
    query = <<-SQL
    SELECT `date`, `content`, `readonly`, `emotion`
    FROM journals
    WHERE DATE(`date`) = ?;
    SQL

    Kanjo::Database.db.query_one(query, date, as: Kanjo::Models::Journal)
  rescue DB::NoResultsError
    raise ATH::Exception::NotFound.new("The journal #{date} is not found.")
  end

  # Creates the journal.
  def create(date : String, content : String,
             readonly : Bool, emotion : Kanjo::Enums::Emotions) : Bool?
    Log.for("kanjo").debug &.emit("Creating the journal...", date: date)

    query = <<-SQL
    INSERT INTO
    journals (`date`, `content`, `readonly`, `emotion`)
    VALUES (DATETIME(?), ?, ?, ?);
    SQL

    db = Kanjo::Database.db.exec(query, date, content, readonly, emotion.to_s)

    Log.for("kanjo").info &.emit("Journal has been successfully created.", date: date)

    !db.nil?
  rescue e : SQLite3::Exception
    if e.message.as(String).includes?("UNIQUE constraint failed")
      Log.for("kanjo").debug &.emit("Journal #{date} already exists.", date: date)

      raise ATH::Exception::BadRequest.new("The journal #{date} already exists.")
    end
  end

  # Updates the existing journal.
  def update(date : String, content : String,
             readonly : Bool, emotion : Kanjo::Enums::Emotions) : Bool
    self.find(date)

    Log.for("kanjo").debug &.emit("Updating the journal #{date}...", date: date)

    query = <<-SQL
    UPDATE journals
    SET `content` = ?, `readonly` = ?, `emotion` = ?
    WHERE DATE(`date`) = ?;
    SQL

    db = Kanjo::Database.db.exec(query, content, readonly, emotion.to_s, date)

    Log.for("kanjo").info &.emit("The journal #{date} has been successfully updated.", date: date)

    !db.nil?
  end

  # Deletes the journal.
  def delete(date : String) : Bool
    self.find(date)

    Log.for("kanjo").debug &.emit("Deleting the journal #{date}...", date: date)

    query = <<-SQL
    DELETE FROM journals WHERE DATE(`date`) = ?;
    SQL

    db = Kanjo::Database.db.exec(query, date)

    Log.for("kanjo").info &.emit("The journal #{date} has been successfully deleted.", date: date)

    !db.nil?
  end
end
