module ApplicationHelper

  def learnershape_build?
    ENV['LS_BUILD'] == "true"
  end
end
