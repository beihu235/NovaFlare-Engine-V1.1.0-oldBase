package cutscenes;

import flixel.addons.text.FlxTypeText;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import tjson.TJSON as Json;
import openfl.utils.Assets;
//import backend.Controls;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

import objects.TypedAlphabet;

import cutscenes.DialogueCharacter;


typedef DialogueFile = {
	var dialogue:Array<DialogueLine>;
}

typedef DialogueLine = {
	var portrait:Null<String>;
	var expression:Null<String>;
	var text:Null<String>;
	var boxState:Null<String>;
	var speed:Null<Float>;
	var sound:Null<String>;
}
    /*
        这些源码初版由弗雷泽(fraze)所写
        他的b站链接: https://b23.tv/y40j1RC
        我把它从0.63h搬到了0.71h并进行了一些扩展，但是有一说一加了个shadow被我整的很乱了
        实际上可以进行些更多的扩展比如说每段都能换颜色和font文件，但是为了兼容模组我就没有整了
        --北狐丶逐梦
    */
    
class DialogueBoxPsych extends FlxSpriteGroup
{
	var dialogue:FlxTypeText;
	var dialogueList:DialogueFile = null;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;


	public static var DEFAULT_TEXT_X = 220;
	public static var DEFAULT_TEXT_Y = 475;
	public static var DEFAULT_TEXT_WIDTH = 870;
	public static var DEFAULT_TEXT_SIZE = 32;

	var bgFade:FlxSprite = null;
	var box:FlxSprite;
	var textToType:String = '';

	var arrayCharacters:Array<DialogueCharacter> = [];

	var currentText:Int = 0;
	var offsetPos:Float = -600;

	var textBoxTypes:Array<String> = ['normal', 'angry'];

	var curCharacter:String = "";

	// var charPositionList:Array<String> = ['left', 'center', 'right'];

	public function new(dialogueList:DialogueFile, ?song:String = null)
	{
		super();

		if (song != null && song != '')
		{
			FlxG.sound.playMusic(Paths.music(song), 0);
			FlxG.sound.music.fadeIn(2, 0, 1);
		}

		bgFade = new FlxSprite(-500, -500).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
		bgFade.scrollFactor.set();
		bgFade.visible = true;
		bgFade.alpha = 0;
		add(bgFade);

		this.dialogueList = dialogueList;
		spawnCharacters();

		box = new FlxSprite(70, 370);
		box.frames = Paths.getSparrowAtlas('speech_bubble');
		box.scrollFactor.set();
		box.antialiasing = ClientPrefs.data.antialiasing;
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('angry', 'AHH speech bubble', 24);
		box.animation.addByPrefix('angryOpen', 'speech bubble loud open', 24, false);
		box.animation.addByPrefix('center-normal', 'speech bubble middle', 24);
		box.animation.addByPrefix('center-normalOpen', 'Speech Bubble Middle Open', 24, false);
		box.animation.addByPrefix('center-angry', 'AHH Speech Bubble middle', 24);
		box.animation.addByPrefix('center-angryOpen', 'speech bubble Middle loud open', 24, false);
		box.animation.play('normal', true);
		box.visible = true;
		box.setGraphicSize(Std.int(box.width * 0.9));
		box.updateHitbox();
		add(box);

		daText = initializeText(DEFAULT_TEXT_X , DEFAULT_TEXT_Y, DEFAULT_TEXT_WIDTH, DEFAULT_TEXT_SIZE, '');
		add(daText);
		
		daText_shadow = initializeText_shadow(DEFAULT_TEXT_X + 3, DEFAULT_TEXT_Y + 2, DEFAULT_TEXT_WIDTH, DEFAULT_TEXT_SIZE, '');
		add(daText_shadow);

		startNextDialog();
	}

	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	public static var LEFT_CHAR_X:Float = -60;
	public static var RIGHT_CHAR_X:Float = -100;
	public static var DEFAULT_CHAR_Y:Float = 60;

	function spawnCharacters()
	{
		#if (haxe >= "4.0.0")
		var charsMap:Map<String, Bool> = new Map();
		#else
		var charsMap:Map<String, Bool> = new Map<String, Bool>();
		#end
		for (i in 0...dialogueList.dialogue.length)
		{
			if (dialogueList.dialogue[i] != null)
			{
				var charToAdd:String = dialogueList.dialogue[i].portrait;
				if (!charsMap.exists(charToAdd) || !charsMap.get(charToAdd))
				{
					charsMap.set(charToAdd, true);
				}
			}
		}

		for (individualChar in charsMap.keys())
		{
			var x:Float = LEFT_CHAR_X;
			var y:Float = DEFAULT_CHAR_Y;
			var char:DialogueCharacter = new DialogueCharacter(x + offsetPos, y, individualChar);
			char.setGraphicSize(Std.int(char.width * DialogueCharacter.DEFAULT_SCALE * char.jsonFile.scale));
			char.updateHitbox();
			char.scrollFactor.set();
			char.alpha = 0.00001;
			add(char);

			var saveY:Bool = false;
			switch (char.jsonFile.dialogue_pos)
			{
				case 'center':
					char.x = FlxG.width / 2;
					char.x -= char.width / 2;
					y = char.y;
					char.y = FlxG.height + 50;
					saveY = true;
				case 'right':
					x = FlxG.width - char.width + RIGHT_CHAR_X;
					char.x = x - offsetPos;
			}
			x += char.jsonFile.position[0];
			y += char.jsonFile.position[1];
			char.x += char.jsonFile.position[0];
			char.y += char.jsonFile.position[1];
			char.startingPos = (saveY ? y : x);
			arrayCharacters.push(char);
		}
	}

	public static var LONG_TEXT_ADD = 24;

	var scrollSpeed = 4000;
	var daText:FlxTypeText = null;
	var daText_shadow:FlxTypeText = null;
	var ignoreThisFrame:Bool = true; // First frame is reserved for loading dialogue images

	public var finishedText:Bool = false;

	public var closeSound:String = 'dialogueClose';
	public var closeVolume:Float = 1;

	override function update(elapsed:Float)
	{
		if (ignoreThisFrame)
		{
			ignoreThisFrame = false;
			super.update(elapsed);
			return;
		}

		if (!dialogueEnded)
		{
			bgFade.alpha += 0.5 * elapsed;
			if (bgFade.alpha > 0.5)
				bgFade.alpha = 0.5;

			#if android
                var justTouched:Bool = false;

		        for (touch in FlxG.touches.list)
		        {
			        if (touch.justPressed)
			        {
				        justTouched = true;
			        }
		        }
		        #end

			if(FlxG.keys.justPressed.ESCAPE #if android || justTouched #end) {
				// If the current dialogue still going
				if (!finishedText)
				{
					// Complete the dialog
					daText.skip();
					daText_shadow.skip();
					// Do the callback
					if (skipDialogueThing != null)
					{
						skipDialogueThing();
					}
				}
				// If the current dialogue is finished and it's the last dialogue
				else if (currentText >= dialogueList.dialogue.length)
				{
					dialogueEnded = true;
					for (i in 0...textBoxTypes.length)
					{
						var checkArray:Array<String> = ['', 'center-'];
						var animName:String = box.animation.curAnim.name;
						for (j in 0...checkArray.length)
						{
							if (animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open')
							{
								box.animation.play(checkArray[j] + textBoxTypes[i] + 'Open', true);
							}
						}
					}

					box.animation.curAnim.curFrame = box.animation.curAnim.frames.length - 1;
					box.animation.curAnim.reverse();
					if (daText != null)
					{
						daText.kill();
						remove(daText);
						daText.destroy();
					}
					if (daText_shadow != null)
					{
						daText_shadow.kill();
						remove(daText_shadow);
						daText_shadow.destroy();
					}
					updateBoxOffsets(box);
					FlxG.sound.music.fadeOut(1, 0);
				}
				else
				{
					// If not the last dialog, then continue
					startNextDialog();
				}
				FlxG.sound.play(Paths.sound(closeSound), closeVolume);
			}
			// If finished
			else if (finishedText)
			{
				// Play finished animation
				var char:DialogueCharacter = arrayCharacters[lastCharacter];
				if (char != null && char.animation.curAnim != null && char.animationIsLoop() && char.animation.finished)
				{
					char.playAnim(char.animation.curAnim.name, true);
				}
			}
			else
			{
				var char:DialogueCharacter = arrayCharacters[lastCharacter];
				if (char != null && char.animation.curAnim != null && char.animation.finished)
				{
					char.animation.curAnim.restart();
				}
			}

			if (box.animation.curAnim.finished)
			{
				for (i in 0...textBoxTypes.length)
				{
					var checkArray:Array<String> = ['', 'center-'];
					var animName:String = box.animation.curAnim.name;
					for (j in 0...checkArray.length)
					{
						if (animName == checkArray[j] + textBoxTypes[i] || animName == checkArray[j] + textBoxTypes[i] + 'Open')
						{
							box.animation.play(checkArray[j] + textBoxTypes[i], true);
						}
					}
				}
				updateBoxOffsets(box);
			}

			if (lastCharacter != -1 && arrayCharacters.length > 0)
			{
				for (i in 0...arrayCharacters.length)
				{
					var char = arrayCharacters[i];
					if (char != null)
					{
						if (i != lastCharacter)
						{
							switch (char.jsonFile.dialogue_pos)
							{
								case 'left':
									char.x -= scrollSpeed * elapsed;
									if (char.x < char.startingPos + offsetPos)
										char.x = char.startingPos + offsetPos;
								case 'center':
									char.y += scrollSpeed * elapsed;
									if (char.y > char.startingPos + FlxG.height)
										char.y = char.startingPos + FlxG.height;
								case 'right':
									char.x += scrollSpeed * elapsed;
									if (char.x > char.startingPos - offsetPos)
										char.x = char.startingPos - offsetPos;
							}
							char.alpha -= 3 * elapsed;
							if (char.alpha < 0.00001)
								char.alpha = 0.00001;
						}
						else
						{
							switch (char.jsonFile.dialogue_pos)
							{
								case 'left':
									char.x += scrollSpeed * elapsed;
									if (char.x > char.startingPos)
										char.x = char.startingPos;
								case 'center':
									char.y -= scrollSpeed * elapsed;
									if (char.y < char.startingPos)
										char.y = char.startingPos;
								case 'right':
									char.x -= scrollSpeed * elapsed;
									if (char.x < char.startingPos)
										char.x = char.startingPos;
							}
							char.alpha += 3 * elapsed;
							if (char.alpha > 1)
								char.alpha = 1;
						}
					}
				}
			}
		}
		else
		{ // Dialogue ending
			if (box != null && box.animation.curAnim.curFrame <= 0)
			{
				box.kill();
				remove(box);
				box.destroy();
				box = null;
			}

			if (bgFade != null)
			{
				bgFade.alpha -= 0.5 * elapsed;
				if (bgFade.alpha <= 0)
				{
					bgFade.kill();
					remove(bgFade);
					bgFade.destroy();
					bgFade = null;
				}
			}

			for (i in 0...arrayCharacters.length)
			{
				var leChar:DialogueCharacter = arrayCharacters[i];
				if (leChar != null)
				{
					switch (arrayCharacters[i].jsonFile.dialogue_pos)
					{
						case 'left':
							leChar.x -= scrollSpeed * elapsed;
						case 'center':
							leChar.y += scrollSpeed * elapsed;
						case 'right':
							leChar.x += scrollSpeed * elapsed;
					}
					leChar.alpha -= elapsed * 10;
				}
			}

			if (box == null && bgFade == null)
			{
				for (i in 0...arrayCharacters.length)
				{
					var leChar:DialogueCharacter = arrayCharacters[0];
					if (leChar != null)
					{
						arrayCharacters.remove(leChar);
						leChar.kill();
						remove(leChar);
						leChar.destroy();
					}
				}
				finishThing();
				kill();
			}
		}

		#if debug
		if (FlxG.keys.justPressed.P)
		{
			finishThing();
			kill();
		}
		#end

		super.update(elapsed);
	}

	var lastCharacter:Int = -1;
	var lastBoxType:String = '';

	function startNextDialog():Void
	{
		var curDialogue:DialogueLine = null;
		do
		{
			curDialogue = dialogueList.dialogue[currentText];
		}
		while (curDialogue == null);

		if (curDialogue.text == null || curDialogue.text.length < 1)
			curDialogue.text = ' ';
		if (curDialogue.boxState == null)
			curDialogue.boxState = 'normal';
		if (curDialogue.speed == null || Math.isNaN(curDialogue.speed))
			curDialogue.speed = 0.05;

		var animName:String = curDialogue.boxState;
		var boxType:String = textBoxTypes[0];
		for (i in 0...textBoxTypes.length)
		{
			if (textBoxTypes[i] == animName)
			{
				boxType = animName;
			}
		}

		var character:Int = 0;
		box.visible = true;
		for (i in 0...arrayCharacters.length)
		{
			if (arrayCharacters[i].curCharacter == curDialogue.portrait)
			{
				character = i;
				break;
			}
		}
		var centerPrefix:String = '';
		var lePosition:String = arrayCharacters[character].jsonFile.dialogue_pos;
		if (lePosition == 'center')
			centerPrefix = 'center-';

		if (character != lastCharacter)
		{
			box.animation.play(centerPrefix + boxType + 'Open', true);
			updateBoxOffsets(box);
			box.flipX = (lePosition == 'left');
		}
		else if (boxType != lastBoxType)
		{
			box.animation.play(centerPrefix + boxType, true);
			updateBoxOffsets(box);
		}
		lastCharacter = character;
		lastBoxType = boxType;

		startFlxText(daText, curDialogue);
        startFlxText(daText_shadow, curDialogue);
		// daText.y = DEFAULT_TEXT_Y;

		var char:DialogueCharacter = arrayCharacters[character];
		if (char != null)
		{
			char.playAnim(curDialogue.expression, finishedText);
			if (char.animation.curAnim != null)
			{
				var rate:Float = 24 - (((curDialogue.speed - 0.05) / 5) * 480);
				if (rate < 12)
					rate = 12;
				else if (rate > 48)
					rate = 48;
				char.animation.curAnim.frameRate = rate;
			}
		}
		currentText++;

		if (nextDialogueThing != null)
		{
			nextDialogueThing();
		}
	}

	public static function parseDialogue(path:String):DialogueFile
	{
		#if MODS_ALLOWED
		if (FileSystem.exists(path))
		{
			return cast Json.parse(File.getContent(path));
		}
		#end
		return cast Json.parse(Assets.getText(path));
	}

	public static function updateBoxOffsets(box:FlxSprite)
	{ // Had to make it static because of the editors
		box.centerOffsets();
		box.updateHitbox();
		if (box.animation.curAnim.name.startsWith('angry'))
		{
			box.offset.set(50, 65);
		}
		else if (box.animation.curAnim.name.startsWith('center-angry'))
		{
			box.offset.set(50, 30);
		}
		else
		{
			box.offset.set(10, 0);
		}

		if (!box.flipX)
			box.offset.y += 10;
	}
	
    var fontName:String;
	var textSounds = FlxG.sound.load(Paths.sound('dialogueSound'));

	function initializeText(x:Float, y:Float, width:Int, size:Int, content:String):FlxTypeText
	{
		// trace('initialize text');
		var daText = new FlxTypeText(x, y, width, content, size);
		// trace('text content: ' + content);

		daText.autoErase = false;
		fontName = 'dialogueFont.ttf';
	    var font = Paths.font(fontName);
		daText.setFormat(font, size);
		daText.delay = 0.05;
		daText.showCursor = false;
		daText.skipKeys = null;
		daText.sounds = [textSounds];
		daText.color = FlxColor.BLACK;
		daText.alpha = 1;
		daText.prefix = "";

		return daText;
	}
	
	function initializeText_shadow(x:Float, y:Float, width:Int, size:Int, content:String):FlxTypeText
	{
		// trace('initialize text');
		var daText_shadow = new FlxTypeText(x, y, width, content, size);
		// trace('text content: ' + content);

		daText_shadow.autoErase = false;
		fontName = 'dialogueFont.ttf';
	    var font = Paths.font(fontName);
		daText_shadow.setFormat(font, size);
		daText_shadow.delay = 0.05;
		daText_shadow.showCursor = false;
		daText_shadow.skipKeys = null;
		daText_shadow.sounds = [textSounds];
		daText_shadow.color = FlxColor.BLACK;
		daText_shadow.alpha = 0.5;
		daText_shadow.prefix = "";

		return daText_shadow;
	}

	function resetText(daText:FlxTypeText, content:String)
	{
		// trace('reset text');
		daText.resetText(content);
		finishedText = false;
	}
	
	function resetText_shadow(daText_shadow:FlxTypeText, content:String)
	{
		// trace('reset text');
		daText_shadow.resetText(content);
		finishedText = false;
	}

	function startFlxText(daText:FlxTypeText, currentDialogue:DialogueLine)
	{
		if (daText == null)
		{
			// trace('text is null');
		}
		resetText(daText, currentDialogue.text);
		// daText = initializeText(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, 500, 8, currentDialogue.text);
		daText.start(.05, true, false, [], function()
		{
			finishedText = true;
			// trace('finish playing text: ' + currentDialogue.text);
		});
		// trace('start playing text: ' + currentDialogue.text);
	}
	
	function startFlxText_shadow(daText_shadow:FlxTypeText, currentDialogue:DialogueLine)
	{
		if (daText_shadow == null)
		{
			// trace('text is null');
		}
		resetText(daText_shadow, currentDialogue.text);
		// daText_shadow = initializeText(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, 500, 8, currentDialogue.text);
		daText_shadow.start(.05, true, false, [], function()
		{
			finishedText = true;
			// trace('finish playing text: ' + currentDialogue.text);
		});
		// trace('start playing text: ' + currentDialogue.text);
	}
}
