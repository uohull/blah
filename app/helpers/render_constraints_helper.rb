module RenderConstraintsHelper
  include Blacklight::RenderConstraintsHelperBehavior

  #Modified to display label for 'All field' searchs
  def render_constraints_query(localized_params = params)
    # So simple don't need a view template, we can just do it here.
    # if statement modified to enable the display of the default 'All fields' search
    if (!localized_params[:q].blank?)
      label = 
        if localized_params[:search_field].blank?
          nil
        else

          label_for_search_field(localized_params[:search_field])
        end
    
      render_constraint_element(label,
            localized_params[:q], 
            :classes => ["query"], 
            :remove => url_for(localized_params.merge(:q=>nil, :action=>'index')))
    else
      "".html_safe
    end
  end

end
