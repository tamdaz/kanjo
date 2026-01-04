@[ADI::Register]
# Controller used for rendering the views/pages.
class Kanjo::Controllers::PageController < ATH::Controller
  # Dependency injection.
  def initialize(@journal_repository : Kanjo::Repositories::JournalRepository); end

  @[ARTA::Get("/")]
  # Renders the dashboard page.
  def dashboard : ATH::Response
    journals = @journal_repository.find_all.map do |journal|
      {
        "date"     => journal.date.to_s("%Y-%m-%d"),
        "content"  => journal.content,
        "readonly" => journal.readonly?,
        "emotion"  => journal.emotion.to_s,
      }
    end

    Kanjo.render("pages/dashboard.html.j2", {
      :journals => journals,
    })
  end

  @[ARTA::Get("/journals/{date}")]
  # Renders the journal show page for a specific date.
  def show_journal(date : String) : ATH::Response
    journal_obj = @journal_repository.find(date)
    journal = {
      "date"     => journal_obj.date.to_s("%Y-%m-%d"),
      "content"  => journal_obj.content,
      "readonly" => journal_obj.readonly?,
      "emotion"  => journal_obj.emotion.to_s,
    }

    journals = @journal_repository.find_all.map do |j|
      {
        "date"     => j.date.to_s("%Y-%m-%d"),
        "content"  => j.content,
        "readonly" => j.readonly?,
        "emotion"  => j.emotion.to_s,
      }
    end

    Kanjo.render("pages/journal-show.html.j2", {
      :journal  => journal,
      :journals => journals,
    })
  end

  @[ARTA::Get("/journals")]
  # Renders the journals page.
  def journals : ATH::Response
    journals = @journal_repository.find_all.map do |journal|
      {
        "date"     => journal.date.to_s("%Y-%m-%d"),
        "content"  => journal.content,
        "readonly" => journal.readonly?,
        "emotion"  => journal.emotion.to_s,
      }
    end

    Kanjo.render("pages/journals.html.j2", {
      :journals => journals,
    })
  end

  @[ARTA::Get("/about")]
  # Renders the about page.
  def about : ATH::Response
    journals = @journal_repository.find_all.map do |journal|
      {
        "date"     => journal.date.to_s("%Y-%m-%d"),
        "content"  => journal.content,
        "readonly" => journal.readonly?,
        "emotion"  => journal.emotion.to_s,
      }
    end

    Kanjo.render("pages/about.html.j2", {
      :journals => journals,
    })
  end
end
