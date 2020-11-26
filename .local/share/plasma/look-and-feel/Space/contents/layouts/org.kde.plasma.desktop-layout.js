var plasma = getApiVersion(1);

var layout = {
    "desktops": [
        {
            "applets": [
                {
                    "config": {
                        "/": {
                            "PreloadWeight": "42"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "420",
                            "DialogWidth": "560"
                        },
                        "/General": {
                            "sources": "cpu%2Fcpu11%2FTotalLoad,cpu%2Fcpu10%2FTotalLoad,cpu%2Fcpu9%2FTotalLoad,cpu%2Fcpu8%2FTotalLoad,cpu%2Fcpu7%2FTotalLoad,cpu%2Fcpu6%2FTotalLoad,cpu%2Fcpu5%2FTotalLoad,cpu%2Fcpu4%2FTotalLoad,cpu%2Fcpu3%2FTotalLoad,cpu%2Fcpu2%2FTotalLoad,cpu%2Fcpu1%2FTotalLoad,cpu%2Fcpu0%2FTotalLoad",
                            "updateInterval": "1000"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.systemmonitor.cpu",
                    "title": "CPU Load Monitor"
                },
                {
                    "config": {
                        "/": {
                            "PreloadWeight": "42"
                        },
                        "/ConfigDialog": {
                            "DialogHeight": "420",
                            "DialogWidth": "560"
                        },
                        "/General": {
                            "sources": "mem%2Fphysical%2Fapplication",
                            "updateInterval": "1000"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.systemmonitor.memory",
                    "title": "Memory Status"
                },
                {
                    "config": {
                        "/": {
                            "PreloadWeight": "42"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.systemmonitor.net",
                    "title": "Network Monitor"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "420",
                            "DialogWidth": "560"
                        },
                        "/General": {
                            "sources": "disk%2Fnvme0n1_(259%3A0)%2FRate%2Fwblk,disk%2Fsda_(8%3A0)%2FRate%2Fwblk",
                            "updateInterval": "1000"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.systemmonitor.diskactivity",
                    "title": "Hard Disk I/O Monitor"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "420",
                            "DialogWidth": "560"
                        },
                        "/General": {
                            "sources": "partitions%2F%2Ffilllevel\\,partitions%2Fboot%2FEFI%2Ffilllevel\\,partitions%2Fhome%2Fdoc%2FVids%2Ffilllevel,partitions%2F%2Ffilllevel,partitions%2Fboot%2FEFI%2Ffilllevel,partitions%2Fhome%2Fdoc%2FVids%2Ffilllevel",
                            "updateInterval": "3000"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.systemmonitor.diskusage",
                    "title": "Hard Disk Space Usage"
                },
                {
                    "config": {
                        "/ConfigDialog": {
                            "DialogHeight": "420",
                            "DialogWidth": "560"
                        },
                        "/General": {
                            "color": "blue",
                            "noteId": "3e7dc2b9-bf1c-497a-8862-88bb51212d"
                        }
                    },
                    "geometry.height": 0,
                    "geometry.width": 0,
                    "geometry.x": 0,
                    "geometry.y": 0,
                    "plugin": "org.kde.plasma.notes",
                    "title": "Notes"
                }
            ],
            "config": {
                "/": {
                    "ItemGeometriesHorizontal": "Applet-13:0,48,496,336,0;Applet-6:0,704,320,192,0;Applet-5:0,896,320,176,0;Applet-4:1616,880,304,192,0;Applet-2:1616,32,304,704,0;Applet-3:1616,736,304,144,0;",
                    "formfactor": "0",
                    "immutability": "1",
                    "lastScreen": "0",
                    "wallpaperplugin": "org.kde.image"
                },
                "/ConfigDialog": {
                    "DialogHeight": "420",
                    "DialogWidth": "560"
                },
                "/Configuration": {
                    "PreloadWeight": "42"
                },
                "/General": {
                    "ToolBoxButtonState": "topright",
                    "ToolBoxButtonX": "1892",
                    "pressToMoveHelp": "false",
                    "showToolbox": "false"
                },
                "/Wallpaper/org.kde.image/General": {
                    "Image": "file:///home/doc/Pics/Wallpaper/dark_forrest.jpg"
                }
            },
            "wallpaperPlugin": "org.kde.image"
        }
    ],
    "panels": [
    ],
    "serializationFormatVersion": "1"
}
;

plasma.loadSerializedLayout(layout);
