require 'spec_helper'

describe Customer do
  before :each do
    @customer    = Fabricate(:customer)
  end
  
  it "is valid from the Fabric" do
    expect(@customer).to be_valid
  end
end