import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "common"

ComboBox {
  id: container
  property int fontSize: root.font.pointSize
  property int screenPadding: parent.Layout.margins
  background: null

  property bool vkbd_installed: false
  function keyboardStatusChanged(state: int) {
    vkbd_installed = state == Loader.Ready
  }

  indicator: Button {
    anchors.fill: parent
    Text {
      anchors.centerIn: parent
      renderType: Text.QtRendering
      text: ""
      font.family: iconFont
      color: container.focus ? root.palette.accent : root.palette.text
      font.pointSize: fontSize * 1.5
    }

    background: Rectangle {
      color: "transparent"
    }

    onPressed: {
      container.popup.open()
    }

  }

  function actionPressed() {
    if (currentIndex == 0) root.activateVirtualKeyboard = !root.activateVirtualKeyboard;
  }

  readonly property var vkbd_toggle: {'icon': "", 'label': config.virtualKeyboard || "Virtual keyboard", 'enabled': vkbd_installed}

  model: [vkbd_toggle]
  onActivated: {
    currentIndex = highlightedIndex;
    actionPressed();
  }
  delegate: RowLayout {
    Layout.fillWidth: true
    Layout.preferredHeight: fontSize * 3

    spacing: fontSize
    Layout.leftMargin: 10
    Layout.rightMargin: 10

    Text {
      visible: config.boolValue("iconsInMenus")
      renderType: Text.QtRendering
      text: modelData['icon']
      font.pointSize: fontSize
      font.family: config.iconFont
      color: root.palette.buttonText
    }

    Text {
      id: label
      renderType: Text.QtRendering
      text: modelData['label']
      font.family: root.font.family
      font.pointSize: fontSize
      color: root.palette.buttonText
      Layout.fillWidth: true
    }

    Switch {
      id: toggle
      state: enabled ? "" : "disabled"
      Layout.preferredHeight: indicator.implicitHeight + 10
      Layout.preferredWidth: indicator.implicitWidth + 10
      Layout.fillWidth: false

      checked: root.activateVirtualKeyboard
      onClicked: {
        container.currentIndex = index
        container.actionPressed()
      }

      background: Rectangle {
        color: "transparent"
        radius: 8
      }

      indicator: Rectangle {
        anchors.centerIn: parent
        implicitHeight: fontSize * 1.5
        implicitWidth: fontSize * 3
        radius: implicitHeight / 2
        color: parent.checked ? root.palette.accent : Qt.darker(root.palette.button, 1.3)
        border.color: parent.checked ? root.palette.accent : "#cccccc"

        Rectangle {
          id: knob
          x: toggle.checked ? parent.width - width : 0
          height: parent.implicitHeight
          width: height
          radius: height / 2
          color: toggle.down ? "#cccccc" : root.palette.buttonText
          border.color: toggle.checked ? root.palette.accent : "#999999"
        }
      }
      states: [
        State {
          name: "disabled"
          when: !container.vkbd_installed
          PropertyChanges {
            target: toggle.indicator
            color: "#555555"
            border.color: "#333333"
            opacity: 0.3
          }
          PropertyChanges {
            target: knob
            x: 0
            color: "#cccccc"
            border.color: Qt.lighter(toggle.indicator.color, 1.5)
          }
        }
      ]

    }

  }

  popup: PopupPanel {
    x: root.LayoutMirroring.enabled ? -parent.width : (2 * parent.width - width + parent.parent.spacing)
    interactive: false

    model: container.delegateModel
  }

}
