local GUI = require("GUI")
local system = require("System")
local fs = require("Filesystem")
local image = require("Image")
local paths = require("Paths")
 
--------------------------------------------------------------------------------
 
local SD = fs.path(system.getCurrentScript())
local p = SD .. "Icons/"
local l = system.getLocalization(SD .. "Localization/")

local function checkApp(path)
if fs.exists(paths.user.applicationData .. path) then
return true
else
return false  
end
end 

local function checkCache(path)
if fs.exists(path) then
return true
else
return false  
end
end 
   
local workspace, window = system.addWindow(GUI.filledWindow(1, 1, 118, 31, 0x0))
window:addChild(GUI.image(1, 1, image.load(SD .. "background.pic")))
window.showDesktopOnMaximize = true
 
local blackoutBackground = window:addChild(GUI.panel(1, 1, window.width, window.height, 0x4B4B4B, 0.4))
 
local list = window:addChild(GUI.list(1, 4, 22, 1, 3, 0, 0x4B4B4B, 0xE1E1E1, 0x4B4B4B, 0xE1E1E1, 0x9900BF, 0xFFFFFF))
local listCover = window:addChild(GUI.panel(1, 1, list.width, 3, 0x4B4B4B))
local layout = window:addChild(GUI.layout(list.width + 1, 1, 1, 1, 1, 1))
 
 local lx = layout.localX
 
window.backgroundPanel.localX = lx
blackoutBackground.localX = lx

 
local function addTab(text, func)
  list:addItem(text).onTouch = function()
    layout:removeChildren()
    func()
    workspace:draw()
  end
end
 
local function addText(text)
  layout:addChild(GUI.text(workspace.width, workspace.height, 0xE1E1E1, text))
end
 
local function addButton(text)
  return layout:addChild(GUI.roundedButton(1, 1, 24, 1, 0xE1E1E1, 0x1E1E1E, 0xCC24FF, 0x2D2D2D, text))
end
 
local function drawIcon(pic)
  return layout:addChild(GUI.image(2, 2, image.load(pic)))
end
 
local function resetConfig(config)
  fs.remove(paths.user.applicationData .. config)
end
 
-- main
addTab(l.main, function()
  drawIcon(SD .. "Icon.pic")
  addText(l.greeting .. system.getUser())
end)
 
-- Trash
addTab(l.trash, function()
  drawIcon(paths.system.icons .. "Trash.pic")
  addText(l.trasht)
 
  addButton(l.trash).onTouch = function()
    fs.remove(paths.user.trash)
    fs.makeDirectory(paths.user.trash)
  end
end)
 
 -- App Market
 if checkApp("/App Market/Cache")then
 if checkApp("/App Market/User.cfg")then
addTab(l.appmarket, function()
  drawIcon(p .. "Iconappmarket.pic")
  addText(l.deltapp)
 
  addButton(l.delcapp).onTouch = function()
    resetConfig("App Market/Cache")
    GUI.alert(l.delc)
  end
 
  addText(l.LAuthorizationAppMarketT)
 
  addButton(l.LAuthorizationAppMarketB).onTouch = function()
    resetConfig("App Market/User.cfg")
    GUI.alert(l.LAuthorizationAppMarketA)
  end
end)
end
end 
 
 if checkApp("/IRC/Config.cfg")then
 if checkApp("/IRC/History.cfg")then
 -- IRC
addTab(l.IRC, function()
  drawIcon(p .. "IconIRC.pic")
  addText(l.IRCT)
  addText(l.IRCT2)
 
  addButton(l.delbpic).onTouch = function()
    resetConfig("/IRC/Config.cfg")
    GUI.alert(l.IRCA1)
      
  end
 
  addText(l.IRCHT)
 
  addButton(l.delbpic).onTouch = function()
    resetConfig("/IRC/History.cfg")
    GUI.alert(l.IRCA2)
  end
end)
end
end
 
 -- VK
 if checkApp("/VK/Config5.cfg")then
addTab(l.VK, function()
  drawIcon(p .. "IconVK.pic")
  addText(l.vkt)
 
  addButton(l.delcvk).onTouch = function()
    resetConfig("/VK/Config5.cfg")
    GUI.alert(l.delc)
  end
end)
end
 if checkApp("MineCode IDE/")then
 -- MineIDE
addTab(l.MineIDE, function()
  drawIcon(p .. "IconMineIDE.pic")
  addText(l.deltmine)
 
  addButton(l.delbmine).onTouch = function()
    resetConfig("/MineCode IDE")
    GUI.alert(l.delc)
  end
end)
 end

 -- Weather
 if checkApp("Weather/")then
addTab(l.Weather, function()
  drawIcon(p .. "WeatherIcon.pic")
  addText(l.WeatherT)
 
  addButton(l.delbmine).onTouch = function()
    resetConfig("/Weather/")
    GUI.alert(l.IRCA1)
  end
end)
 end
 
 -- MineCR "Katalog 3d""
 if checkCache("/3dm/")then
addTab("Katalog 3d", function()
  drawIcon(p .. "IconKatalog3d.pic")
  addText(l.katalogt)
 
  addButton(l.katalogb).onTouch = function()
    fs.remove("/3dm/")
    end
end)
end

if checkApp("/EFI/")then
addTab("EFI Control", function()
drawIcon(p .. "IconEFI.pic")
addText(l.ControlEFIt)
addButton(l.ControlEFIb).onTouch = function()
 resetConfig("/EFI/")
 fs.remove(paths.user.desktop .. "EFI.lnk")
 
 end
end)
end
 
list.eventHandler = function(workspace, list, e1, e2, e3, e4, e5)
  if e1 == "scroll" then
    local horizontalMargin, verticalMargin = list:getMargin()
    list:setMargin(horizontalMargin, math.max(-list.itemSize * (#list.children - 1), math.min(0, verticalMargin + e5)))
 
    workspace:draw()
  end
end
 
local function calculateSizes()
  list.height = window.height
 
  window.backgroundPanel.width = window.width - list.width
  window.backgroundPanel.height = window.height
 
  layout.width = window.backgroundPanel.width
  layout.height = window.height
  
  blackoutBackground.width = layout.width
end
 
window.onResize = function()
  calculateSizes()
end
 
calculateSizes()
window.actionButtons:moveToFront()
list:getItem(1).onTouch()