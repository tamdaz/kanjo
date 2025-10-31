require "./../spec_helper"

struct MainControllerTest < ATH::Spec::APITestCase
  def test_get_versions : Nil
    self.get "/versions"
    self.assert_response_is_successful
  end
end
