module BlahHelper
  include BlacklightHelper
  
  def application_name
    'Library Catalogue'
  end

  def display_terms_of_use( document )        
    terms = document.get('terms_display', :sep => nil)
    unless terms.nil?
      terms = [terms] unless terms.is_a? Array
      return terms.map { |v| v.html_safe }.join(field_value_separator).html_safe
    end
  end

  def field_value_separator
    '; '
  end

end
