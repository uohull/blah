module SearchHistoryConstraintsHelper
  include Blacklight::SearchHistoryConstraintsHelperBehavior

  #Helper method overrides - search_history_constraint_helper method render_search_to_s_q
  #Overidden to display the search label for 'All fields' 
  def render_search_to_s_q(params)
    return "".html_safe if params[:q].blank?

    label = label_for_search_field(params[:search_field])
    
    render_search_to_s_element(label , params[:q] )        
  end

end
