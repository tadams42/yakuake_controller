require "dbus"

# to explore yakuake interfaces use
# qdbus org.kde.yakuake /yakuake/sessions
# qdbus org.kde.yakuake /yakuake/tabs

module YakuakeController

  class DbusClient
    def initialize
      bus = DBus.session_bus
      service = bus['org.kde.yakuake']
      sessions_proxy = service.object '/yakuake/sessions'
      sessions_proxy.introspect
      tabs_proxy = service.object '/yakuake/tabs'
      tabs_proxy.introspect
      @sessions_interface = sessions_proxy['org.kde.yakuake']
      @tabs_interface = tabs_proxy['org.kde.yakuake']
    end

    def terminal_ids_for_tab tab_index
      (terminal_ids_for_session session_id(tab_index)).map{|i| i.to_i}
    end

    def tab_title tab_index
      @tabs_interface.tabTitle(session_id tab_index).first
    end

    def set_tab_title tab_index, new_title
      @tabs_interface.setTabTitle session_id(tab_index), new_title
    end

    def run_command_in_tab tab_index, command_text
      terminal_id = terminal_ids_for_tab(tab_index).first
      run_command_in_terminal terminal_id, command_text
    end

    def run_command_in_terminal terminal_id, command_text
      @sessions_interface.runCommandInTerminal terminal_id, command_text
    end

    def add_tabs_if_needed count
      if count > sessions_ids.length
        active_session = @sessions_interface.activeSessionId.first
        (count - sessions_ids.length).times do
          @sessions_interface.addSession
        end
        @sessions_interface.raiseSession active_session
      end
    end

    def remove_tab tab_index
      @sessions_interface.removeSession session_id(tab_index)
    end

    def remove_terminal terminal_id
      @sessions_interface.removeTerminal terminal_id
    end

  private

    def sessions_ids
      @sessions_interface.sessionIdList.first.split(',').map{|i| i.to_i}
    end

    def terminal_ids_for_session session_id
      @sessions_interface.terminalIdsForSessionId(session_id).first.split(',').map{|i| i.to_i}
    end

    def session_id tab_index
      @tabs_interface.sessionAtTab(tab_index).first.to_i
    end

  end

end
