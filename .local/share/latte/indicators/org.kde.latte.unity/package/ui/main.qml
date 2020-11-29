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
    providesFrontLayer: indicator.configuration.shapesAtForeground
    minThicknessPadding: 0.10
    minLengthPadding: 0.05

    readonly property int colors: indicator.configuration.colors
    readonly property int thickness: plasmoid.formFactor === PlasmaCore.Types.Vertical ? width : height

    readonly property int screenEdgeMargin: indicator.hasOwnProperty("screenEdgeMargin") ? indicator.screenEdgeMargin : 0

    readonly property int shownWindows: indicator.windowsCount - indicator.windowsMinimizedCount
    readonly property int maxDrawnMinimizedWindows: shownWindows > 0 ? Math.min(indicator.windowsMinimizedCount,2) : 3

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
    Loader{
        id: backLayer
        anchors.fill: parent
        anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
        anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
        anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
        anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0

        active: level.isBackground

        sourceComponent: BackLayer{}
    }

    //! Foreground Layer to draw Triangles
    Loader{
        id: frontLayer
        anchors.fill: parent
        anchors.topMargin: plasmoid.location === PlasmaCore.Types.TopEdge ? root.screenEdgeMargin : 0
        anchors.bottomMargin: plasmoid.location === PlasmaCore.Types.BottomEdge ? root.screenEdgeMargin : 0
        anchors.leftMargin: plasmoid.location === PlasmaCore.Types.LeftEdge ? root.screenEdgeMargin : 0
        anchors.rightMargin: plasmoid.location === PlasmaCore.Types.RightEdge ? root.screenEdgeMargin : 0

        active: (level.isForeground && indicator.configuration.shapesAtForeground)
                || !indicator.configuration.shapesAtForeground

        sourceComponent:FrontLayer{}
    }
}
