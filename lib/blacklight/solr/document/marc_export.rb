# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
# Written for use with Blacklight::Solr::Document::Marc, but you can use
# it for your own custom Blacklight document Marc extension too -- just
# include this module in any document extension (or any other class)
# that provides a #to_marc returning a ruby-marc object.  This module will add
# in export_as translation methods for a variety of formats. 
module Blacklight::Solr::Document::MarcExport
  
  def self.register_export_formats(document)
    document.will_export_as(:xml)
    document.will_export_as(:marc, "application/marc")
    # marcxml content type: 
    # http://tools.ietf.org/html/draft-denenberg-mods-etc-media-types-00
    document.will_export_as(:marcxml, "application/marcxml+xml")
    document.will_export_as(:openurl_ctx_kev, "application/x-openurl-ctx-kev")
    document.will_export_as(:refworks_marc_txt, "text/plain")
    document.will_export_as(:endnote, "application/x-endnote-refer")
  end


  def export_as_marc
    to_marc.to_marc
  end

  def export_as_marcxml
    to_marc.to_xml.to_s
  end
  alias_method :export_as_xml, :export_as_marcxml
  
  
  # TODO This exporting as formatted citation thing should be re-thought
  # redesigned at some point to be more general purpose, but this
  # is in-line with what we had before, but at least now attached
  # to the document extension where it belongs. 
  def export_as_apa_citation_txt
    apa_citation( to_marc )
  end

  def export_as_mla_citation_txt
    mla_citation( to_marc )
  end
  
  def export_as_chicago_citation_txt
    chicago_citation( to_marc )
  end

  def export_as_harvard_citation_txt
    harvard_citation( to_marc )
  end

  def export_as_oscola_citation_txt
    oscola_citation( to_marc )
  end

  def export_as_vancouver_citation_txt
    vancouver_citation( to_marc )
  end

  # Exports as an OpenURL KEV (key-encoded value) query string.
  # For use to create COinS, among other things. COinS are
  # for Zotero, among other things. TODO: This is wierd and fragile
  # code, it should use ruby OpenURL gem instead to work a lot
  # more sensibly. The "format" argument was in the old marc.marc.to_zotero
  # call, but didn't neccesarily do what it thought it did anyway. Left in
  # for now for backwards compatibilty, but should be replaced by
  # just ruby OpenURL. 
  def export_as_openurl_ctx_kev(format = nil)  
    title = to_marc.find{|field| field.tag == '245'}
    author = to_marc.find{|field| field.tag == '100'}
    corp_author = to_marc.find{|field| field.tag == '110'}
    publisher_info = to_marc.find{|field| field.tag == '260'}
    edition = to_marc.find{|field| field.tag == '250'}
    isbn = to_marc.find{|field| field.tag == '020'}
    issn = to_marc.find{|field| field.tag == '022'}
    unless format.nil?
      format.is_a?(Array) ? format = format[0].downcase.strip : format = format.downcase.strip
    end
      export_text = ""
      if format == 'book'
        export_text << "ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&amp;rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator&amp;rft.genre=book&amp;"
        export_text << "rft.btitle=#{(title.nil? or title['a'].nil?) ? "" : CGI::escape(title['a'])}+#{(title.nil? or title['b'].nil?) ? "" : CGI::escape(title['b'])}&amp;"
        export_text << "rft.title=#{(title.nil? or title['a'].nil?) ? "" : CGI::escape(title['a'])}+#{(title.nil? or title['b'].nil?) ? "" : CGI::escape(title['b'])}&amp;"
        export_text << "rft.au=#{(author.nil? or author['a'].nil?) ? "" : CGI::escape(author['a'])}&amp;"
        export_text << "rft.aucorp=#{CGI::escape(corp_author['a']) if corp_author['a']}+#{CGI::escape(corp_author['b']) if corp_author['b']}&amp;" unless corp_author.blank?
        export_text << "rft.date=#{(publisher_info.nil? or publisher_info['c'].nil?) ? "" : CGI::escape(publisher_info['c'])}&amp;"
        export_text << "rft.place=#{(publisher_info.nil? or publisher_info['a'].nil?) ? "" : CGI::escape(publisher_info['a'])}&amp;"
        export_text << "rft.pub=#{(publisher_info.nil? or publisher_info['b'].nil?) ? "" : CGI::escape(publisher_info['b'])}&amp;"
        export_text << "rft.edition=#{(edition.nil? or edition['a'].nil?) ? "" : CGI::escape(edition['a'])}&amp;"
        export_text << "rft.isbn=#{(isbn.nil? or isbn['a'].nil?) ? "" : isbn['a']}"
      elsif (format =~ /journal/i) # checking using include because institutions may use formats like Journal or Journal/Magazine
        export_text << "ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator&amp;rft.genre=article&amp;"
        export_text << "rft.title=#{(title.nil? or title['a'].nil?) ? "" : CGI::escape(title['a'])}+#{(title.nil? or title['b'].nil?) ? "" : CGI::escape(title['b'])}&amp;"
        export_text << "rft.atitle=#{(title.nil? or title['a'].nil?) ? "" : CGI::escape(title['a'])}+#{(title.nil? or title['b'].nil?) ? "" : CGI::escape(title['b'])}&amp;"
        export_text << "rft.aucorp=#{CGI::escape(corp_author['a']) if corp_author['a']}+#{CGI::escape(corp_author['b']) if corp_author['b']}&amp;" unless corp_author.blank?
        export_text << "rft.date=#{(publisher_info.nil? or publisher_info['c'].nil?) ? "" : CGI::escape(publisher_info['c'])}&amp;"
        export_text << "rft.issn=#{(issn.nil? or issn['a'].nil?) ? "" : issn['a']}"
      else
         export_text << "ctx_ver=Z39.88-2004&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Adc&amp;rfr_id=info%3Asid%2Fblacklight.rubyforge.org%3Agenerator&amp;"
         export_text << "rft.title=" + ((title.nil? or title['a'].nil?) ? "" : CGI::escape(title['a']))
         export_text <<  ((title.nil? or title['b'].nil?) ? "" : CGI.escape(" ") + CGI::escape(title['b']))
         export_text << "&amp;rft.creator=" + ((author.nil? or author['a'].nil?) ? "" : CGI::escape(author['a']))
         export_text << "&amp;rft.aucorp=#{CGI::escape(corp_author['a']) if corp_author['a']}+#{CGI::escape(corp_author['b']) if corp_author['b']}" unless corp_author.blank?
         export_text << "&amp;rft.date=" + ((publisher_info.nil? or publisher_info['c'].nil?) ? "" : CGI::escape(publisher_info['c']))
         export_text << "&amp;rft.place=" + ((publisher_info.nil? or publisher_info['a'].nil?) ? "" : CGI::escape(publisher_info['a']))
         export_text << "&amp;rft.pub=" + ((publisher_info.nil? or publisher_info['b'].nil?) ? "" : CGI::escape(publisher_info['b']))
         export_text << "&amp;rft.format=" + (format.nil? ? "" : CGI::escape(format))
     end
     export_text unless export_text.blank?
  end


  # This format used to be called 'refworks', which wasn't really
  # accurate, sounds more like 'refworks tagged format'. Which this
  # is not, it's instead some weird under-documented Refworks 
  # proprietary marc-ish in text/plain format. See
  # http://robotlibrarian.billdueber.com/sending-marcish-data-to-refworks/
  def export_as_refworks_marc_txt
    # plugin/gem weirdness means we do need to manually require
    # here.
    # As of 11 May 2010, Refworks has a problem with UTF-8 if it's decomposed,
    # it seems to want C form normalization, although RefWorks support
    # couldn't tell me that. -jrochkind
    # DHF: moved this require a little lower in the method.
    # require 'unicode'    
  
    fields = to_marc.find_all { |f| ('000'..'999') === f.tag }
    text = "LEADER #{to_marc.leader}"
    fields.each do |field|
    unless ["940","999"].include?(field.tag)
      if field.is_a?(MARC::ControlField)
        text << "#{field.tag}    #{field.value}\n"
      else
        text << "#{field.tag} "
        text << (field.indicator1 ? field.indicator1 : " ")
        text << (field.indicator2 ? field.indicator2 : " ")
        text << " "
          field.each {|s| s.code == 'a' ? text << "#{s.value}" : text << " |#{s.code}#{s.value}"}
        text << "\n"
       end
        end
    end

    if Blacklight.jruby? 
      require 'java'
      java_import java.text.Normalizer
      Normalizer.normalize(text, Normalizer::Form::NFC).to_s
    else 
      require 'unicode'
      Unicode.normalize_C(text)
    end
  end 

  # Endnote Import Format. See the EndNote User Guide at:
  # http://www.endnote.com/support/enx3man-terms-win.asp
  # Chapter 7: Importing Reference Data into EndNote / Creating a Tagged “EndNote Import” File
  #
  # Note: This code is copied from what used to be in the previous version
  # in ApplicationHelper#render_to_endnote.  It does NOT produce very good
  # endnote import format; the %0 is likely to be entirely illegal, the
  # rest of the data is barely correct but messy. TODO, a new version of this,
  # or better yet just an export_as_ris instead, which will be more general
  # purpose. 
  def export_as_endnote()
    end_note_format = {
      "%A" => "100.a",
      "%C" => "260.a",
      "%D" => "260.c",
      "%E" => "700.a",
      "%I" => "260.b",
      "%J" => "440.a",
      "%@" => "020.a",
      "%_@" => "022.a",
      "%T" => "245.a,245.b",
      "%U" => "856.u",
      "%7" => "250.a"
    }
    marc_obj = to_marc

    # TODO. This should be rewritten to guess
    # from actual Marc instead, probably.
    format_str = 'Generic'
    
    text = ''
    text << "%0 #{ format_str }\n"
    # If there is some reliable way of getting the language of a record we can add it here
    #text << "%G #{record['language'].first}\n"
    end_note_format.each do |key,value|
      values = value.split(",")
      first_value = values[0].split('.')
      if values.length > 1
        second_value = values[1].split('.')
      else
        second_value = []
      end
      
      if marc_obj[first_value[0].to_s]
        marc_obj.find_all{|f| (first_value[0].to_s) === f.tag}.each do |field|
          if field[first_value[1]].to_s or field[second_value[1]].to_s
            text << "#{key.gsub('_','')}"
            if field[first_value[1]].to_s
              text << " #{field[first_value[1]].to_s}"
            end
            if field[second_value[1]].to_s
              text << " #{field[second_value[1]].to_s}"
            end
            text << "\n"
          end
        end
      end
    end
    text
  end

  ## DEPRECATED stuff left in for backwards compatibility, but should
  # be gotten rid of eventually.

  def to_zotero(format)
    warn("[DEPRECATION]  Simply call document.export_as_openurl_kev to get an openURL kev context object suitable for including in a COinS; then have view code make the span for the COinS. ")
    "<span class=\"Z3988\" title=\"#{export_as_openurl_kev(format)}\"></span>"
  end

  def to_apa
    warn("[DEPRECATION] Call document.export_as_apa_citation instead.")
    export_as_apa_citation
  end

  def to_mla
    warn("[DEPRECATION] Call document.export_as_mla_citation instead.")
  end
  
  

  protected
  
  # Main method for defining chicago style citation.  If we don't end up converting to using a citation formatting service
  # we should make this receive a semantic document and not MARC so we can use this with other formats.
  def chicago_citation(marc)
    authors = get_all_authors(marc)    
    author_text = ""
    unless authors[:primary_authors].blank?
      if authors[:primary_authors].length > 10
        authors[:primary_authors].each_with_index do |author,index|
          if index < 7
            if index == 0
              author_text << "#{author}"
              if author.ends_with?(",")
                author_text << " "
              else
                author_text << ", "
              end
            else
              author_text << "#{name_reverse(author)}, "
            end
          end
        end
        author_text << " et al."
      elsif authors[:primary_authors].length > 1
        authors[:primary_authors].each_with_index do |author,index|
          if index == 0
            author_text << "#{author}"
            if author.ends_with?(",")
              author_text << " "
            else
              author_text << ", "
            end
          elsif index + 1 == authors[:primary_authors].length
            author_text << "and #{name_reverse(author)}."
          else
            author_text << "#{name_reverse(author)}, "
          end 
        end
      else
        author_text << authors[:primary_authors].first
      end
    else
      temp_authors = []
      authors[:translators].each do |translator|
        temp_authors << [translator, "trans."]
      end
      authors[:editors].each do |editor|
        temp_authors << [editor, "ed."]
      end
      authors[:compilers].each do |compiler|
        temp_authors << [compiler, "comp."]
      end
      
      unless temp_authors.blank?
        if temp_authors.length > 10
          temp_authors.each_with_index do |author,index|
            if index < 7
              author_text << "#{author.first} #{author.last} "
            end
          end
          author_text << " et al."
        elsif temp_authors.length > 1
          temp_authors.each_with_index do |author,index|
            if index == 0
              author_text << "#{author.first} #{author.last}, "
            elsif index + 1 == temp_authors.length
              author_text << "and #{name_reverse(author.first)} #{author.last}"
            else
              author_text << "#{name_reverse(author.first)} #{author.last}, "
            end
          end
        else
          author_text << "#{temp_authors.first.first} #{temp_authors.first.last}"
        end
      end
    end
    title = ""
    additional_title = ""
    section_title = ""
    if marc["245"] and (marc["245"]["a"] or marc["245"]["b"])
      title << citation_title(clean_end_punctuation(marc["245"]["a"]).strip) if marc["245"]["a"]
      title << ": #{citation_title(clean_end_punctuation(marc["245"]["b"]).strip)}" if marc["245"]["b"]
    end
    if marc["245"] and (marc["245"]["n"] or marc["245"]["p"])
      section_title << citation_title(clean_end_punctuation(marc["245"]["n"])) if marc["245"]["n"]
      if marc["245"]["p"]
        section_title << ", <i>#{citation_title(clean_end_punctuation(marc["245"]["p"]))}.</i>"
      elsif marc["245"]["n"]
        section_title << "."
      end
    end
    
    if !authors[:primary_authors].blank? and (!authors[:translators].blank? or !authors[:editors].blank? or !authors[:compilers].blank?)
        additional_title << "Translated by #{authors[:translators].collect{|name| name_reverse(name)}.join(" and ")}. " unless authors[:translators].blank?
        additional_title << "Edited by #{authors[:editors].collect{|name| name_reverse(name)}.join(" and ")}. " unless authors[:editors].blank?
        additional_title << "Compiled by #{authors[:compilers].collect{|name| name_reverse(name)}.join(" and ")}. " unless authors[:compilers].blank?
    end
    
    edition = ""
    edition << setup_edition(marc) unless setup_edition(marc).nil?
    
    pub_info = ""
    if marc["260"] and (marc["260"]["a"] or marc["260"]["b"]) 
      pub_info << clean_end_punctuation(marc["260"]["a"]).strip if marc["260"]["a"]
      pub_info << ": #{clean_end_punctuation(marc["260"]["b"]).strip}" if marc["260"]["b"]
      pub_info << ", #{setup_pub_date(marc)}" if marc["260"]["c"]
    elsif marc["502"] and marc["502"]["a"] # MARC 502 is the Dissertation Note.  This holds the correct pub info for these types of records.
      pub_info << marc["502"]["a"]
    elsif marc["502"] and (marc["502"]["b"] or marc["502"]["c"] or marc["502"]["d"]) #sometimes the dissertation note is encoded in pieces in the $b $c and $d sub fields instead of lumped into the $a
      pub_info << "#{marc["502"]["b"]}, #{marc["502"]["c"]}, #{clean_end_punctuation(marc["502"]["d"])}"
    end
    
    citation = ""
    citation << "#{author_text} " unless author_text.blank?
    citation << "<i>#{title}.</i> " unless title.blank?
    citation << "#{section_title} " unless section_title.blank?
    citation << "#{additional_title} " unless additional_title.blank?
    citation << "#{edition} " unless edition.blank?
    citation << "#{pub_info}." unless pub_info.blank?
    citation
  end
  
  
  
  def mla_citation(record)
    text = ''
    authors_final = []
    
    #setup formatted author list
    authors = get_author_list(record)

    if authors.length < 4
      authors.each do |l|
        if l == authors.first #first
          authors_final.push(l)
        elsif l == authors.last #last
          authors_final.push(", and " + name_reverse(l) + ".")
        else #all others
          authors_final.push(", " + name_reverse(l))
        end
      end
      text += authors_final.join
      unless text.blank?
        if text[-1,1] != "."
          text += ". "
        else
          text += " "
        end
      end
    else
      text += authors.first + ", et al. "
    end
    # setup title
    title = setup_title_info(record)
    if !title.nil?
      text += "<i>" + mla_citation_title(title) + "</i> "
    end

    # Edition
    edition_data = setup_edition(record)
    text += edition_data + " " unless edition_data.nil?
    
    # Publication
    text += setup_pub_info(record) + ", " unless setup_pub_info(record).nil?
    
    # Get Pub Date
    text += setup_pub_date(record) unless setup_pub_date(record).nil?
    if text[-1,1] != "."
      text += "." unless text.nil? or text.blank?
    end
    text
  end

  def apa_citation(record)
    text = ''
    authors_list = []
    authors_list_final = []
    
    #setup formatted author list
    authors = get_author_list(record)
    authors.each do |l|
      authors_list.push(abbreviate_name(l)) unless l.blank?
    end
    authors_list.each do |l|
      if l == authors_list.first #first
        authors_list_final.push(l.strip)
      elsif l == authors_list.last #last
        authors_list_final.push(", &amp; " + l.strip)
      else #all others
        authors_list_final.push(", " + l.strip)
      end
    end
    text += authors_list_final.join
    unless text.blank?
      if text[-1,1] != "."
        text += ". "
      else
        text += " "
      end
    end
    # Get Pub Date
    text += "(" + setup_pub_date(record) + "). " unless setup_pub_date(record).nil?
    
    # setup title info
    title = setup_title_info(record)
    text += "<i>" + title + "</i> " unless title.nil?
    
    # Edition
    edition_data = setup_edition(record)
    text += edition_data + " " unless edition_data.nil?
    
    # Publisher info
    text += setup_pub_info(record) unless setup_pub_info(record).nil?
    unless text.blank?
      if text[-1,1] != "."
        text += "."
      end
    end
    text
  end

  # Local customisation of the Harvard citation type
  def harvard_citation(record)
    text = ''

    if map?(record)
      pub_info = setup_pub_info(record)
      map_citation_prefix = pub_info.to_s.downcase.include?("ordnance survey") ?  'Ordnance Survey'  : ''
      text = "#{map_citation_prefix} #{harvard_formatted_pub_date(record)} #{harvard_formatted_title(record)} #{map_info(record)} #{setup_pub_info(record)}."
    elsif thesis?(record)
      text = "#{harvard_formatted_author_list(record)} #{harvard_formatted_pub_date(record)} #{harvard_formatted_title(record)} #{thesis_info(record)}."    
    elsif audiovisual?(record)
      text = "#{harvard_formatted_title_field(record)} #{harvard_formatted_pub_date(record)} #{harvard_film_director(record)} #{av_format(record)}. #{setup_pub_info(record)}."    
    else
      text = "#{harvard_formatted_author_list(record)} #{harvard_formatted_pub_date(record)} #{harvard_formatted_title(record)} #{harvard_translated_statement(record)} #{setup_pub_info(record)}."    
    end

    text
  end


  # Local OSCOLA  citation type
  def oscola_citation(record)
    text = ''
    edition = ''
    publisher = ''

    author_list = harvard_formatted_author_list(record)
    author_list = "#{author_list.gsub(/&amp;/, 'and')}," unless author_list.empty?

    edition = harvard_formatted_edition(record)
    edition = "#{edition.gsub(/edition/, 'edn')}," unless edition.empty? 

    # Just need the publisher name...
    if record["260"] && record["260"]["b"]
      publisher = "#{clean_end_punctuation(record["260"]["b"]).strip}"
    end

    if journal?(record)
      title = setup_title_info(record)
      # We remove any line ending fullstops for format flexibility
      title =  title.gsub(/\.$/, '')
      article_url = e_journal?(record) ?  "< < Article URL > > accessed < access date >" : ''
      text = "< Article author >, '< Article title >',  (< Article year >) #{title} #{article_url}"
    else
      text = "#{author_list} #{harvard_formatted_title_field(record)} (#{edition} #{harvard_translated_statement(record)} #{publisher} #{setup_pub_date(record)})"
    end

    # remove any erroneous spaces from bracket
    text = text.gsub(/\(\s*/, '(' ) 

    return text
   end


  def harvard_film_director(record)
    text = ''
    director_name = "< Name of Director >"

    statement = statement_of_responsibility(record)
    if !statement.empty?
      match_array = /(directed\sby\s)(.*)/.match(statement).to_a 
      director = match_array.size == 3 ? match_array[2] : nil
      director_name = director.gsub(/\.$/, '') unless director.nil? 
    end
    text = "Directed by #{director_name}"
  end

  # Retrieve the AV Format for a record - at present returns VHS/DVD
  def av_format(record)
    text = ''
    format = "< AV Format >"
    
    # Get from 300a - Physcial descrption - Extent 
    if record["300"] && record["300"]["a"]
      extent = record["300"]["a"].downcase
      if extent.include? "videotape"
        format = "VHS"
      elsif extent.include? "dvd"
        format = "DVD"
      end  
    end

    text = "[#{format}]"
  end

  # Combines the harvard formatted title, edition and record format (for certain types)
  def harvard_formatted_title(record)
    harvard_title = '' 

    title = harvard_formatted_title_field(record)
    edition = harvard_formatted_edition(record)
    record_format = ebook?(record) ? '[eBook]' : audio_cd?(record) ? '[Audio CD]' : nil

    if edition.empty?
      harvard_title = "#{title}" 
    else
      harvard_title = "#{title}, #{edition}"
    end
     # Make sure that adding a record format keeps the spacing correct... 
    if record_format 
      harvard_title += " #{record_format}."
    else
      harvard_title += "."
    end 

     harvard_title
  end

  # Harvard formatted title (in italics) 
  def harvard_formatted_title_field(record)
    formatted_title = ''
    # setup title info
    title = setup_title_info(record)
    # We remove any line ending fullstops for format flexibility
    title =  title.gsub(/\.$/, '')

    formatted_title =  '<i>' + title + '</i>' unless title.nil? 
    formatted_title
  end

  # Attempt to create harvard translated statement from MARC data
  def harvard_translated_statement(record)
    translated_statement = ''
    translated = false

    statement = statement_of_responsibility(record)
    translated =  statement.downcase.include?("translated")  unless statement.empty? 

    if translated
      original_language_from_marc = language_name_by_code( original_language_code(record) )
      language = original_language_from_marc.nil? ?  "< Original language >" : original_language_from_marc
      translated_statement = "Translated from #{language} by < Name of translator >, < date >."
    end

    translated_statement
  end

  # Format edition information for harvard citation
  def harvard_formatted_edition(record)
    edition_text = ''

    # edition data, Replace ed with edition  only if "ed" exists, Some have trailing / so remove theses
    edition_data = setup_edition(record)
    edition_data = edition_data.include?("edition") ? edition_data : edition_data.gsub(/ed/, "edition") unless edition_data.nil?
    edition_data = edition_data.gsub('/', '') unless edition_data.nil?
    edition_text = edition_data.strip  unless edition_data.nil?
    # We remove any line ending fullstops for format flexibility
    edition_text =  edition_text.gsub(/\.$/, '')

    edition_text
  end

 # Format pub_date for harvard citation
 def harvard_formatted_pub_date(record)
    pub_date = ''
    # Get Pub Date
    pub_date += "(" + setup_pub_date(record) + ") " unless setup_pub_date(record).nil?
    pub_date
 end

  # Author list for the harvard citation
  def harvard_formatted_author_list(record)
    formatted_author_list = '' 

    authors_list = []
    authors_list_final = []

    #setup formatted author list
    authors = get_author_list(record)
    authors.each do |l|
      authors_list.push(harvard_style_abbreviate_name(l)) unless l.blank?
    end
    authors_list.each do |l|
      if l == authors_list.first #first
        authors_list_final.push(l.strip)
      elsif l == authors_list.last #last
        authors_list_final.push(" &amp; " + l.strip)
      else #all others
        authors_list_final.push(", " + l.strip)
      end
    end
    formatted_author_list += authors_list_final.join

    formatted_author_list
  end



   #Vancouver locally added
  def vancouver_citation(record)
    text = ''
    authors_list = []
    authors_list_final = []
    
    #setup formatted author list
    authors = get_author_list(record)
    authors.each do |l|
      authors_list.push(vancouver_style_abbreviate_name(l)) unless l.blank?
    end
    authors_list.each do |l|
      if l == authors_list.first #first
        authors_list_final.push(l.strip)   
      else #all others
        #if other 6 authors you add et al..
        if authors_list.length > 6 
          if l == authors_list[6]
            authors_list_final.push(", et al.")
            break;
          end
        end
        authors_list_final.push(", " + l.strip)
      end
    end
    text += authors_list_final.join
    unless text.blank?
      if text[-1,1] != "."
        text += ". "
      else
        text += " "
      end
    end

    # setup title info
    title = setup_title_info(record)
    text += title + " " unless title.nil?   

    # Edition - Some have trailing / so remove theses
    edition_data = setup_edition(record)
    text += edition_data.gsub('/', '') + " " unless edition_data.nil?
    
    # Publisher info
    text += setup_pub_info(record) + "; " unless setup_pub_info(record).nil?

    # Get Pub Date
    text += setup_pub_date(record)  unless setup_pub_date(record).nil?

    unless text.blank?
      if text[-1,1] != "."
        text += "."
      end
    end

    text
  end


  def setup_pub_date(record)
    if !record.find{|f| f.tag == '260'}.nil?
      pub_date = record.find{|f| f.tag == '260'}
      if pub_date.find{|s| s.code == 'c'}
        date_value = pub_date.find{|s| s.code == 'c'}.value.gsub(/[^0-9|n\.d\.]/, "")[0,4] unless pub_date.find{|s| s.code == 'c'}.value.gsub(/[^0-9|n\.d\.]/, "")[0,4].blank?
      end
      return nil if date_value.nil?
    end
    clean_end_punctuation(date_value) if date_value
  end
  def setup_pub_info(record)
    text = ''
    field_260 = record.find{|f| f.tag == '260'}
    field_264 = record.find{|f| f.tag == '264'}
    if !field_260.nil?
      pub_info_field = field_260
    else
      pub_info_field = field_264
    end
    if !pub_info_field.nil?
      a_pub_info = pub_info_field.find{|s| s.code == 'a'}
      b_pub_info = pub_info_field.find{|s| s.code == 'b'}
      a_pub_info = clean_end_punctuation(a_pub_info.value.strip) unless a_pub_info.nil?
      b_pub_info = b_pub_info.value.strip unless b_pub_info.nil?
      text += a_pub_info.strip unless a_pub_info.nil?
      if !a_pub_info.nil? and !b_pub_info.nil?
        text += ": "
      end
      text += b_pub_info.strip unless b_pub_info.nil?
    end
    return nil if text.strip.blank?
    clean_end_punctuation(text.strip)
  end

  def mla_citation_title(text)
    no_upcase = ["a","an","and","but","by","for","it","of","the","to","with"]
    new_text = []
    word_parts = text.split(" ")
    word_parts.each do |w|
      if !no_upcase.include? w
        new_text.push(w.capitalize)
      else
        new_text.push(w)
      end
    end
    new_text.join(" ")
  end
  
  # This will replace the mla_citation_title method with a better understanding of how MLA and Chicago citation titles are formatted.
  # This method will take in a string and capitalize all of the non-prepositions.
  def citation_title(title_text)
    prepositions = ["a","about","across","an","and","before","but","by","for","it","of","the","to","with","without"]
    new_text = []
    title_text.split(" ").each_with_index do |word,index|
      if (index == 0 and word != word.upcase) or (word.length > 1 and word != word.upcase and !prepositions.include?(word))
        # the split("-") will handle the capitalization of hyphenated words
        new_text << word.split("-").map!{|w| w.capitalize }.join("-")
      else
        new_text << word
      end
    end
    new_text.join(" ")
  end

  def setup_title_info(record)
    text = ''
    title_info_field = record.find{|f| f.tag == '245'}
    if !title_info_field.nil?
      a_title_info = title_info_field.find{|s| s.code == 'a'}
      b_title_info = title_info_field.find{|s| s.code == 'b'}
      a_title_info = clean_end_punctuation(a_title_info.value.strip) unless a_title_info.nil?
      b_title_info = clean_end_punctuation(b_title_info.value.strip) unless b_title_info.nil?
      text += a_title_info unless a_title_info.nil?
      if !a_title_info.nil? and !b_title_info.nil?
        text += ": "
      end
      text += b_title_info unless b_title_info.nil?
    end
    
    return nil if text.strip.blank?
    clean_end_punctuation(text.strip) + "."
    
  end
  
  def clean_end_punctuation(text)
    if [".",",",":",";","/"].include? text[-1,1]
      return text[0,text.length-1]
    end
    text
  end  

  def setup_edition(record)
    edition_field = record.find{|f| f.tag == '250'}
    edition_code = edition_field.find{|s| s.code == 'a'} unless edition_field.nil?
    edition_data = edition_code.value unless edition_code.nil?
    if edition_data.nil? or edition_data == '1st ed.'
      return nil
    else
      return edition_data
    end    
  end
  
  def get_author_list(record)
    author_list = []
    authors_primary = record.find{|f| f.tag == '100'}
    author_primary = authors_primary.find{|s| s.code == 'a'}.value unless authors_primary.nil? rescue ''
    author_list.push(clean_end_punctuation(author_primary)) unless author_primary.nil?
    authors_secondary = record.find_all{|f| ('700') === f.tag}
    if !authors_secondary.nil?
      authors_secondary.each do |l|
        author_list.push(clean_end_punctuation(l.find{|s| s.code == 'a'}.value)) unless l.find{|s| s.code == 'a'}.value.nil?
      end
    end
    
    author_list.uniq!
    author_list
  end
  
  # This is a replacement method for the get_author_list method.  This new method will break authors out into primary authors, translators, editors, and compilers
  def get_all_authors(record)
    translator_code = "trl"; editor_code = "edt"; compiler_code = "com"
    primary_authors = []; translators = []; editors = []; compilers = []
    record.find_all{|f| f.tag === "100" }.each do |field|
      primary_authors << field["a"] if field["a"]
    end
    record.find_all{|f| f.tag === "700" }.each do |field|
      if field["a"]
        relators = []
        relators << clean_end_punctuation(field["e"]) if field["e"]
        relators << clean_end_punctuation(field["4"]) if field["4"]
        if relators.include?(translator_code)
          translators << field["a"]
        elsif relators.include?(editor_code)
          editors << field["a"]
        elsif relators.include?(compiler_code)
          compilers << field["a"]
        else
          primary_authors << field["a"]
        end
      end
    end
    {:primary_authors => primary_authors, :translators => translators, :editors => editors, :compilers => compilers}
  end
  
  def abbreviate_name(name)
    name_parts = name.split(", ")
    first_name_parts = name_parts.last.split(" ")
    temp_name = name_parts.first + ", " + first_name_parts.first[0,1] + "."
    first_name_parts.shift
    temp_name += " " + first_name_parts.join(" ") unless first_name_parts.empty?
    temp_name
  end

  def harvard_style_abbreviate_name(name)
    name_parts = name.split(", ")
    first_name_parts = name_parts.last.split(" ")
    temp_name = name_parts.first + "," +  first_name_parts.map{|first_name| " " + first_name[0,1] + "." }.join
    #first_name_parts.shift
    #temp_name += " " + first_name_parts.join(" ") unless first_name_parts.empty?
    temp_name
  end

 def vancouver_style_abbreviate_name(name)
    name_parts = name.split(", ")
    first_name_parts = name_parts.last.split(" ")
    temp_name = name_parts.first + " " +  first_name_parts.map{|first_name| first_name[0,1] }.join
    #first_name_parts.shift
    #temp_name += " " + first_name_parts.join(" ") unless first_name_parts.empty?
    temp_name
  end

  def name_reverse(name)
    name = clean_end_punctuation(name)
    return name unless name =~ /,/
    temp_name = name.split(", ")
    return temp_name.last + " " + temp_name.first
  end 


   # Thesis helpers
  def thesis_info(record)
    text = ''
    url = thesis_url(record)
    accessed_text = url.empty? ? '' : ' [< Accessed date >]'
    text = thesis_name(record) + thesis_university(record) + url + accessed_text
  end

  # For thesis records get the info on the qualification from the call num...
  def thesis_name(record)
    text = ''
    call_num_field = record.find{|f| f.tag == '050'}
    call_num_code = call_num_field.find{|s| s.code == 'a'} unless call_num_field.nil? 
    call_num = call_num_code.value unless call_num_code.nil? 

    unless call_num.nil?
      name = nil
      call_num = call_num.downcase
      # Call number of thesis can contain these... We derive a qualification name from it. 
      if call_num.include? 'm.d'
        name = 'MD'
      elsif call_num.include? 'ph.d'
        name = 'PhD'
      elsif call_num.include? 'clin.psy.d'
        name = 'ClinPsyD'
      end
      text = "#{name} thesis. " unless name.nil? 
    end

    text
  end

  # For thesis records get the University 
  def thesis_university(record)
    text = ''
    corp_name = record.find{|f| f.tag == '710'}
    corp_name_code = corp_name.find{|s| s.code == 'a'} unless corp_name.nil? 
    university_name = corp_name_code.value unless corp_name_code.nil?

    text = "#{university_name} " unless university_name.nil?

    text
  end

  # For thesis records get the url...
  def thesis_url(record)
    text = ''
    location_field = record.find{|f| f.tag == '856'}
    uri_code = location_field.find{|s| s.code == 'u'} unless location_field.nil? 
    uri = uri_code.value unless uri_code.nil? 

    unless uri.nil? 
      text = "Available online: #{uri}"
    end
    text
  end

  def map_info(record)
    text = ''

    map_number = map_number(record)
    map_scale = map_scale(record)
    map_series = map_series(record)

    text += map_number
    text += ', '  unless map_number.empty? 
    text += map_scale
    text += '.' unless map_number.empty? && map_scale.empty?
    text += " #{map_series}." unless map_series.empty? 
    text  += ' '
    text
  end

  def map_number(record)
    text = ''
    series_field = record.find{|f| f.tag == '440'}
    number_field = series_field.find{|s| s.code == 'v'} unless series_field.nil? 
    text = number_field.value unless number_field.nil? 
    text
  end

  def map_scale(record)
    text = ''
    cart_field = record.find{|f| f.tag == '255'}
    scale_field = cart_field.find{|s| s.code == 'a'} unless cart_field.nil? 
    text = scale_field.value.gsub(/\.$/, "").strip unless scale_field.nil? 
    text
  end

  def map_series(record)
    text = ''
    series_field = record.find{|f| f.tag == '440'}
    series = series_field.find{|s| s.code == 'a'} unless series_field.nil? 
    text = series.value unless series.nil? 
    text = text.gsub(';', '').strip 
    text
  end

  def statement_of_responsibility(record)
    text = ''
    title_statement_field = record.find{|f| f.tag == '245'}
    statement_of_responsibility = title_statement_field.find{|s| s.code == 'c'} unless title_statement_field.nil? 
    text = statement_of_responsibility.value unless statement_of_responsibility.nil? 
    text
  end

  def original_language_code(record)
    text = ''
    language_field = record.find{|f| f.tag == '041'}
    original_langauge_field = language_field.find{|s| s.code == 'h'} unless language_field.nil? 
    text = original_langauge_field.value unless original_langauge_field.nil? 
    text
  end

  def language_name_by_code(language_code)
    begin 
       return Blah::Utils::Language.find_by_code(language_code).name
    rescue
      return nil
    end
  end

  # @ is an ebook
  def ebook?(record)
    record_format(record) == "@"
  end 

  def audio_cd?(record)
    record_format(record) == "k"
  end

  def thesis?(record)
    record_format(record) == "t"
  end

  def map?(record)
    record_format(record) == "f" ||  record_format(record) == "e"
  end

  def audiovisual?(record)
    record_format(record) == "v" ||  record_format(record) == "d"
  end

  def journal?(record)
    record_format(record) == "b" || record_format(record) == "o"
  end

  def e_journal?(record)
    record_format(record) == "o"
  end

   # Return the record format code - empty string if nil
  def record_format(record)
    format_field = record.find{|f| f.tag == '998'}
    format_code = format_field.find{|s| s.code == 'e'} unless format_field.nil?
    format = format_code.value unless format_code.nil?
    format || ""
  end
  
end
