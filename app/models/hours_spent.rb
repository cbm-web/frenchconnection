# == Schema Information
#
# Table name: hours_spents
#
#  id                      :integer          not null, primary key
#  customer_id             :integer
#  task_id                 :integer
#  hour                    :integer
#  created_at              :datetime
#  updated_at              :datetime
#  date                    :date
#  description             :text
#  user_id                 :integer
#  piecework_hours         :integer
#  overtime_50             :integer
#  overtime_100            :integer
#  project_id              :integer
#  runs_in_company_car     :integer
#  km_driven_own_car       :float
#  toll_expenses_own_car   :float
#  supplies_from_warehouse :string(255)
#  approved                :boolean          default(FALSE)
#  changed_hour_id         :integer
#  change_reason           :string(255)
#  changed_by_user_id      :integer
#

class HoursSpent < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  belongs_to :project
  has_one :change

  validates :task,        :presence => true
  validates :user,        :presence => true
  validates :description, :presence => true
  validates :date,        :presence => true
  validates :project_id,  :presence => true

  # Sums all the different types of hours registered
  # for one day, on one user.
  def sum(overtime: nil, changed: nil)
    if changed
      (self.changed_value_hour            ||  0) +
      (self.changed_value_piecework_hours ||  0) +
      (self.changed_value_overtime_50     ||  0) +
      (self.changed_value_overtime_100    ||  0)
    else
      (self.hour            ||  0) +
      (self.piecework_hours ||  0) +
      (self.overtime_50     ||  0) +
      (self.overtime_100    ||  0)
    end
  end


  # TODO  Move into a date helper
  def self.week_numbers_for_dates(dates)
    dates.collect { |d| d.cweek }.sort.uniq.join(', ')
  end

  def self.week_numbers(hours_spents)
    dates = hours_spents.collect { |hs| hs.date }
    week_numbers_for_dates(dates)
  end

  # Used to return values from Changed if it exists
  # E.g. @hours_spent.changed_value_overtime_50
  #
  # sum += h.changed_value(:overtime)        || 0
  def method_missing(m, *args, &block)
    if m.to_s.match(/changed_value_/)
      value = m.to_s.gsub('changed_value_', '')
      change.try(value) || send(value)
    else
      super
    end
  end

  def changed_value(value)
    change.try(value) || send(value)
  end

  def profession_department
    "#{user.profession.title}_#{user.department.title}"
  end
end
