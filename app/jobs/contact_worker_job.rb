class ContactWorkerJob
  include Sidekiq::Worker

  def perform(csv_file_id, mapping_hash, current_user_id)
    table_fields = {"Name": 0,
                    "Birthday": 1,
                    "Phone number": 2,
                    "Address": 3,
                    "Card number": 4,
                    "Email": 5}
    csv_file = CsvUpload.find_by_id(csv_file_id)
    current_user = User.find_by_id(current_user_id)
    csv_file.start_processing #Change state of the file
    contact_saved = false
    contact_error_saved = false

    csv_file_name = csv_file.csv_file.filename.to_s
    #file_path = ActiveStorage::Blob.service.path_for(csv_file.csv_file.key)
    #file_path = ActiveStorage::Downloader.download_blob_to_tempfile(csv_file.csv_file.key)
    #file = ActiveStorage::Downloader.new(csv_file.csv_file).download_blob_to_tempfile.path
    file_path = ActiveStorage::Service::S3Service.download(csv_file.csv_file.key)
    #file_path = csv_file.csv_file.service_url
    headers = nil
    CSV.open(File.open(file_path), "r+") do |file|
      headers = file.shift
      file.rewind
      file << headers + ["Contact importer logs"]
      CSV.foreach(file_path, headers: true) do |row|
        contact_dict = Hash.new
        mapping_hash.each do |hash|
          contact_dict[table_fields.key(hash[1].to_i).to_s.parameterize.underscore] = row.values_at[hash[0].split("-")[1].to_i]
        end
        contact = current_user.contacts.find_or_initialize_by(contact_dict)
        if contact.save
          # Flag that at least one user was saved
          contact_saved = true
          file << row.values_at + ["OK"]
        else
          contact_error_saved = true
          # Generate error with associated user
          contact_dict.delete("card_number")
          contact_dict[:reason] = contact.errors.full_messages
          file << row.values_at + [contact_dict[:reason].join("-").gsub(",", ".")]
          current_user.contact_errors.find_or_create_by!(contact_dict)
        end
      end
    end
    csv_file.contact_imported if contact_saved
    csv_file.nothing_is_good if !contact_saved && contact_error_saved
    csv_file.no_contacts_available if !contact_saved && !contact_error_saved
  end
end
