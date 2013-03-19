module BlahHelper
  include BlacklightHelper
  include ActionView::Helpers::TextHelper
  
  def application_name
    'Library Catalogue'
  end

  #Override the standard Blacklight helper document_header to include sub_title_display in the header if it exists
  def document_heading
   document_heading =  @document['subtitle_display'].nil? ?  @document['title_display'] :  @document['title_display'] << " : " <<  @document['subtitle_display'] || @document.id
  end
  
  #Uses the Syndetics tool to display book cover
  def render_book_cover_img( document )    
    isbn = document.get('isbn_t', :sep => nil)      
    unless isbn.nil? 
      isbn_number = if isbn.is_a? Array then isbn.first else isbn end
      image_tag("http://syndetics.com/index.aspx?isbn=" + isbn_number + "/mc.gif&client=" + APP_CONFIG['syndetics_client_code'], :class => "book-cover-img")
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

  def field_value_separator
    '; '
  end


  def display_field(document, solr_fname, label_text='', dd_class=nil, opts={} )

    label = ""
    display_field = ""

    dd_class = "blacklight-#{dd_class}" if dd_class

    label = if label_text.length > 0 then label_text end

    if document.has? solr_fname
      field_value = render_index_field_value(:document => document, :field => solr_fname)

      if opts[:display_as_link] then
        display_value = '<a href="' + field_value + '">' +  opts[:link_text] + '</a>'
      #if specified that the field contains_encoded_html ie &lt; and &gt; change them back to < and > for correct display
      elsif opts[:contains_encoded_html] 
        display_value = field_value.gsub(/&lt\;/, "<").gsub(/&gt\;/, ">")
      else
        display_value = field_value
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
        <dd class=#{dd_class}>#{values.collect{ |value| search_catalog_link(value, value, search_field, link_class, true) + '; ' } }</dd>
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

  def render_online_resources( document )

    render_online_resources = ""
    full_title_display = render_index_field_value(:document => document, :field => "title_display")
  
    #Reduce the title display label if the title is over 50 chars..
    title_display = full_title_display.length > 50 ? full_title_display[0..50] << '...' : full_title_display unless full_title_display.nil?
 
    #Lets look in all the usual fields...
    full_text_url = document.get('url_fulltext_display', :sep => nil)

    unless full_text_url.nil?
      full_text_url.each do |url|
        render_online_resources << <<-EOS
        <tr>
         <td class="table-td-title">Link</td>
         <td class="table-td-data"><a target="_blank" href="#{url}">#{title_display}</a></td>
        </tr>
        EOS
      end
     end

    #Lets now check the journal fields...
    journal_url_display = document.get('journal_url_display', :sep => nil)
    journal_url_coverage_display = document.get('journal_url_coverage_display', :sep => nil)
    
    unless journal_url_display.nil?
      journal_url_display.each do |url|
         link_title = ""
         #Journal coverage corresponds to same place in array...
         journal_coverage = journal_url_coverage_display[journal_url_display.index(url)]
         #If it doesn't exist, use the title for link (remove 'Full text available from link')..  
         link_title = journal_coverage.nil? ? title_display : journal_coverage.gsub(/Full text available from/, '')
          render_online_resources << <<-EOS
          <tr>
           <td class="table-td-title">Link</td>
           <td class="table-td-data"><a target="_blank" href="#{url}">#{link_title}</a></td>
          </tr>
        EOS
      end

    end
    
    #Lets check for any supplementary links...
    suppl_url = document.get('url_suppl_display', :sep => nil)

    unless suppl_url.nil?
      suppl_url.each do |url|
        render_online_resources << <<-EOS
        <tr>
         <td class="table-td-title">Link</td>
         <td class="table-td-data"><a target="_blank" href="#{url}">Supplementary online resource</a></td>
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

#<dd class="dd-callnumber">#{render_shelved_icon}&nbsp;#{display_value.join('; ')}</dd>
#<dd class="dd-callnumber">#{display_value.join('; ')}</dd>
    unless display_value.empty?
      if opts[:render_icon]
        display_field << <<-EOS
          <dt class="dt-callnumber">#{pluralize_string(display_value.length,"Class number")}</dt>
          <dd class="dd-callnumber">#{ display_value.map{ |cn| render_shelved_icon  + '&nbsp;'.html_safe + cn + '<br/>'.html_safe}.to_s}</dd>
         EOS
      else
        display_field << <<-EOS
          <dt class="dt-callnumber">#{pluralize_string(display_value.length,"Class number")}</dt>
          <dd class="dd-callnumber">#{ display_value.map{ |cn| cn + '<br/>'.html_safe}.to_s}</dd>
         EOS
      end  
    end
    display_field.html_safe
  end

  #display e-journal links for _index_e_journal.html.erb page
  def display_e_journal_links(document)

      display_e_journal_links = ""

      #Lets now check the journal fields...
      journal_url_display = document.get('journal_url_display', :sep => nil)
      journal_url_coverage_display = document.get('journal_url_coverage_display', :sep => nil)
      
      unless journal_url_display.nil?
        journal_url_display.each do |url|
           link_title = ""
           #Journal coverage corresponds to same place in array...
           journal_coverage = journal_url_coverage_display[journal_url_display.index(url)]
           #If it doesn't exist, use the title for link (remove 'Full text available from link')..  
           link_title = journal_coverage.nil? ? title_display : journal_coverage.gsub(/Full text available from/, '')
            display_e_journal_links << <<-EOS
             <dt class="document-link-dd">Online</dt>
             <dd class="document-link-dd"><a target="_blank" href="#{url}">#{link_title}</a></dd>
          EOS
        end
      end  
    
    display_e_journal_links.html_safe 
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
       content_tag(:h4, "Related") + content_tag(:dl, :class => "defList") {
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

end
