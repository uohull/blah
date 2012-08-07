
namespace :blah do

  namespace :eresources do

    desc "Load the test e-resources csv into solr"
    task :index do 
      `curl "http://localhost:8983/solr/update/csv?f.subject_topic_facet.split=true&f.subject_topic_facet.separator=%5E&commit=true" --data-binary @test/fixtures/e-resources.csv -H 'Content-type:text/plain; charset=utf-8'`
    end
  end
end

