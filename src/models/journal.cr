# Model that represents the emotion journal.
class Kanjo::Models::Journal
  include DB::Serializable
  include JSON::Serializable

  # The date where the journal is saved.
  @[JSON::Field(converter: Time::Format.new("%Y-%m-%d"))]
  property date : Time

  # The journal content.
  property content : String

  # The journal can be readonly or not.
  property? readonly : Bool

  # The specified emotion for the journal.
  property emotion : Kanjo::Enums::Emotions

  # Converts the model into JSON.
  def to_json(io : IO) : Nil
    io << {
      "date"     => self.date.to_s("%Y-%m-%d"),
      "content"  => self.content,
      "readonly" => self.readonly?,
      "emotion"  => self.emotion.to_s,
    }
  end
end
