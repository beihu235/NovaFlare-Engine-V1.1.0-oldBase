@echo off
color 0a
cd ..
echo Installing dependencies.
@echo on
haxelib install lime 8.0.1
haxelib install openfl 
haxelib install flixel
haxelib install tjson
haxelib install flixel-addons
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install SScript 7.0.0
haxelib install hxCodec 2.6.0
haxelib install hxcpp-debug-server
haxelib run lime setup
haxelib run lime setup flixel
haxelib run flixel-tools setup
haxelib run SScript setup
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
curl -# -O https://download.visualstudio.microsoft.com/download/pr/3105fcfe-e771-41d6-9a1c-fc971e7d03a7/8eb13958dc429a6e6f7e0d6704d43a55f18d02a253608351b6bf6723ffdaf24e/vs_Community.exe
vs_Community.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 -p
@echo off
del vs_Community.exe
echo Finished!
pause
