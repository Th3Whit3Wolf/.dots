/*
*  Copyright 2019  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.latte.components 1.0 as LatteComponents

LatteComponents.IndicatorItem {
    id: root
    needsIconColors: true
    providesFrontLayer: false
    minThicknessPadding: 0.03
    minLengthPadding: 0.25

    readonly property bool progressVisible: indicator.hasOwnProperty("progressVisible") ? indicator.progressVisible : false
    readonly property bool isHorizontal: plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool isVertical: !isHorizontal

    readonly property int screenEdgeMargin: indicator.hasOwnProperty("screenEdgeMargin") ? indicator.screenEdgeMargin : 0
    readonly property int thickness: !isHorizontal ? width - screenEdgeMargin : height - screenEdgeMargin

    readonly property int shownWindows: indicator.windowsCount - indicator.windowsMinimizedCount
    readonly property int maxDrawnMinimizedWindows: shownWindows > 0 ? Math.min(indicator.windowsMinimizedCount,2) : 3

    readonly property int groupItemLength: indicator.currentIconSize * 0.08
    readonly property int groupsSideMargin: indicator.windowsCount <= 1 ? 0 : (Math.min(indicator.windowsCount-1,2) * root.groupItemLength)

    readonly property real backColorBrightness: colorBrightness(indicator.palette.backgroundColor)
    readonly property color activeColor: indicator.palette.buttonFocusColor
    readonly property color outlineColor: {
        if (!indicator.configuration.drawShapesBorder) {
            return "transparent"
        }

        return backColorBrightness < 127 ? indicator.palette.backgroundColor : indicator.palette.textColor;
    }
    readonly property color backgroundColor: indicator.palette.backgroundColor

    function colorBrightness(color) {
        return colorBrightnessFromRGB(color.r * 255, color.g * 255, color.b * 255);
    }

    // formula for brightness according to:
    // https://www.w3.org/TR/AERT/#color-contrast
    function colorBrightnessFromRGB(r, g, b) {
        return (r * 299 + g * 587 + b * 114) / 1000
    }


    //! Bindings for properties that have introduced
    //! later on Latte versions > 0.9.2
    Binding{
        target: level.requested
        property: "iconOffsetX"
        when: level && level.requested && level.requested.hasOwnProperty("iconOffsetX")
        value: -root.groupsSideMargin / 2
    }

    Binding{
        target: root
        property: "appletLengthPadding"
        when: root.hasOwnProperty("appletLengthPadding")
        value: indicator.configuration.appletPadding
    }

    Binding{
        target: root
        property: "enabledForApplets"
        when: root.hasOwnProperty("enabledForApplets")
        value: indicator.configuration.enabledForApplets
    }

    Binding{
        target: root
        property: "lengthPadding"
        when: root.hasOwnProperty("lengthPadding")
        value: indicator.configuration.lengthPadding
    }

    //! Background Layer
    Item {
        id: floater
        anchors.fill: parent
        anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
        anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
        anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
        anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0

        Loader {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            height: parent.height
            active: indicator.windowsCount>=3
            opacity: 0.3

            sourceComponent: GroupRect{
            }
        }

        Loader {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: indicator.windowsCount>2 && active ? groupItemLength : 0

            height: parent.height
            active: indicator.windowsCount>=2
            opacity: 0.6

            sourceComponent: GroupRect{
            }
        }

        Loader{
            id: backLayer
            anchors.fill: parent
            anchors.rightMargin: groupsSideMargin
            active: level.isBackground && (indicator.isActive || (indicator.isTask && !indicator.isLauncher)) && indicator.isSquare

            sourceComponent: BackLayer{
                anchors.fill: parent

                showProgress: root.progressVisible
            }
        }

        Loader{
            id: plasmaBackHighlight
            anchors.fill: parent
            active: level.isBackground && indicator.isActive && !indicator.isSquare

            sourceComponent: PlasmaHighlight{
            }
        }
    }
}
