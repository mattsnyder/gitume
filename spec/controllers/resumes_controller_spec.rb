require 'spec_helper'

describe ResumesController do
  describe "#show" do
    context "when the username does not exist" do
      Given { ResumeRepository.stub(:find).with('ooops').and_return nil }
      When  { get :show, :username => 'ooops' }
      Then  { expect(response).to redirect_to(root_url) }
      And   { expect(flash[:warning]).to eql("The specified username does not appear to exist") }
    end

    context "when the username exists" do
      Given (:resume) { mock 'resume' }
      Given { ResumeRepository.stub(:find).with('validuser').and_return resume }
      When  { get :show, :username => 'validuser' }
      # Then  { expect(controller.resume).to eql(resume) }
      Then   { expect(response).to render_template('show') }
    end
  end
end
