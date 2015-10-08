require "dbus"

# to explore yakuake interfaces use
# qdbus org.kde.yakuake /yakuake/sessions
# qdbus org.kde.yakuake /yakuake/tabs

module YakuakeController

  class YakuakeDBus

    attr_reader :sessions_interface, :tabs_interface

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

  end

end
