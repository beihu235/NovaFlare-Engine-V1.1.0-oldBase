#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
#
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download/version/4.3.3/
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install tjson
haxelib install flixel-addons
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install SScript
haxelib install hxCodec
haxelib install hxcpp-debug-server
haxelib run lime setup
haxelib run lime setup flixel
haxelib run flixel-tools setup
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
