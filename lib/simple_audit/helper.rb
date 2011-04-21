module SimpleAudit #:nodoc:
  module Helper
    
    # Render the change log for the given audited model
    
    def render_audits(audited_model)
      return '' unless audited_model.respond_to?(:audits)
      audits = (audited_model.audits || []).dup.sort{|a,b| b.created_at <=> a.created_at}
      res = ''
      audits.each_with_index do |audit, index|
        older_audit = audits[index + 1]
        res += content_tag(:div, :class => 'audit') do
          content_tag(:div, audit.action, :class => "action #{audit.action}") +
          content_tag(:div, audit.username, :class => "user") + 
          content_tag(:div, l(audit.created_at), :class => "timestamp") + 
          content_tag(:div, :class => 'changes') do
            changes = if older_audit.present?
              audit.delta(older_audit).sort{|x,y| audited_model.class.human_attribute_name(x.first) <=> audited_model.class.human_attribute_name(y.first)}.collect do |k, v|                
                next if k.to_s == 'created_at' || k.to_s == 'updated_at'
                "\n" + 
                audited_model.class.human_attribute_name(k) +
                ":" +
                content_tag(:span, v.last, :class => 'current') +
                content_tag(:span, v.first, :class => 'previous')
              end
            else
              audit.change_log.sort{|x,y| audited_model.class.human_attribute_name(x.first) <=> audited_model.class.human_attribute_name(y.first)}.reject{|k, v| v.blank?}.collect {|k, v| "\n#{audited_model.class.human_attribute_name(k)}: #{v}"}
            end
            raw changes.join
          end        
        end
      end
      raw res
    end 
    
  end
end