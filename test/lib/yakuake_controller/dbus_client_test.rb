require 'test_helper'

describe YakuakeController::DBusClient do

  before do
    @dbus = YakuakeController::YakuakeDBus.new
    @client = YakuakeController::DBusClient.new(dbus: @dbus)

    @tab_index = 1
    @tab_title = 'Foo tab'
    @command_text = 'Foo command'
    @terminal_id = 2
    @session_id = 3
    @terminal_ids = "4, 5"
    @session_ids = "6, 7"
    @session_ids_array = @session_ids.split(',').map{|i| i.strip}
    @terminal_ids_array = @terminal_ids.split(',').map{|i| i.strip}
  end

  describe '#session_id'do
    it 'finds Yakuake session ID for tab index' do
      @dbus.tabs_interface.expects(:sessionAtTab).
                           with(@tab_index).
                           returns(["#{@session_id}"])

      assert_equal @client.send(:session_id, **{tab_index: @tab_index}),
                   "#{@session_id}"
    end
  end

  describe '#terminal_ids_for_session' do
    it 'finds all terminal IDs for one session ID' do
      @dbus.sessions_interface.expects(:terminalIdsForSessionId).
                               with(@session_id).
                               returns([@terminal_ids])

      assert_equal @client.send(:terminal_ids_for_session, **{session_id: @session_id}),
                   @terminal_ids_array
    end
  end

  describe '#sessions_ids' do
    it 'finds all session IDs in Yakuake instance' do
        @dbus.sessions_interface.expects(:sessionIdList).
                                 returns([@session_ids])
        assert_equal @client.send(:sessions_ids), @session_ids_array
    end
  end

  describe '#remove_terminal' do
    it 'removes terminal by ID' do
      @dbus.sessions_interface.expects(:removeTerminal).
                               with(@terminal_id).at_most_once
      @client.remove_terminal(terminal_id: @terminal_id)
    end
  end

  describe '#remove_tab' do
    it 'removes tab by tab index' do
      @dbus.sessions_interface.expects(:removeSession).
                               with(@session_id).at_most_once
      @dbus.tabs_interface.expects(:sessionAtTab).
                           with(@tab_index).returns(["#{@session_id}"])
      @client.remove_tab(tab_index: @tab_index)
    end
  end

  describe '#add_tabs_if_needed' do
    it 'Adds tabs to Yakuake if there are less than :count of them' do
      @dbus.sessions_interface.expects(:raiseSession).at_most_once
      @dbus.sessions_interface.expects(:activeSessionId).returns([@session_id])

      @client.expects(:sessions_ids).returns(@session_ids_array).at_most(2)
      @dbus.sessions_interface.expects(:addSession).at_most(4)
      @client.add_tabs_if_needed(count: 6)
    end

    it 'Does nothing if there are already :count or more tabs' do
      @client.expects(:sessions_ids).returns(@session_ids_array).at_most(2)
      @dbus.sessions_interface.expects(:addSession).at_most(0)
      @client.add_tabs_if_needed(count: 1)
    end
  end

  describe '#run_command_in_terminal' do
    it 'Sends text command to terminal ID specified' do
      @dbus.sessions_interface.expects(:runCommandInTerminal).
        with(@terminal_id, @command_text).at_most_once
      @client.run_command_in_terminal terminal_id: @terminal_id, command_text: @command_text
    end
  end

  describe '#run_command_in_tab' do
    it 'Sends text command to first terminal in specified tab index' do
      @client.expects(:terminal_ids_for_tab).
              with(tab_index: @tab_index).returns(@terminal_ids_array)

      @client.expects(:run_command_in_terminal).
              with(terminal_id: @terminal_ids_array.first,
                   command_text:@command_text)

      @client.run_command_in_tab tab_index: @tab_index, command_text: @command_text
    end
  end

  describe '#set_tab_title' do
    it 'sets title of tab with provided tab index' do
      @dbus.tabs_interface.expects(:setTabTitle).
                           with(@session_id, @tab_title)
      @client.expects(:session_id).with(tab_index: @tab_index).
              returns(@session_id)

      @client.set_tab_title tab_index: @tab_index, new_title: @tab_title
    end
  end

  describe '#tab_title' do
    it 'returns title of tab with specified tab index' do
      @dbus.tabs_interface.expects('tabTitle').
                           with(@session_id).returns([@tab_title])
      @client.expects(:session_id).with(tab_index: @tab_index).
              returns(@session_id)

      assert_equal @client.tab_title(tab_index: @tab_index), @tab_title
    end
  end

  describe '#terminal_ids_for_tab' do
    it 'returns IDs of all terminals in tab specified by tab index' do
      @client.expects(:session_id).with(tab_index: @tab_index).
              returns(@session_id)
      @client.expects(:terminal_ids_for_session).with(session_id: @session_id).
              returns(@terminal_ids)

      assert_equal @client.terminal_ids_for_tab(tab_index: @tab_index),
                   @terminal_ids
    end
  end

end
