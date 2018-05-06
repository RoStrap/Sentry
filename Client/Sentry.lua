-- Client-side Sentry access
-- @filtering Client

--[[
	Example, client:

	local Try = require("Try")
	local Sentry = require("Sentry")

	Try(error, "test client error")
		:Catch(Sentry.Post)
--]]

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RoStrap Core
local Resources = require(ReplicatedStorage:WaitForChild("Resources"))
local Enumeration = Resources:LoadLibrary("Enumeration")

Enumeration.IssueType = {"Debug", "Info", "Warning", "Error", "Fatal"}

-- RemoteEvent
local RemoteEvent = Resources:GetRemoteEvent("Sentry")

-- Exposed API
local Sentry = {}

function Sentry:Post(Message, Traceback, MessageType)
	-- Post(string Message [string MessageType, string Traceback])
	-- Posts parameters to Sentry.io
	-- Supports hybrid syntax calling

	if self ~= Sentry then Message, Traceback, MessageType = self, Message, Traceback end

	RemoteEvent:FireServer(Message, Traceback or debug.traceback(),
		type(MessageType) == "number" and MessageType or
		typeof(MessageType) == "EnumItem" and Enumeration.IssueType[MessageType.Name:gsub("Message", "", 1):gsub("Output", "Debug", 1)].Value or
		type(MessageType) == "userdata" and MessageType.Value or
		Enumeration.IssueType.Error.Value
	)
end

return Sentry
