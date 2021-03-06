require 'spec_helper'

describe ExcelProjectTools do

  before do
    @project = Fabricate(:project)
    @user1 = Fabricate(:user, first_name: 'John')
    @snekker_profession = Fabricate(:profession, title: 'Snekker')
    @snekker1 = Fabricate(:user, first_name: 'Snekker', last_name: 'Jens',
      profession: @snekker_profession)
    @snekker2 = Fabricate(:user, first_name: 'Snekker', last_name: '2',
      profession: @snekker_profession)
    @task = Fabricate(:task, project: @project)
    @user1.tasks << @task
    @snekker1.tasks << @task
    @snekker2.tasks << Fabricate(:task, project: @project)

    Fabricate(:hours_spent, approved: true, hour: 10, task: @task, user: @user1 )
    Fabricate(:hours_spent, approved: true, hour: 10, task: @task, user: @user1 )
    @hours_for_jens = Fabricate(:hours_spent, approved: true, hour: 19,
                                overtime_50: 50, task: @task, user: @snekker1 )
  end

  it 'comma separated string with billable hours' do
    snekker = Profession.where(title: 'Snekker')
    ExcelProjectTools.hours_for_users(project: @project, overtime: :hour,
      of_kind: :billable, profession: snekker ).should eq ['19']
    ExcelProjectTools.hours_for_users(project: @project, overtime: :overtime_50,
      of_kind: :billable, profession: snekker ).should eq ['50']
  end


  it %q{returns a comma separated string of names for profession} do
    ExcelProjectTools.user_names(project: @project,
      profession_title: 'Snekker').to_s.should match(@snekker1.name)
  end

  it 'sum_piecework_hours' do
    Fabricate(:hours_spent, piecework_hours: 10,
              task: @task, user: @user1, project: @project, approved: true)
    ExcelProjectTools.sum_piecework_hours(project: @project, of_kind: :billable,
                                          user: @user1 ).should eq 10
  end

  it 'sum_workhours' do
    Fabricate(:hours_spent, piecework_hours: 16, task: @task, user: @user1,
              project: @project, of_kind: :billable, approved: true)
    ExcelProjectTools.sum_piecework_hours(project: @project, user: @user1,
                                          of_kind: :billable ).should eq 16
  end

  it 'sum_overtime_50' do
    Fabricate(:hours_spent, piecework_hours: 50,
              task: @task, user: @user1, project: @project, approved: true )
    ExcelProjectTools.sum_piecework_hours(project: @project, user: @user1,
                                          of_kind: :billable ).should eq 50
  end

  it 'sum_overtime_100' do
    Fabricate(:hours_spent, piecework_hours: 100, approved: true,
              task: @task, user: @user1, project: @project )
    ExcelProjectTools.sum_piecework_hours(project: @project, of_kind: :billable,
                                          user: @user1 ).should eq 100
  end

end
