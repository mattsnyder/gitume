require 'spec_helper'

describe 'routing github usernames to their resume' do
  
  Then { expect(:get => '/mattsnyder').to route_to(:controller => 'resumes', :action => 'show', :username => 'mattsnyder') }

end
