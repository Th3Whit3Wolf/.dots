/*
 *  Copyright 2019 Michail Vourlakos <mvourlakos@gmail.com>
  *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.0
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.activities 0.1 as Activities

Item {
    //! Latte DBus Interaction

    property string currentScreenName: Screen.name
    property string lastScreenName: ""

    Activities.ActivityInfo {
        id: activityInfo
        activityId: ":current"
        onActivityIdChanged: {
            if (activityId === root.activityId) {
                Qt.callLater(sendBackground);
            }
        }
    }

    onCurrentScreenNameChanged: {
        if (lastScreenName !== "" && currentScreenName !==lastScreenName) {
            //! when the desktop has changed screen then previous information must be
            //! disabled from Latte because they became obsolete
            Qt.callLater(cancelBackgrounds);
        }
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    function sendBackground() {
        if (root.activityId !== activityInfo.activityId || root.modelImage === "") {
            // block updates when no needed
            return;
        }

        var command = 'qdbus org.kde.lattedock /Latte setBackgroundFromBroadcast ' + root.activityId + ' ' + Screen.name + ' "' + root.modelImage +'"';
        console.log("Executing command : " + command);
        lastScreenName = Screen.name;
        executable.exec(command);
    }

    function cancelBackgrounds() {
        var command = 'qdbus org.kde.lattedock /Latte setBroadcastedBackgroundsEnabled ' + root.activityId + ' ' + lastScreenName + ' false';
        console.log("Executing command : " + command);
        executable.exec(command);
    }

    Connections {
        target: root
        onModelImageChanged: {
            Qt.callLater(sendBackground);
        }
    }
}
