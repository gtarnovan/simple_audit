module SimpleAuditHelper

  def render_audits(audits)
    audits = audits.dup.sort{|a, b| b.created_at <=> a.created_at}
    res = ''
    audits.each_with_index do |audit, index|
      older_audit = audits[index + 1]
      res += content_tag(:div, :class => 'audit') do
        content_tag(:div, audit.action, :class => "action #{audit.action}") +
        content_tag(:div, audit.username, :class => "user") + 
        content_tag(:div, l(audit.created_at), :class => "timestamp") + 
        content_tag(:div, :class => 'changes') do
          if older_audit.present?
            audit.delta(older_audit).collect {|k, v| "\n#{Booking.human_attribute_name(k)}: #{v.last}" }
          else
            audit.changes.reject{|k, v| v.blank?}.collect {|k, v| "\n#{Booking.human_attribute_name(k)}: #{v}"}
          end    
        end        
      end
    end
    res
  end 
    
end


