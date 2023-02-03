resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Trew HUD UI'

ui_page 'html/ui.html'


files {
	'html/ui.html',
	'html/main.css',
	'html/app.js',

	'html/img/vehicle-gear.png',
	'html/img/vehicle-lights.png',
	'html/img/vehicle-lights-high.png',
	'html/img/vehicle-seatbelt.png',

	'html/img/speedometer.png',
	'html/img/logo.png',

	
	'html/sounds/seatbelt-buckle.ogg',
	'html/sounds/seatbelt-unbuckle.ogg',

	'html/sounds/car-indicators.ogg',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua',
	'client/hansolo.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua',
	'server/milleniumfalcon.lua'
}

dependencies {
	'es_extended',
	'hudbyAZDEV'
}