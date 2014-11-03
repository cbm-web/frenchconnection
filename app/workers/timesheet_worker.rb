class TimesheetWorker
  include Sidekiq::Worker
  delegate :url_helpers, to: 'Rails.application.routes'

  sidekiq_options retry: false

  ReportFile = Struct.new(:file, :user, :type) do
    def filename
      "#{user.name.parameterize}.xls"
    end
  end

  def perform(project_id)
    @project = Project.find(project_id)

    Zip::File.open(zipfile_path, Zip::File::CREATE) do |zipfile|
      files.each do |f|
        zipfile.add(f.filename, f.file)
      end
    end

    current = ZippedReport.timesheets.create(project: @project,
                                             zipfile: File.open(zipfile_path))
    current.cleanup_old_reports
    current
  end

  private

  def files
    @project.users.map do |u|
      generate_timesheet(@project, u)
    end
  end

  def generate_timesheet(project, user)
    hours = project.hours_spents.where(user: user)
    filename = Timesheet.new(project, user, hours).create_spreadsheet
    ReportFile.new(filename, user)
  end

  def zipfile_path
    @zipfile_path ||= "/tmp/project-#{@project.id}-timesheet-#{timestamp}.zip"
  end

  def timestamp
    DateTime.now.strftime '%Y-%m-%d-%H-%M'
  end

  def host
    unless domain = ENV['DOMAIN']
      Sidekiq.logger.warn "DOMAIN environment variable not set"
    end
    domain || 'localhost:3000'
  end
end