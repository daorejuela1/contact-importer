module CsvMapperHelper
  def preview_csv(csv_file)
    csv_file.csv_file.open do |file|
      line = 0
      form_with url: import_contacts_path, multipart: true,  method: :post do |form|
        concat form.hidden_field(:id, value: csv_file.id)
        CSV.foreach(file.path, headers: false) do |row|
          concat render 'csv_mapper/headers', headers: row, form: form if line == 0
          concat render 'csv_mapper/content', content: row if line > 0
          line += 1
          break if line > 5
        end
        concat render 'csv_mapper/footer'
        concat form.submit("Import", class: "btn btn-primary btn-lg m-3")
      end
    end
  end
end
