fx_version 'adamant'
games { "rdr3" }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'
author 'Halcon'
description 'lumen_npcdoctor vorp version'
version 'Version 1.0'

client_scripts {
	'config.lua',
	'notifications/dataview.lua',
	'notifications/cl_notification.js',
	'notifications/cl_notification.lua',
	'client/client.lua',

}

server_scripts {
	'config.lua',
	'server/server.lua',
}

