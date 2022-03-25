if localPlayer then
    loadstring(exports.beautify_library:fetchImports())()
end
loadstring(exports.assetify_library:fetchImports())()
