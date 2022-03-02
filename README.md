![](https://cdn.discordapp.com/attachments/867657575725269003/907028708823539712/vStudio.png)

**━ Maintainer(s):** [**Aviril**](https://github.com/Aviril), [**Tron**](https://github.com/OvileAmriam)

**vRPZ** is a startup **Dayz-Roleplay Template** focussing on optimization and integrating existing vStudio licensed libraries. You must consider using this framework only if you are a developer and experienced enough to extend it. This is not recommended for production ready server rather serving as core.

## ━ Features

💎**CONSIDER** [**SPONSORING**](https://ko-fi.com/ovStudio) **US TO SUPPORT THE DEVELOPMENT.**

* Completely Open-Source
* Config Loader
* Designed w/ Internationalization
* [DBify Library](https://github.com/ov-sa/DBify-Library) Integration
* [Assetify Library](https://github.com/ov-sa/Assetify-Library) Integration
* [Beautify Library](https://github.com/ov-sa/Beautify-Library) Integration
* [Cinecam Handler](https://github.com/ov-sa/MTA-Cinecam_Handler) Integration
* Completely Performance-Friendly

## ━ Credits

* **ov | Mario (Developer)**
* **ov | Buddy (Modeler)**
* **ov | Aviril (Graphics Developer)**
* **ov | April (Designer)**
* **ov | Tron (Developer)**
* **ov | Neor (Developer)**
* **ov | Skann (Modeler)**
* **ov | Mazvis (Contributor)**

## ━ Installation

1. Download the latest release
2. Unpack it to your `YourMTAFolder\server\mods\deathmatch\resources` directory
3. Add below mentioned to your `mtaserver.conf` 
```xml
<resource src="dbify_library" startup="1" protected="0"/>
<resource src="resource_loader" startup="1" protected="0"/>
```
4. Add your MySQL database credentials into `[Library]/dbify_library/settings/server.lua`
5. Boot your server

## ━ Contents

* [**Official Releases**](./)
* [**Discord Community**](http://discord.gg/sVCnxPW)

## ━ Servers Utilizing Framework

* **vRiver-Dayz** (Roleplay-Dayz Transition)
