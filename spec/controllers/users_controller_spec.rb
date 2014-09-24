require 'spec_helper'

describe UsersController do

  before do
    @user = Fabricate(:user)
    sign_in @user
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET show" do
    it "assigns the requested task as @tasks" do
      tasks = [Fabricate(:task), Fabricate(:task)]
      tasks.each { |t| t.users << @user }
      get :show, {id: @user.to_param}, valid_session
      assigns(:tasks).should include(*tasks)
    end
  end

end