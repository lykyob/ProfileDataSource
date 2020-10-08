--[[

██████╗░██████╗░░█████╗░███████╗██╗██╗░░░░░███████╗  ██████╗░░█████╗░████████╗░█████╗░
██╔══██╗██╔══██╗██╔══██╗██╔════╝██║██║░░░░░██╔════╝  ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
██████╔╝██████╔╝██║░░██║█████╗░░██║██║░░░░░█████╗░░  ██║░░██║███████║░░░██║░░░███████║
██╔═══╝░██╔══██╗██║░░██║██╔══╝░░██║██║░░░░░██╔══╝░░  ██║░░██║██╔══██║░░░██║░░░██╔══██║
██║░░░░░██║░░██║╚█████╔╝██║░░░░░██║███████╗███████╗  ██████╔╝██║░░██║░░░██║░░░██║░░██║
╚═╝░░░░░╚═╝░░╚═╝░╚════╝░╚═╝░░░░░╚═╝╚══════╝╚══════╝  ╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝

░░███╗░░░░░░░███╗░░
░████║░░░░░░████║░░
██╔██║░░░░░██╔██║░░
╚═╝██║░░░░░╚═╝██║░░
███████╗██╗███████╗
╚══════╝╚═╝╚══════╝

Documentation:
	- https://devforum.roblox.com/t/809572
	
]]

local ProfileData = {}
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

function ProfileData:DatastoreTest()
	
	local TestSuc, TestFai = pcall(function()
		local Test = DataStoreService:GetDataStore("ProfileDataTesting")
		Test:SetAsync("TestingKey", 1234567890)
		Test:GetAsync("TestingKey")
	end)
	
	if RunService:IsStudio() then
		return false, "Datastores Don't Work Correctly In Studio."
	elseif not TestSuc then
		return false, TestFai
	else
		return true, nil
	end
end

function ProfileData:GetDatastore(Name)
	local Datastore
	local DatastoreFunctions = {}
	
	local success, fail = pcall(function()
		DataStoreService:GetDataStore(Name)
	end)
	
	if not success then
		warn("Failed To Get Datastore: "..fail)
	else
		print("Successfully Got Datastore From Cloud.")
		Datastore = DataStoreService:GetDataStore(Name)
	end
	
	function DatastoreFunctions:SetData(UserObject, Value)
		local success, fail = pcall(function()
			if UserObject:IsA("Player") then
				Datastore:SetAsync(UserObject.UserId, Value)
			end
		end)
		
		if not success then
			warn("Failed To Set Data: "..fail)
		else
			print("Successfully Uploaded Data To Cloud.")
		end
	end
	
	function DatastoreFunctions:GetData(UserObject)
		local success, fail = pcall(function()
			if UserObject:IsA("Player") then
				Datastore:GetAsync(UserObject.UserId)
			end
		end)
		
		if not success then
			warn("Failed To Get Data: "..fail)
			return nil
		else
			print("Successfully Got Data From Cloud.")
			local Dat = Datastore:GetAsync(UserObject.UserId)
			return Dat
		end
	end
	
	function DatastoreFunctions:DeleteData(UserObject)
		local success, fail = pcall(function()
			if UserObject:IsA("Player") then
				Datastore:RemoveAsync(UserObject.UserId)
			end
		end)
		
		if not success then
			warn("Failed To Remove Data: "..fail)
		else
			print("Successfully Removed Data From Cloud.")
		end
		
	end
	
	return DatastoreFunctions
end

return ProfileData
