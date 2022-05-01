script_name('AutoUpDate')
script_author('TonY')

require "lib.moonloader"
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'

local updatesrc = {
	check_ver = 0, -- old version.
	script_update = "", -- link to obnov script
	script_version = 0, -- new script version. (0 - 0.0)
	script_path = thisScript().path, -- storage script.
	update_url = "", -- link to ini file update.
	update_path = getWorkingDirectory().."\\autoupdate\\autoupdate.ini" -- storage file to new version.
}

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

	updateload()

	while true do wait(0)
		if upd_script then
			downloadUrlToFile(updatesrc.script_update, updatesrc.script_update, function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("The script was successfully updated: [ v"..tonumber(updatesrc.script_version).." ]")
					thisScript():reload() 
					script_update = true
				end
			end)
		end
	end
end

function updateload() 
	downloadUrlToFile(updatesrc.update_url, updatesrc.update_path, function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updateIni = inicfg.load(nil, updatesrc.update_path)
			if updateIni.version.ver ~= updatesrc.check_ver then
				upd_script = true
				sampAddChatMessage("Found an update: "..updateIni.version.ver..". ")
			else
				upd_script = false
				sampAddChatMessage("Alas, there is no update. ")
			end
		end
	end)
end
