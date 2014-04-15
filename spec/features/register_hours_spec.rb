require 'spec_helper'

describe "Registered hours on a Task" do
  before :each do
    @artisan = Fabricate(:artisan, name: 'Josh')
    Fabricate(:paint, title: 'Acryl')
    Fabricate(:paint, title: 'Beis')
    Fabricate(:task_type, title: 'Muring')
    Fabricate(:task_type, title: 'Maling')
    Fabricate(:customer, name: 'Oslo Sporveier AS')
    @task = Fabricate(:task, artisan: @artisan, accepted: true)
  end

  it "An artisan can register hours on the tasks he is delegated" do
    visit artisan_path(@artisan)
    HoursSpent.all.size.should eq 0
    click_link "Aktive oppdrag"
    click_link "Registrer timer"
    fill_in 'Antall timer', with: 20
    fill_in 'Beskrivelse', with: 'Malt begge sider av veggen.'
    click_button 'Lagre'
    HoursSpent.all.size.should eq 1
  end

  
end