local sX, sY = guiGetScreenSize ()
local cShader = dxCreateShader("data/screen.fx")
local cSource = dxCreateScreenSource(sX, sY)
dxSetShaderValue(cShader, "vSource0", cSource)
dxSetShaderValue(cShader, "vResolution", sX, sY)

showScreen = true
--showCursor(true, false)
addEventHandler( "onClientRender", root, function( )
    if not cShader then return false end
    if showScreen then
        dxUpdateScreenSource(cSource)
        dxDrawImage(0, 0, sX, sY, cShader)
    end
end)

bindKey("z", "down", function()
    showScreen = not showScreen
    outputChatBox("Screen State: "..tostring(showScreen))
end)