module BlahHelper
  include BlacklightHelper
  
  def application_name
    'Library Catalogue'
  end

  #Override the standard Blacklight helper document_header to include sub_title_display in the header if it exists
  def document_heading
    @document['subtitle_display'].nil? ?  @document['title_display'] :  @document['title_display'] << ": " <<  @document['subtitle_display'] || @document.id
  end  

  #Helper to return a label for document_links - See _document.html.erb :label =>...
  def document_link_label doc
    label = nil
    label_array = doc['subtitle_display'].nil? ?  doc['title_display'] :  doc['title_display'] << ": " <<  doc['subtitle_display'] || doc.id
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

    dd_class = "class=\"blacklight-#{dd_class}\"" if dd_class

    label = if label_text.length > 0 then label_text end

    if document.has? solr_fname
      field_value = render_index_field_value(:document => document, :field => solr_fname)

      if opts[:display_as_link] then
        display_value = '<a href="' + field_value + '">' +  opts[:link_text] + '</a>'
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

  def display_field_within_element(document, solr_fname, element='h1', element_class=nil)
    if document.has? solr_fname
      content_tag element, render_index_field_value(:document => document, :field => solr_fname), :class => element_class
    end    
  end


  def render_online_resources( document )

    render_online_resources = ""
    title_display = render_index_field_value(:document => document, :field => "title_display")
   
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
    render_online_resources.html_safe
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

end
