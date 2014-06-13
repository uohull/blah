
namespace :blah do

  namespace :electronic_resources do
    desc "Index electronic resources csv into solr (set path to csv file using CSV_FILE_PATH=/opt/example.csv)"
    task :index_data do
     csv_file_path = ENV["CSV_FILE_PATH"]

     if file_exists?(csv_file_path)
       puts "Loading the Electronic resources csv"
       csv_data = file_contents(csv_file_path)

       # Cannot use simple update with the version of solr that blacklight uses
       # rsolr_connection.update(data: csv_data, params: { 'f.subject_topic_facet.split' => true, 'f.subject_topic_facet.separator' => '^',
       #  'f.subject_t.split' => true, 'f.subject_t.separator' => '^', :commit => true }, headers: { 'Content-Type' => 'text/csv', 'charset' => 'utf-8'})
       # So we use.... 
       rsolr_connection.send_and_receive("update/csv", method: :post, data: csv_data, params: { 'f.subject_topic_facet.split' => true, 'f.subject_topic_facet.separator' => '^',
        'f.subject_t.split' => true, 'f.subject_t.separator' => '^', :commit => true }, headers: { 'Content-Type' => 'text/csv', 'charset' => 'utf-8'})
       puts "Data indexed"
     else
       puts "Error: CSV File does not exist at path specified"
     end    
    end
  
    desc "Delete all the electronic resources within solr"
    task :delete_data do
      puts "Deleting all Electronic resources from the index"
      rsolr_connection.delete_by_query 'format:"Electronic resource"', params: { commit: true }
      puts "Deleted"
    end


    desc "Deletes existing Electronic resources and indexes the csv data specified in $CSV_FILE_PATH"
    task :delete_and_index_data do
      if file_exists?(ENV["CSV_FILE_PATH"])
        Rake::Task["blah:electronic_resources:delete_data"].invoke
        Rake::Task["blah:electronic_resources:index_data"].invoke
      else
        puts "Error: CSV File does not exist at path specified, aborting task"
      end
    end

  end
end

def file_exists?(file_path)
  !file_path.nil? && File.exists?(file_path)
end

def rsolr_connection
  RSolr.connect(Blacklight.solr_config)
end

def file_contents(path)
  file = File.open(path, "rb")
  file.read
end
