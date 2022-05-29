Resource: Custom Billboards v1.0.4
contact: knoblauch700@o2.pl

This resource lets You create billboards. The billboard is a quad that always faces the camera.
In this case billboard Elements are created using dxDrawMaterialLine3d MTA function. 
I have changed the behaviour of the material to act as cylindrical billboards do.
There are many possibilities to use this resource. But that's all up to you.

exported functions are explained in the mta wiki:
https://wiki.multitheftauto.com/wiki/Resource:Custom_billboards

test resource:
http://www.solidfiles.com/d/07ea100174/custom_billboards_test.zip

exported functions:
createBillboard(material,posX,posY,posZ,sizeX,sizeY,colorR,colorG,colorB,colorA)
	Creates a billboard.
setBillboardMaterial(billboard Element,material)
	Sets the billboard material (ex. texture).
destroyBillboard(billboard Element)
	Destroys the billboard element.
setBillboardPosition(billboard Element,posX,posY,posZ)
	Position of the billboard in world space.
setBillboardSize(Element,size)
	Set size of the billboard.
setBillboardSizeXY(Element,sizeX,sizeY)
	Set the width and height of the billboard.
setBillboardDepthBias(billboard Element,depthBiasValue)
	On createBillboard the depthBias is set properly (0-1). You can however set other value
	depending on your needs. To see the results you'll need to set enableDepthBiasScale
	to true. 
setBillboardColor(billboard Element,colorR,colorG,colorB,colorA)
	RGBA diffuse color emitted by the billboard. 
setBillboardsDistFade(MaxEffectFade,MinEffectFade)
	Set the distance in which the billbords start to fade.
enableDepthBiasScale(isEnabled)
	Standard depthBias for GTASA coronas is ab. 1 unit, despise the corona scale. This function
	elables depthBias scaling.
