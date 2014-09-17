module BlahHelper
  include BlacklightHelper
  include ActionView::Helpers::TextHelper

  #########################################################
  #                                                       #
  #  Blacklight Helper over-rides                         #
  #   * Overrides methods within BlacklightHelperBehavior #                      
  #                                                       # 
  #########################################################
  def application_name
    'Library Catalogue'
  end

  #Override the standard Blacklight helper document_header to include sub_title_display in the header if it exists
  def document_heading(document=nil)
   document ||= @document
   document_heading =  document['subtitle_display'].nil? ?  document['title_display'].join(" : ") :  document['title_display'].join(" : ") << " : " <<  document['subtitle_display'].join(" : ") || document.id
  end

  # Default seperator change
  def field_value_separator
    '; '
  end

   # Overide blacklight_helper_bahaviour#render_index_field_value to enable dynamic setting of field seperator 
   # using the args [:seperator]
  def render_index_field_value args
    value = args[:value]

    if args[:field] and blacklight_config.index_fields[args[:field]]
      field_config = blacklight_config.index_fields[args[:field]]
      value ||= send(blacklight_config.index_fields[args[:field]][:helper_method], args) if field_config.helper_method
      value ||= args[:document].highlight_field(args[:field]) if field_config.highlight
    end

    value ||= args[:document].get(args[:field], :sep => nil) if args[:document] and args[:field]
    render_field_value(value, args)
  end

  # Overide blacklight_helper_bahaviour#render_field_value to enable dynamic setting of field seperator 
  # Added args method property to pass through :seperator
  def render_field_value (value=nil, args={})
    seperator = args[:seperator] ? args[:seperator] :  field_value_separator
    #field_value_separator = args[:seperator] if args[:seperator]
    value = [value] unless value.is_a? Array
    value = value.collect { |x| x.respond_to?(:force_encoding) ? x.force_encoding("UTF-8") : x}
    return value.map { |v| html_escape v }.join(seperator).html_safe
  end

  # Returns a proc that calls BlahHelper#document_heading method to retrieve correct title/subtitle combo
  # optional truncate param
  def document_show_link_proc(options = {})
    options = {:truncate => nil}.merge(options)

    return Proc.new do |document, opts|
      if options[:truncate].nil?
        document_heading(document)
      else
        truncate(document_heading(document), length: options[:truncate], separator: ' ')
      end
    end
  end

  #######################################################
  # - End of Blacklight Helper over-rides               #
  #######################################################

  # Return the Blah version - see config/application.rb for origin of config.version
  def blah_version
    if Blah::Application.config.respond_to? :version
      return Blah::Application.config.version.to_s.chop.html_safe
    else
      return ""
    end    
  end

  # Returns a link to the equivalent record in Millennium 
  # bib_record_id assumes the same id for Millennium
  def render_millennium_record_link label="Record"
    link_to label, "http://library.hull.ac.uk/record=#{bib_record_id}~S3"
  end
  
  # Uses the Syndetics tool to display book cover
  def render_book_cover_img(document)
    isbn = isbn_from_document(document)
    unless isbn.nil? 
      image_tag("http://syndetics.com/index.aspx?isbn=" + isbn + "/mc.gif&client=" + APP_CONFIG['syndetics_client_code'], :class => "book-cover-img")
    end
  end

  # Calls the Google Book Preview Javascript if an ISBN exists.
  # If Google has a Book preview it will display a Preview button within the 'google-preview' div specified below.
  def render_google_preview_button(document)
    isbn = isbn_from_document(document)
    unless isbn.nil?
      content_tag "div", id: "google-preview" do
        javascript_tag "GBS_insertPreviewButtonPopup('ISBN:#{isbn}')"
      end
    end 
  end
  
  # Retrieves the ISBN from a SolrDocument
  # It is configured to look for isbn_t and if multiple ISBN's exist it will return the first available.  
  def isbn_from_document( document )
    isbn = document.get('isbn_t', :sep => nil)
    unless isbn.nil? 
      isbn = if isbn.is_a? Array then isbn.first else isbn end
    end
  end

  #Helper to return a label for document_links - See _document.html.erb :label =>...
  def document_link_label doc
    label = nil
    label_array = doc['subtitle_display'].nil? ?  doc['title_display'] :  doc['title_display'] << " : " <<  doc['subtitle_display'] || doc.id
     #Make the label a manageable level (for titles with long sub-titles)
     label = label_array.to_s.length > 100 ? label_array.to_s[0..100] << '...' : label_array.to_s unless label_array.to_s.nil?
  end 


  def display_terms_of_use( document )        
    terms = document.get('terms_display', :sep => nil)
    unless terms.nil?
      terms = [terms] unless terms.is_a? Array
      return terms.map { |v| v.html_safe }.join(field_value_separator).html_safe
    end
  end

  def render_online_resources_partial(document)

    #Get the url fields...        
    journal_url_display = document.get('journal_url_display', :sep => nil)
    full_text_url = document.get('url_fulltext_display', :sep => nil)
    
    #Check online resources exist...
    unless journal_url_display.nil? && full_text_url.nil?
      render :partial => 'catalog/online_resources'
    end

  end

  def display_field(document, solr_fname, label_text='', dd_class=nil, opts={} )

    label = ""
    display_field = ""

    dd_class = "blacklight-#{dd_class}" if dd_class

    label = if label_text.length > 0 then label_text end

    if document.has? solr_fname
      # if we are display it as a link....    
      if opts[:display_as_link]
        # We deal with multi-valued fields (multi-links)
        field_value = document.get(solr_fname, sep: nil)        
        unless field_value.nil? || field_value.empty?
          display_value = "" 
          field_value.each_with_index { |v,i| display_value.concat( "<a href='#{v}' >#{opts[:link_text]} #{i+1 if field_value.size > 1 }</a><br/>") }
        end
      else
        # Normal display (with the options of displaying encoded html)
        field_value = render_index_field_value(:document => document, :field => solr_fname, :seperator => opts[:seperator])
        display_value = opts[:contains_encoded_html] ? field_value.gsub(/&lt\;/, "<").gsub(/&gt\;/, ">") : field_value
      end

     display_field = <<-EOS
        <dt class=#{dd_class}>#{label}</dt>
        <dd class=#{dd_class}>#{display_value}</dd>
      EOS

    end

    display_field.html_safe
  end

  #search_catalog_link - creates blacklight search link with the given search_query and search_field
  def search_catalog_link(text, search_query, search_field, link_class=nil, exact_match=false)
   search_query = "\"#{search_query}\"".html_safe if exact_match 
   link_to text, catalog_index_path(:q => search_query, :search_field => search_field ), :class => link_class
  end

  # display_field_search_link helper produces a search link for given Solr Document field.
  # Data stored within the solr_fname will be used as the basis for the search query
  # search_field - specify which search_handler to use for the link - default 'all_fields'  
  def display_field_search_link(document, solr_fname, label_text='', dd_class=nil, link_class=nil, search_field='all_fields')
     label = ""
    display_field = ""

    dd_class = "blacklight-#{dd_class}" if dd_class

    label = label_text.length > 0 ? label_text : ''

    if document.has? solr_fname
      values = document[solr_fname] 
      values = values.kind_of?(Array) ? values : values.to_a

      display_field = <<-EOS
        <dt class=#{dd_class}>#{label}</dt>
        <dd class=#{dd_class}>#{values.collect{ |value| search_catalog_link(value, value, search_field, link_class, true)}.join('; ') }</dd>
      EOS
    end

    display_field.html_safe

  end 

  # display_field_search_link_within_element produces a search link within a specified element
  # Data stored within the solr_fname will be used as the basis for the search query
  # search_field - specify which search_handler to use for the link - default 'all_fields'  
  def display_field_search_link_within_element(document, solr_fname, element='h1', element_class=nil, link_class=nil,  search_field='all_fields')
    if document.has? solr_fname
      values = document[solr_fname] 
      values = values.kind_of?(Array) ? values : values.to_a

      content_tag element, :class => element_class do       
          values.collect { |value| concat(search_catalog_link(value, value, search_field, link_class, true) + '<br/>'.html_safe) }
      end
    end
  end 

  def display_field_within_element(document, solr_fname, element='h1', element_class=nil)
    if document.has? solr_fname
      content_tag element, render_index_field_value(:document => document, :field => solr_fname), :class => element_class
    end    
  end

  # Renders the Online resources available for a particular document/record
  # Looks in various Marc fields for different online resource types.. 
  def render_online_resources( document )

    render_online_resources = ""
    full_title_display = render_index_field_value(:document => document, :field => "title_display")
  
    #Reduce the title display label if the title is over 50 chars..
    title_display = full_title_display.length > 50 ? full_title_display[0..50] << '...' : full_title_display unless full_title_display.nil?
        
    #Lets look in all the usual fields...

    ###########################################################################
    # Full Text URLs - Some resources link to Full text                       #
    ###########################################################################

    full_text_url = document.get('url_fulltext_display', :sep => nil)

    unless full_text_url.nil?
      full_text_url.each do |url|
        render_online_resources << <<-EOS
        <tr>
         <td class="table-td-title">Link</td>
         <td class="table-td-data"><a href="#{url}">#{title_display}</a></td>
        </tr>
        EOS
      end
     end

    ###########################################################################
    # Electronic Journal Links - Usually just in E-Journals                   #
    ###########################################################################

    # Check the document for electronic_journal_links using get_electronic_journal_links_from_document helper
    electronic_journal_links = get_electronic_journal_links_from_document(document)
    unless electronic_journal_links.empty?
      electronic_journal_links.each do |link|
        render_online_resources << <<-EOS
          <tr>
           <td class="table-td-title">Link</td>
           <td class="table-td-data">#{link}</td>
          </tr>
        EOS
      end
    end

    ###########################################################################
    # Supplementary links - Some resources link to supplementary material    #
    ###########################################################################

    #Lets check for any supplementary links...
    suppl_url = document.get('url_suppl_display', :sep => nil)

    unless suppl_url.nil?
      suppl_url.each do |url|
        render_online_resources << <<-EOS
        <tr>
         <td class="table-td-title">Link</td>
         <td class="table-td-data"><a href="#{url}">Supplementary online resource</a></td>
        </tr>
        EOS
      end
     end

    render_online_resources.html_safe
  end

  #Convenient helper for display the call number for a document (primary and secondary)
  def display_call_number(document, opts={})
    
    display_field = ""

    #fields for call numbers
    primary_call_no = 'lc_callnum_display'
    secondary_call_no = 'alt_lc_callnum_display'

    display_value = []
    if document.has?(primary_call_no) then  display_value << render_index_field_value(:document => document, :field => primary_call_no) end
    if document.has?(secondary_call_no) then display_value << render_index_field_value(:document => document, :field => secondary_call_no) end

    unless display_value.empty?
      if opts[:render_icon]
        display_field << <<-EOS
          <dt class="dt-callnumber">#{pluralize_string(display_value.length,"Class number")}</dt>
          <dd class="dd-callnumber">#{ display_value.collect{ |cn| render_shelved_icon  + '&nbsp;'.html_safe + cn}.join('<br/>'.html_safe)}</dd>
         EOS
      else
        display_field << <<-EOS
          <dt class="dt-callnumber">#{pluralize_string(display_value.length,"Class number")}</dt>
          <dd class="dd-callnumber">#{ display_value.collect{ |cn| cn }.join('<br/>'.html_safe)}</dd>
         EOS
      end  
    end
    display_field.html_safe
  end

  # Display Electronic Journals Links with dt/dd fields
  # This is primarily used in the _index_e_journal partial
  def display_electronic_journal_links(document)
    display_electronic_journal_links = ""
    
    links = get_electronic_journal_links_from_document(document)
    unless links.empty?
      links.each do |link|
        display_electronic_journal_links << <<-EOS
          <dt class="document-link-dd">Online</dt>
          <dd class="document-link-dd">#{link}</dd>
        EOS
      end
    end

    display_electronic_journal_links.html_safe
  end

  # Returns an array of electronic Journal 'a' tag links from the Solr document
  # Uses the 'journal_url_display' multi solr field which stores in the form: url|link_label
  def get_electronic_journal_links_from_document(document)
    electronic_journal_links = []

    journal_url_display = document.get('journal_url_display', :sep => nil)

    unless journal_url_display.nil?
      journal_url_display.each do |url_display|      
        if url_display.include? "|"
          url_label = url_display.split("|")          
          electronic_journal_links << "<a href='#{url_label.first}'>#{url_label.last}</a>"
        else
          electronic_journal_links << "<a href='#{url_display}'>Link</a>"
        end
      end
    end

    return electronic_journal_links
  end


  #delayed_related_items methods takes solr fields continues_display, continues_in_part_display, supersedes_display etc.. 
  #and displays if they exist for a given document (displays them as link to title_search)
  #TODO related_fields to go into a config
  def display_related_items( document )

    document_related_fields = []
    related_fields = {"continues_display" => "Item continues", "continues_in_part_display" => "Item continues", "supersedes_display" => "Item supersedes", "supersedes_in_part_display" => "Item supersedes", "formed_by_display" => "Item formed by",  "absorbed_display" => "Item absorbed by", "absorbed_in_part_display" => "Item absorbed by" , "s
ep_from_display" => "Item seperate from", "continued_by_display" => "Item continued by", "continued_in_part_display" => "Item continued by", "superseded_by_display" => "Item superseded by", "superseded_part_by_display" => "Item superseded by", "absorbed_by_display" => "Item absorbed by", "absorbed_in_part_by_display" => "Item absorbed by", "split_into_display" => "Item split into", "merged_with_display" => "Item merged with", "changed_to_display" => "Item changed to"}

    #Add all the matched fields to document_related_fields hash
    related_fields.each_key do |solr_fname|
      if document.has? solr_fname
        document_related_fields << solr_fname if document.has? solr_fname
      end
    end

    if document_related_fields.length > 0
       content_tag(:h3, "Related") + content_tag(:dl, :class => "dl-vertical-left  dl-invert") {
         document_related_fields.reduce('') { |c , field|
          c << content_tag(:dt, related_fields.fetch(field), :class => "blacklight-dt-" + field) << content_tag(:dd, :class => "blacklight-dd-" + field) { link_to(render_index_field_value(:document => document, :field => field), {:controller => "catalog", :action => "index", :q=> render_index_field_value(:document => document, :field => field).gsub(" ", "+"), :search_field => "title"}, :target => "_blank" ) }
        
        }.html_safe
       }  
    end
  end



  def render_format_icon( document )
    format = document.get('format', :sep => nil)
    
    case format
    when 'Book', 'E-Book', 'E-Journal'
      content_tag(:i, '', :class => 'icon-book') 
    when 'Thesis'
      content_tag(:i, '', :class => 'icon-file') 
    when 'Photocopy'
      content_tag(:i, '', :class => 'icon-inbox')
    when 'Periodical'
      content_tag(:i, '', :class => 'icon-bullhorn')
    when 'Printed Music'
      content_tag(:i, '', :class => 'icon-music')
    when 'Playbill'
      content_tag(:i, '', :class => 'icon-play')
    when 'Map'
      content_tag(:i, '', :class => 'icon-globe')
    when 'CD Audio', 'Cassette', 'Sound record', 'Spoken record'
      content_tag(:i, '', :class => 'icon-volume-up')
    when 'DVD'
      content_tag(:i, '', :class => 'icon-film')
    when 'Computer file'
        content_tag(:i, '', :class => 'icon-hdd')
    when 'Kit'
        content_tag(:i, '', :class => 'icon-briefcase')
    when 'Artefact'
        content_tag(:i, '', :class => 'icon-tag')
    when 'Video'
        content_tag(:i, '', :class => 'icon-facetime-video')
    else
      content_tag(:i, '', :class => 'icon-book')
    end

  end 


  def render_shelved_icon
    content_tag(:i, '', :class => 'icon-map-marker') 
  end

  def get_year
    t = Time.now   #=> 2007-11-19 08:27:51 -0600
    t.year         #=> 2007   
  end 


  #Helper for use with display links
  #opts[:i_class] for display icon from the usual glyph classes
  def render_home_page_link(path, link, opts = {}) 
    if opts[:i_class]
      content_tag :a, :href => path do 
        content_tag(:i, '', :class => opts[:i_class]) <<  " " << link
      end
    else
      content_tag(:a, link, :href => path) 
    end
  end

  # Add a hidden field that contains the bibliographic record id
  # Can be used for Jquery looks based on this id (i.e. reading lists etc..)
  def bib_record_id_hidden_field
    unless bib_record_id.nil?
      hidden_field_tag "bib_record_id", bib_record_id 
    end
  end

  # Return the bib_record_id for a record.  
  # chop based last digit based on the chop_bib_id method
  def bib_record_id
    unless params["id"].nil?
      id = chop_bib_id ? params["id"].chop : params["id"]
    end    
  end

  # The id used for records within Blacklight are the catalogue Bibliographic identifier. The
  # id contains a control character at the end which isn't used when calling external services
  # This method is simply to decide whether to chop the last char  
  def chop_bib_id
    false
  end

  #Returns a pluralized string
  def pluralize_string(count, singular)
    pluralize(count,singular)[2..-1]
  end

  #Accessor methods for the addthis configuraations - See blah_config.yml
  def addthis_services_compact
    APP_CONFIG['addthis_services_compact']
  end  

  def addthis_services_expanded
    APP_CONFIG['addthis_services_expanded']
  end

  def addthis_services_exclude
    APP_CONFIG['addthis_services_exclude']
  end

  #Accessor methods for twitter widget data id
  def twitter_widget_data_id
    APP_CONFIG['twitter_widget_data_id']
  end

  #Url for the inter_library_loan page
  def inter_library_loan_url
    APP_CONFIG['inter_library_loan_address']
  end

end
