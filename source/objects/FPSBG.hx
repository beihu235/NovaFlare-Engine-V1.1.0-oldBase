package objects;

import flixel.util.FlxGradient;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxSprite;
import openfl.utils.Assets;
import flixel.FlxObject;
import openfl.display.Sprite;
import openfl.Assets;

class FPSBG extends FlxSprite {
	

    public function addImage(sprite:Sprite) {
        sprite.addChild(Paths.image('mainmenu_sprite/loadingR'));
    }


	override function update(elapsed:Float) {
		//if (sprTracker != null)
		//	setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}
/*
import MyOtherClass;

class Main {
    static function main() {
        var sprite:Sprite = new Sprite();
        var myOtherClass = new MyOtherClass();
        myOtherClass.addImage(sprite);
        addChild(sprite);
    }
}


import openfl.display.Sprite;
import openfl.Assets;

class MyOtherClass {
    public function addImage(sprite:Sprite) {
        sprite.addChild(Assets.getBitmapData("assets/image.png"));
    }
}
*/