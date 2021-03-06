# == Schema Information
#
# Table name: skills
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Skill do
  context 'a Task requires certain skills to be completed' do
    let(:welding)  { Fabricate(:skill, title: 'welding') }
    let(:painting) { Fabricate(:skill, title: 'painting') }
    let(:task) { Fabricate(:task, skills: [welding, painting]) }
    let(:user) { Fabricate(:user, skills: [welding, painting]) }

    describe 'relationships' do
      it 'belongs to a task' do
        task.skills.should eq [welding, painting]
      end
      it 'a user has many skills' do
        user.skills.should eq [welding, painting]
      end
    end

  end
end
