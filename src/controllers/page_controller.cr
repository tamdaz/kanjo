@[ADI::Register]
# Controller used for rendering the views/pages.
class Kanjo::Controllers::PageController < ATH::Controller
  # Dependency injection.
  def initialize(@journal_repository : Kanjo::Repositories::JournalRepository); end

  @[ARTA::Get("/")]
  # Renders the dashboard page.
  def dashboard : ATH::Response
    Kanjo.render("pages/dashboard.html.j2", {
      :journals => get_all_journals,
    })
  end

  @[ARTA::Get("/journals/{date}")]
  # Renders the journal show page for a specific date.
  def show_journal(date : String) : ATH::Response
    journal = journal_to_hash(@journal_repository.find(date))
    journals = get_all_journals

    Kanjo.render("pages/journal-show.html.j2", {
      :journal  => journal,
      :journals => journals,
    })
  end

  @[ARTA::Get("/journals/{date}/edit")]
  # Renders the journal edit page for a specific date.
  def edit_journal(date : String) : ATH::Response
    journal_obj = @journal_repository.find(date)

    # Redirect to show page if journal is readonly
    if journal_obj.readonly?
      return ATH::RedirectResponse.new("/journals/#{date}")
    end

    journal = journal_to_hash(journal_obj)
    journals = get_all_journals

    Kanjo.render("pages/journal-edit.html.j2", {
      :journal  => journal,
      :journals => journals,
    })
  end

  @[ARTA::Get("/journals")]
  # Renders the journals page.
  def journals : ATH::Response
    journals = get_all_journals

    Kanjo.render("pages/journals.html.j2", {
      :journals => journals,
    })
  end

  @[ARTA::Get("/about")]
  # Renders the about page.
  def about : ATH::Response
    journals = get_all_journals

    Kanjo.render("pages/about.html.j2", {
      :journals => journals,
    })
  end

  # Private methods to avoid code duplication
  private def journal_to_hash(journal) : Hash(String, String | Bool)
    {
      "date"     => journal.date.to_s("%Y-%m-%d"),
      "content"  => journal.content,
      "readonly" => journal.readonly?,
      "emotion"  => journal.emotion.to_s,
    }
  end

  private def get_all_journals : Array(Hash(String, String | Bool))
    @journal_repository.find_all.map do |journal|
      journal_to_hash(journal)
    end
  end
end
