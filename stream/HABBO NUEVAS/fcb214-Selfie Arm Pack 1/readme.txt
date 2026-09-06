Don't forget to read the readme for the favoriteAnims.xml line. It's necessary to add.

Place this line into FavoriteAnims.xml in your menyooStuff folder.

	<Anim dict="smo@selfie_arm_01" name="selfie_arm_01_clip" />
	<Anim dict="smo@selfie_arm_02" name="selfie_arm_02_clip" />
	<Anim dict="smo@selfie_arm_03" name="selfie_arm_03_clip" />
	<Anim dict="smo@selfie_arm_04" name="selfie_arm_04_clip" />
	<Anim dict="smo@selfie_arm_05" name="selfie_arm_05_clip" />
	<Anim dict="smo@selfie_arm_06" name="selfie_arm_06_clip" />



Install using Jennie's Custom Anims mod. Get it here:
https://www.gta5-mods.com/misc/custom-animations-add-on-customanims

Make sure you follow their guidelines on how to install that mod properly and how to install animations using it.



FOR DPEMOTES USERS ON FIVEM: 

NOTE: FOR PROP PLACEMENT, FOLLOW THIS TUTORIAL:
https://forum.cfx.re/t/how-to-menyoo-to-dpemotes-conversion-streaming-custom-add-on-props/4775018

Place the ycd file into this folder:

resources/dpemotes-master/streams

Then copy this line into your AnimationList.lua


["selfie1"] = {"smo@selfie_arm_01", "selfie_arm_01_clip", "Selfie Arm 1 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["selfie2"] = {"smo@selfie_arm_02", "selfie_arm_02_clip", "Selfie Arm 2 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["selfie3"] = {"smo@selfie_arm_03", "selfie_arm_03_clip", "Selfie Arm 3 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["selfie4"] = {"smo@selfie_arm_04", "selfie_arm_04_clip", "Selfie Arm 4 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["selfie5"] = {"smo@selfie_arm_05", "selfie_arm_05_clip", "Selfie Arm 5 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},


["selfie6"] = {"smo@selfie_arm_06", "selfie_arm_06_clip", "Selfie Arm 6 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

