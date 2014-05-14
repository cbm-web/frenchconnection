#$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../../lib"

class Dagsrapport
  require 'rubygems'
  require 'axlsx'

  def initialize(project)
    @project = project
  end

  def create_spreadsheet
    Axlsx::Package.new do |p|
      p.workbook do |wb|
        styles = wb.styles
        header     = styles.add_style :bg_color => "FF", :sz => 16, :b => true, 
          :i => true, :alignment => {:horizontal => :center}, :underline => true
        gray_bg_bold_italic_font   = styles.add_style  :b => true, 
          :bg_color => "C0C0C0"
    
        bold_italic = styles.add_style :b => true, :i => true 
        bold        = styles.add_style :b => true
        yellow_bg   = styles.add_style :b => true, :bg_color => 'FFF60B',
          :alignment => { :horizontal => :left }
        gray_bg_align_right = styles.add_style :alignment => { :horizontal => :right }, :bg_color => "C0C0C0"
        attest_style= styles.add_style :alignment => { :horizontal => :right }, :sz => 16
    
    
        wb.add_worksheet do |sheet|
    
          sheet.add_image(:image_src => 'app/assets/images/bratfos.png',
                          :noSelect => true, :noMove => true) do |image|
            image.width=240
            image.height=60
            image.start_at 0,1
          end
    
          sheet.add_row
          sheet.add_row ["Dagsrapport"], :style => [header], :height => 23
          sheet.add_row
          sheet.add_row [nil, nil, nil]
          sheet.add_row ['År:', Time.now.year, "Pågår"],  :style => [bold_italic, yellow_bg, bold]
          sheet.add_row ['Uke:', DateTime.now.cweek, "Utført"],    :style => [bold_italic, yellow_bg, bold]
          sheet.add_row ['Prosjektnummer:', @project.project_number ],  :style => [bold_italic, yellow_bg, bold]
          sheet.add_row ['Kunde:', @project.customer.name ], :style => [bold_italic, yellow_bg, bold]
    
          # 5 blanks with C D E F G spanning from 7-11
          sheet.add_row [nil, nil, nil, nil, nil] 
          sheet.add_row [nil]
          sheet.add_row [nil]
          sheet.add_row [nil]
          sheet.add_row [nil]
          %w(C9:C14 D9:D14 E9:E14 F9:F14).each { |range| sheet.merge_cells(range) }
          
          sheet.add_row ['Dato:', nil, nil, nil, nil, nil, nil, nil], 
            :style => [gray_bg_bold_italic_font, gray_bg_bold_italic_font]


          # Her listes alle timene som er ført på dette prosjektet.
          #
          i = 1
          ai = -1
          @project.artisans.each do |a|
            ai += 1
            @project.hours_spents.where(artisan: a).each do |h|
              sheet.add_row [I18n.l(h.created_at, format: :short_date), 
                h.description] +  offsett(ai) + [h.hour]
              i += 1 
            end
          end
          sheet.add_row [nil]
          sheet.add_row [nil]
          sheet.add_row [nil]

          # Sum timer pr pers
          artisans = @project.artisans.all
          if artisans.present?
            sheet.add_row ['', 'Sum timer pr. pers: '] + ExcelProjectTools.hours_for_artisans(@project) + [nil, nil, nil, nil],
              :style => [gray_bg_align_right, gray_bg_align_right, 
                         gray_bg_align_right, gray_bg_align_right, 
                         gray_bg_align_right, gray_bg_align_right, 
                         gray_bg_align_right]    
          else
            sheet.add_row ['', 'INGEN OPPGAVER FINNES HER']
          end

          # Sum timer totalt
          sheet.add_row ['', 'Sum timer totalt: ', @project.hours_spent_total, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            :style => [gray_bg_align_right, gray_bg_align_right, 
                       gray_bg_align_right, gray_bg_align_right, 
                       gray_bg_align_right, gray_bg_align_right, 
                       gray_bg_align_right]    
            


    
          sheet.add_row [nil]
          sheet.add_row [nil, 'Attest', '……………', '……………', '……………', '……………'],   
            :style => [nil, attest_style]    
          sheet.add_row [nil]
          sheet.add_row [nil, 'BRUKTE MATERIALER']
    
          #sheet.add_row [nil, "What's coming in this month.", nil, nil, "How am I doing"], 
          #:style => tbl_header
          #sheet.add_row [nil, "Item", "Amount", nil, "Item", "Amount"], 
          #:style => [nil, ind_header, col_header, nil, ind_header, col_header]
          #sheet.add_row [nil, "Estimated monthly net income", 500, nil, "Monthly income", "=C9"], 
          #:style => [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Financial aid", 100, nil, "Monthly expenses", "=C27"], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Allowance from mom & dad", 20000, nil, "Semester expenses", "=F19"], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Total", "=SUM(C6:C8)", nil, "Difference", "=F6 - SUM(F7:F8)"], 
          #:style => [nil, t_label, t_money, nil, t_label, t_money]
          #sheet.add_row
          #sheet.add_row [nil, "What's going out this month.", nil, nil, "Semester Costs"], 
          #:style => tbl_header
          #sheet.add_row [nil, "Item", "Amount", nil, "Item", "Amount"], 
          #:style => [nil, ind_header, col_header, nil, ind_header, col_header]
          #sheet.add_row [nil, "Rent", 650, nil, "Tuition", 200], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Utilities", 120, nil, "Lab fees", 50], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Cell phone", 100, nil, "Other fees", 10], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Groceries", 75, nil, "Books", 150], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Auto expenses", 0, nil, "Deposits", 0], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Student loans", 0, nil, "Transportation", 30], 
          #:style =>  [nil, label, money, nil, label, money]
          #sheet.add_row [nil, "Other loans", 350, nil, "Total", "=SUM(F13:F18)"], 
          #:style => [nil, label, money, nil, t_label, t_money]
          #sheet.add_row [nil, "Credit cards", 450], 
          #:style => [nil, label, money]
          #sheet.add_row [nil, "Insurance", 0], 
          #:style => [nil, label, money]
          #sheet.add_row [nil, "Laundry", 10], 
          #:style => [nil, label, money]
          #sheet.add_row [nil, "Haircuts", 0], 
          #:style => [nil, label, money]
          #sheet.add_row [nil, "Medical expenses", 0], 
          #:style => [nil, label, money]
          #sheet.add_row [nil, "Entertainment", 500], 
          #:style => [nil, label, money]
          #sheet.add_row [nil, "Miscellaneous", 0], 
          #:style => [nil, label, money]
          #sheet.add_row [nil, "Total", "=SUM(C13:C26)"], 
          #:style => [nil, t_label, t_money]
          #sheet.add_chart(Axlsx::Pie3DChart) do |chart|
          #  chart.title = sheet["B11"]
          #  chart.add_series :data => sheet["C13:C26"], :labels => sheet["B13:B26"]
          #  chart.start_at 7, 2
          #  chart.end_at 12, 15
          #end
          #sheet.add_chart(Axlsx::Bar3DChart, :barDir => :col) do |chart|
          #  chart.title = sheet["E11"]
          #  chart.add_series :labels => sheet["E13:E18"], :data => sheet["F13:F18"]
          #  chart.start_at 7, 16
          #  chart.end_at 12, 31
          #end
          
          # The name of involved Artisans
          ExcelProjectTools.artisan_names(@project).each_with_index do |a, i|
            sheet.rows[8].cells[2+i].value = a
          end
    
          
          sheet.column_widths 20, 35, nil, nil #nil, nil, 2
        end
      end
      p.use_shared_strings = true
      p.serialize "tmp/dagsrapport.xls"
      #p.serialize "/Users/martins/Work/AllieroForms/ny-dagsrapport.xlsx"
    end
    "tmp/dagsrapport.xls"
  end

  private
  def offsett(nr)
    r = []
    nr.times do 
      r << ''
    end
    r
  end
end