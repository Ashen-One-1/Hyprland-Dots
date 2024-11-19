import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
  id: menu
  y: -(height + root.font.pointSize / 2)

  property var model
  property Component delegate
  property bool interactive: true
  property real maximum: 5.5
  // maximum number of options to show at once, scroll/flick to see the rest
  // adding .5 works as a visual hint there's more options by displaying half of the next button
  property real delegateHeight: fontSize * 3

  padding: 0
  topPadding: background.radius
  bottomPadding: background.radius

  background: Rectangle {
    color: root.palette.button
    radius: 8
  }

  contentItem: Flickable {
    clip: true
    implicitWidth: contentWidth
    implicitHeight: interactive ? Math.min(contentHeight, menu.maximum * (menu.delegateHeight + delegate_container.spacing)) : contentHeight
    contentWidth: delegate_container.width
    contentHeight: delegate_container.height

    interactive: menu.interactive

    flickableDirection: Flickable.VerticalFlick
    ScrollBar.vertical: ScrollBar { }

    ColumnLayout {
      id: delegate_container
      spacing: 4
      Repeater {
        model: menu.model
        delegate: menu.delegate
      }
    }
  }

  enter: Transition {
    NumberAnimation { property: "height"; from: 0.0; to: implicitHeight; duration: 50 * config.boolValue("enableAnimations") }
  }
  exit: Transition {
    NumberAnimation { property: "height"; from: implicitHeight; to: 0.0; duration: 50 * config.boolValue("enableAnimations") }
  }

}
