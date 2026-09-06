Don't forget to read the readme for the favoriteAnims.xml line. It's necessary to add.

Place this line into FavoriteAnims.xml in your menyooStuff folder.

	<Anim dict="smo@female_model_217" name="f_model_217_clip" />
	<Anim dict="smo@female_model_218" name="f_model_218_clip" />
	<Anim dict="smo@female_model_219" name="f_model_219_clip" />
	<Anim dict="smo@female_selfie_149" name="f_selfie_149_clip" />
	<Anim dict="smo@female_selfie_150" name="f_selfie_150_clip" />
	<Anim dict="smo@female_selfie_151" name="f_selfie_151_clip" />


Install using Jennie's Custom Anims mod. Get it here:
https://www.gta5-mods.com/misc/custom-animations-add-on-customanims

Make sure you follow their guidelines on how to install that mod properly and how to install animations using it.



FOR DPEMOTES USERS ON FIVEM: 

NOTE: FOR PROP PLACEMENT, FOLLOW THIS TUTORIAL:
https://forum.cfx.re/t/how-to-menyoo-to-dpemotes-conversion-streaming-custom-add-on-props/4775018

Place the ycd file into this folder:

resources/dpemotes-master/streams

Then copy this line into your AnimationList.lua


["fselfie149] = {"smo@female_selfie_146", "f_selfie_146_clip", "Female Selfie Pose 146 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["fselfie150"] = {"smo@female_selfie_147", "f_selfie_147_clip", "Female Selfie Pose 147 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["fselfie151"] = {"smo@female_selfie_148", "f_selfie_148_clip", "Female Selfie Pose 148 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["fmodel217] = {"smo@female_model_214", "f_model_214_clip", "Female Model Pose 214 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["fmodel218"] = {"smo@female_model_215", "f_model_215_clip", "Female Model Pose 215 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},

["fmodel219"] = {"smo@female_model_216", "f_model_216_clip", "Female Model Pose 216 (Smos)", AnimationOptions =
{
	EmoteLoop = true,
	EmoteMoving = false,
}},