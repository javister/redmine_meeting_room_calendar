require_dependency 'issues_helper'

module RedmineMeetingRoomCalendar
  module Patches
    module IssuesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :email_issue_attributes, :start_date_attribute
        end
      end

      module InstanceMethods
        def email_issue_attributes_with_start_date_attribute(issue, user, html)
          items = email_issue_attributes_without_start_date_attribute(issue, user, html)
          if issue.tracker_id === Integer(Setting['plugin_redmine_meeting_room_calendar']['tracker_id'])
            if html
              items << content_tag('strong', "#{l('field_start_date')}: ") + (issue.send 'start_date')
            else
              items << "#{l('field_start_date')}: #{issue.send 'start_date'}"
            end
          end
          items
        end

      end

    end
  end
end

# IssuesHelper.send(:include, RedmineMeetingRoomCalendar::Patches::IssuesHelperPatch)