require_relative "./yakuake_dbus.rb"

module YakuakeController

  class DBusClient
    def initialize(dbus: YakuakeController::YakuakeDBus.new)
      @dbus = dbus
    end

    def terminal_ids_for_tab tab_index:
      terminal_ids_for_session session_id: session_id(tab_index: tab_index)
    end

    def tab_title tab_index:
      @dbus.tabs_interface.tabTitle(session_id tab_index: tab_index).first
    end

    def set_tab_title tab_index:, new_title:
      @dbus.tabs_interface.setTabTitle session_id(tab_index: tab_index).to_i,
                                       new_title
    end

    def run_command_in_tab tab_index:, command_text:
      terminal_id = terminal_ids_for_tab(tab_index: tab_index).first
      run_command_in_terminal terminal_id: terminal_id,
                              command_text: command_text
    end

    def run_command_in_terminal terminal_id:, command_text:
      @dbus.sessions_interface.runCommandInTerminal terminal_id.to_i, command_text
    end

    def add_tabs_if_needed count:
      if count > sessions_ids.length
        active_session = @dbus.sessions_interface.activeSessionId.first.to_i
        (count - sessions_ids.length).times do
          @dbus.sessions_interface.addSession
        end
        @dbus.sessions_interface.raiseSession active_session
      end
    end

    def remove_tab tab_index:
      @dbus.sessions_interface.removeSession session_id(tab_index: tab_index).to_i
    end

    def remove_terminal terminal_id:
      @dbus.sessions_interface.removeTerminal terminal_id.to_i
    end

  private

    def sessions_ids
      @dbus.sessions_interface.sessionIdList.first.split(',').map{|i| i.strip}
    end

    def terminal_ids_for_session session_id:
      @dbus.sessions_interface.terminalIdsForSessionId(session_id.to_i).
        first.split(',').map{|i| i.strip}
    end

    def session_id tab_index:
      @dbus.tabs_interface.sessionAtTab(tab_index.to_i).first
    end

  end

end
