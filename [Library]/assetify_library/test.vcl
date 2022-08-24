# Generic asset configs
encryptKey: "vStudio - Aviril"
streamRange: 170

# TODO: Add boolean support
enableLODs: 1

# Scene configs
sceneDimension: -1
sceneInterior: 0
sceneOffsets:
    x: 0
    y: 0
    z: 0

# All shader related textures goes here
shaderMaps:
    # Control maps
    control:
        # Your texture name
        isld_1_trn:
            # Your attached control textures here
            # TODO: Add numeric index support
            __1:
                control: "control/isld_1_trn/road/control.png"
                bump: "control/isld_1_trn/road/bump.jpg"
                red:
                    map: "control/texture/grass/2/albedo.jpg"
                    bump: "control/texture/grass/2/bump.jpg"
                    scale: 600
            __2:
                bump: "control/isld_1_trn/bump.jpg"
                red:
                    map: "control/texture/sand/1/albedo_50a.png"
                    scale: 600
                green:
                    map: "control/texture/grass/1/albedo.jpg"
                    bump: "control/texture/grass/1/bump.jpg"
                    scale: 600
                blue:
                    map: "control/texture/sand/1/albedo_50a.png"
                    scale: 600