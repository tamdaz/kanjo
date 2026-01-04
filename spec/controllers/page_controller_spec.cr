require "./../spec_helper"

struct PageControllerSpec < ATH::Spec::APITestCase
  def test_page_dashboard : Nil
    self.get "/"
    self.assert_response_is_successful
  end

  def test_page_journals : Nil
    self.get "/journals"
    self.assert_response_is_successful
  end

  def test_page_about : Nil
    self.get "/about"
    self.assert_response_is_successful
  end
end
