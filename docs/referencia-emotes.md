# Referencia heredada de rpemotes-reborn

> Esta es la documentacion tecnica del proyecto del que procede dwkemotes, conservada
> intacta porque sigue siendo valida para todo lo que no toca la interfaz: crear
> animaciones propias, props, efectos de particulas, emotes compartidos, el
> extractor de props y los creditos originales.
>
> Ojo con estas diferencias en dwkemotes:
>
> - Las secciones de personalizacion del menu (cabecera y titulo) ya no aplican:
>   el menu es NUI y su aspecto se ajusta desde el panel de ajustes del propio menu.
> - Los nombres de evento internos usan el prefijo `dwkemotes:` en lugar de `rpemotes:`.
> - Los exports siguen respondiendo tambien a `exports.rpemotes` y `exports['rpemotes-reborn']`.

# Increments

Pressing 'LEFT ALT' on the keyboard allows players to scroll through the menu one by one, or by 10.

Alternatively, players can use the `SHARE` button on an Xbox controller or `OPTIONS` button on a Playstation controller.

# Ragdoll 🥴

- To enable ragdoll, change `RagdollEnabled = false,` to true in config.lua.

- Much like the menu key, `RagdollKeybind` is also using RegisterKeyMapping. It is currently set to `U` by default _(server side)_ however can be set to the player's preferred keybind in the FiveM keybinds setting found in the settings menu within the Esc Menu.

- New setting: `RagdollAsToggle`, this will make either the ragdoll be a toggle or a hold key

# Finger Pointing & Hands Up 👆

Once enabled, players can press `B` on the keyboard to enable standalone finger pointing, and `Y` to put their hands up, without the need for unnecessary frameworks or "small resources".

Much like everything else in the menu, server owners can change these keybinds to their own preferences.

| COMMAND:  | ACTION:                |
| --------- | ---------------------- |
| B         | Toggle Finger Pointing |
| Y         | Toggle Hands Up        |
| /pointing | Toggle Finger Pointing |
| /handsup  | Toggle Hands Up        |

# Crouching & Crawling

**Crouching:**

RIGHT CONTROL. Players can move forward, back, left, and right as well as turn around. Press SPACEBAR to switch from stomach to back. Pressing the RIGHT CONTROL key while running will have the player "dive into" a crouching animation.

**Crawling:**

Server owners can opt in to either overriding the stealth/action animation when pressing the LEFT CONTROL keybind or have players tap LEFT CONTROL twice to switch from stealth to crouch (when enabled in the config.lua file)

# Chat Commands

| COMMAND:      | ACTION:                   |
| ------------- | ------------------------- |
| LEFT CONTROL  | Toggle Crouching On / Off |
| RIGHT CONTROL | Toggle Crawling On / Off  |
| /crouch       | Toggle Crouching On / Off |
| /crawl        | Toggle Crawling On / Off  |

---

# Moods & Walkstyles 😜🚶‍♂️

Moods and walk styles can be set from the menu. These will save to your character and reapply when exiting a vehicle, or loading back into the server as they are saved via client-side KVP.

| COMMAND:    | ACTION:                               |
| ----------- | ------------------------------------- |
| F4          | Opens RPEmotes menu                   |
| /walks      | See A List Of Walkstyles In Chat      |
| /moods      | See A List Of Walkstyles In Chat      |
| /reset mood | Remove preferred mood and set default |
| /reset walk | Remove last walkstyle and set default |

Having problems with users "abusing" certain walk styles? rpemotes-reborn checks if a user has an "abusable" walk style saved and clears it when a player joins. Alternatively, you can use a resource like [rpemotes-punishment](https://github.com/alberttheprince/rpemotes-punishment/) to trip players abusing these emotes.

Just want to remove them? Delete the following walk styles from Animationlist.lua:

Bigfoot, Hurry, Hurry2, Hurry3, Flee, Flee2, Flee3, Flee4, and Flee5

# No Idle Cam 📷

No Idle Cam allows players to disable the idle camera animation on foot and in vehicle, making RP scenarios, streaming on Twitch, or just general gameplay just a little more enjoyable.

| COMMAND:    | ACTION:                |
| ----------- | ---------------------- |
| /Idlecamon  | deactivates the native |
| /idlecamoff | enables the native     |

# Binoculars 👀

| COMMAND:    | ACTION:                                       |
| ----------- | --------------------------------------------- |
| /binoculars | starts the binoculars                         |
| L ALT       | Toggle between night, heat and normal visions |
| G           | Show or hide the instructions                 |
| BACKSPACE   | Exit the binoculars                           |


# News Camera

| COMMAND:  | ACTION:                       |
| --------- | ----------------------------- |
| /newscam  | starts the News Camera        |
| H         | Edit Text                     |
| L ALT     | Toggle between vision modes   |
| G         | Show or hide the instructions |
| BACKSPACE | Exit News Camera              |


# Exit Emotes

Exit Emotes are used to make cancelling an animation more smoother and dynamic, such as getting up off a chair or throwing a cigarette out instead of dropping it.

You can add your own Exit Emotes under `AnimationListCustom.lua`'s new `CustomDP.Exits = {}` array.

Below is an example of how this would look:

```lua
    },
    ["sit"] = {
        "anim@amb@business@bgen@bgen_no_work@",
        "sit_phone_phoneputdown_idle_nowork",
        "Sit",
        AnimationOptions = {
            onFootFlag = AnimFlag.LOOP,
            ExitEmote = "getup",
        }
    },
```

The ExitEmote calls for the 'getup' emote, which is noted as the following:

```lua
["getup"] = {
        "get_up@sat_on_floor@to_stand",
        "getup_0",
        "Get Up",
        AnimationOptions = {
            EmoteDuration = 2000
        }
    }
}
```

# Adult Emotes 🔞

Adult Emotes can be hidden from the menu by setting `AdultEmotesDisabled` to `true` in the config.lua file.

This will completely conceal the emotes from the lists _(Emotes, Shared Emotes, etc)_ at startup making them unusable.

The emotes that are concealed, are the ones flagged in the animation list with `AdultAnimation`. You can see how it is done with `fspose`.

Alternatively, you can also hide animal emotes.

# QB-Core ⚙️

**QBCore integration to match their fork of dpemotes**

- Config option that supports the QB Framework in their fork of the original dpemotes.

If you’re using qb-core, you can now set

```lua
Framework = "qb-core",
```

in the config file, otherwise, leave it as

```lua
Framework = false,
```

_You may need to alter some code within qb-core to work with RPEmotes._

# Prop Extractor ↔️

Many people have expressed concerns over anticheat scripts kicking or banning their community members due to the fact RPEmotes uses props and anticheats detecting said props being spawned.

To make server owners' jobs a little easier, we have added a prop extractor command that you can enter into the server console which will automate a file inside the RPEmotes resource folder appropriately named, `prop_list.lua`.

### Command:

`emoteextract`

```lua

Available output formats:
1 - 'prop_name',
2 - "prop_name",
3 - prop_name
4 - calculate total emotes

Command usage example: emoteextract 1
```

![image](https://github.com/user-attachments/assets/6ec6e042-00b7-4be2-8086-1805eb87196c)

# Installation Instructions ⚙️:

- Add `ensure rpemotes` to your `server.cfg`

- Download the latest recommended artifacts [for Windows](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/) or [for Linux](https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/)

- [Enforce gamebuild to latest build](https://forum.cfx.re/t/tutorial-forcing-gamebuild-to-casino-cayo-perico-or-tuners-update/4784977) for all emotes and props to work as intended.

**Onesync Infinity is required for the particle effects to work as intended** This can be done via txadmin or your localhost .bat file.\*\*

For localhost servers, comment out onesync from your server.cfg and add the following to your `.bat` file:

```lua

+set onesync on +set onesync_enableInfinity 1 +set onesync_enableBeyond 1 +set onesync_population true

```

You can put this before your gamebuild enforcement, aka `+set sv_enforceGameBuild XXXX`

- Set the desired language and settings in the config.lua under `MenuLanguage = 'en',`

- Qb-Core server owners, set `Framework = 'qb-core'` in the config file, otherwise leave it as false.

- If you do not want to use the Kvp features, you can use the keybind command that comes with FiveM, by entering the following into F8:

`bind keyboard "Yourbutton" "e youremote"`. To remove the keybind, type `"unbind keyboard "Yourbutton"`.

- Type `/refresh` and `/ensure rpemotes` into your chat resource, or simply restart your server

# Shared emotes 👩🏻‍❤️‍💋‍👨🏼

Emotes will work with either `SyncOffset` or `Attachto`.

If it is with `SyncOffsetFront` or `SyncOffsetSide`, then the offset used is the one of the emote the player started.<br/>

For example, if player one starts the emote `handshake` which has `SyncOffsetFront`, then player one will have the `SyncOffsetFront` but not the other player.

- If it is with `Attachto`, then it'll either be player one's data used for attaching or player two's data.<br/>
  For example, if player one starts the emote carry, then the other player will be attached but not the player one because Attachto is set in `carry2` and not `carry`.<br/>
- If player one starts the emote `carry2`, then player one will be attached and not the other player.
  it's the player who starts the animation who will in most cases be moved

_Special case, if both emote have the `Attachto` then only the player who started the emote will be attached._

You can find a list of ped bones to attach the other player here: [Ped Bones](https://wiki.rage.mp/index.php?title=Bones) or alternatively, if the link is down for some reason, you can check [here](https://wiki.rage.mp/index.php?title=Bones)

Using the websites provided above, enter the bone ID, ie `1356` and not `111`, which is the Bone Index.

Understandably, this can be confusing for some people. We suggest using the `Attachto` approach.

# Particle Effects 💨

**REQUIRES ONESYNC INFINITY**

Particle effects can be found using the [DurtyFree GTA V Dump](https://github.com/DurtyFree/gta-v-data-dumps/blob/master/particleEffectsCompact.json). You will need to add the particle asset, name, and placement. Placement is done via XYZ, Pitch, Roll, Yaw, and scale.

Onesync is required for them to work across all clients.

```lua
PtfxPlacement = {
    -0.15, -- X
    -0.35, -- Y
     0.0, -- Z
     0.0, -- ROTATION X
     90.0, -- ROTATION Y
     180.0, -- ROTATION Z
       1.0 -- SCALE
},
```

<img src="screenshots/pfxcoords.png" width="350">

By default, the main prop will share its coordinates with the particle effect, so just put 0.0 for the particle effects and you will be good to go.

If no prop is used in the animation or you require the particle effect to be in a different location, use `PtfxNoProp = true`, and 0.0 will 9/10 times be the human peds' stomach; you can then offset your coordinates based on that with the first 3 entries being XYZ, and the last 3 being rotation XYZ.

Alternatively, you can use the `PtfxBone =` AnimationOption to attach the PTFX to the ped's bone, similarly to how you attach props.

Using Menyoo, spawn down a tennis ball and attach it to a human, by default menyoo will attach it to the SKEL_ROOT bone (stomach), so from that, what we can do is either offset the coordinates, say, up to the human ped's mouth, or change the bone altogether. Once we've got it correct, we can transfer those coordinates over to RPEmotes, and tah dah, we have our Ptfx Placement.

Note that `ptfxwait = ` is in ms, so if you'd like a particle to last for 30 seconds, it should be `ptfxwait = 30000`.

# Adding Your Own Animations ⚙️

Because the menu gets updated frequently, the files get overwritten. To avoid this, you can add your own / downloaded animation files `(.ycd)` inside of a newly created folder, give it a name, and place it in the `rpemotes\stream\[Custom Emotes]` folder.

Add your animation code to the `AnimationListCustom.lua` and make a backup of this file and call it `BackUpAnimationListCustom.lua`.

**Note on vehicle emotes:** If you want your emote to play in a vehicle with the full body, you must add the FullBody tag to the emote options.

**Note on animal emotes:** For the addition of custom emotes for animal peds, you must add use the `sdog` or `bdog` tags. For example if you want to add an emote of `laydownflat` it must be either `sdoglaydownflat` or `bdoglaydownflat`. You must also add any custom addon peds to the `animals.lua` file in either category for these animations to be played on those models.

Whenever an update is released, rename `BackUpAnimationListCustom.lua` to `AnimationListCustom.lua`, click yes to overwrite, and you're good to go.

Note that `AnimationListCustom.lua` and `BackUpAnimationListCustom.lua` files from versions prior to version 1.5.0 are not compatible with version 1.5.0, and files from version 1.5.0 are not backwards compatible with versions prior to version 1.5.0. To retain any custom animation code from previous versions, copy over any customizations into the `AnimationListCustom.lua` file that is included in the current version.

It is also a good idea to keep a backup of your config file.
Below is an example:

<img src="screenshots/customanims.png" width="550">

# Credits 🤝

**All** custom animations and props were added with permission from the creators.

All animation creators have **_specifically_** asked that their content remain free and that the RPEmotes team and community do not try to profit from them, claim them as their own, or reupload them anywhere else.

**A huge thank you the following people for their amazing contributions to the menu:**

- the FiveM community for using RP and updating rpemotes-reborn!
### Developers:
- [The Popcorn RP community](https://discord.gg/popcornroleplay) for putting up with all my emote menu testing and troubleshooting issues with me
- [Mathu_lmn](https://github.com/Mathu-lmn) for maintaining the menu and adding features
- [Manason](https://github.com/Manason) for major overhauls, refactors, and improvements of rpemotes-reborn during push to 2.0
- [CritteRo](CritteRo) for work on shared emotes placement and other refactors and fixes of rpemotes-reborn during push to 2.0
- [ChristopherM](https://github.com/cm8263) for creation of the emote placement feature and fixes of rpemotes-reborn during push to 2.0
- [enzo2991](https://github.com/enzo2991) for creating the ped preview functionality, keybind with kvp
- [DerDevHD](https://forum.cfx.re/t/fixed-remove-prop-after-scenario-animation/5002332/8) for the insight on deleting scenario props.
- [iSentrie](https://forum.cfx.re/u/isentrie/) for additional code, support, and joining the RPEmotes project
- [Kibook](https://github.com/kibook) for the addition of the Animal Emotes sub-menu
- [AvaN0x](https://github.com/AvaN0x) for reformatting and assisting with code, additional features, and figuring out shared particle effects
- [Mads](https://github.com/MadsLeander) for joining the team as Co-Developer
- [Tigerle](https://forum.cfx.re/u/tigerle_studios) for providing the additional code required to make Shared Emotes work to its full extent
- [GeekGarage](https://github.com/geekgarage) for their knowledge, time, and dedication, helping to bring new and exciting features to the menu
- [northsqrd](https://github.com/0sqrd) for adding the search function, Animal Emotes config, mobile phone prop texture variants, and general contributions
- [Chico](https://forum.cfx.re/u/chico) for implementing natives to reapply persistent moods and walk styles for ESX and QB-Core frameworks
- [Scully](https://github.com/Scullyy/) for their past work on rpemotes
- Crusopaul and Eki for discussing KVP and initializing it to the menu for persistent walk styles

### Emote & Props Creators:
- [FalseHopeDesigns](https://falsehopedesigns.tebex.io/) for creation of collisionless props
- [SMGMissy](https://jenscreations.tebex.io/) for creating the pride flag props
- [MissSnowie](https://www.gta5-mods.com/users/MissySnowie)
- [Smokey](https://www.gta5-mods.com/users/struggleville)
- [BzZzi](https://forum.cfx.re/u/bzzzi/summary)
- [Natty3d](https://forum.cfx.re/u/natty3d/summary)
- [Amnilka](https://www.gta5-mods.com/users/frabi)
- [LittleSpoon](https://discord.gg/safeword)
- [LadyyShamrockk](https://www.gta5-mods.com/users/LadyyShamrockk)
- [Pupppy](https://discord.gg/rsN35X4s4N)
- [SapphireMods](https://discord.gg/Hf8F4nTyzt)
- [QueenSisters Animations](https://discord.gg/qbPtGwQuep)
- DurtyFree for his work on particle effects and cataloging GTA-related information [DurtyFree GTA V Dump](https://github.com/DurtyFree/gta-v-data-dumps/blob/master/particleEffectsCompact.json)
- [BoringNeptune](https://www.gta5-mods.com/users/BoringNeptune)
- [CMG Mods](https://www.gta5-mods.com/users/-moses-)
- [prue 颜](discord.gg/lunyxmods)
- [PataMods](https://forum.cfx.re/u/Pata_PataMods)
- [Crowded1337](https://www.gta5-mods.com/users/crowded1337)
- [EnchantedBrownie](https://www.gta5-mods.com/users/EnchantedBrownie)
- Chocoholic Animations
- [CrunchyCat](https://www.gta5-mods.com/users/crunchycat)
- [KayKayMods](https://discord.gg/5bYQVWVaxG)
- [MonkeyWhisper](https://github.com/MonkeyWhisper) and [Project Sloth](https://github.com/Project-Sloth)
- [Brummieee](https://forum.cfx.re/u/brummieee_maps/summary)
- [Dark Animations](https://www.gta5-mods.com/users/Darks%20Animations).
- [-EcLiPsE-](https://www.gta5-mods.com/users/-EcLiPsE-) for allowing me to implement [Improved Prop Sets](https://www.gta5-mods.com/misc/improved-propsets-meta) and [GTA Online Biker Idle Anims](https://www.gta5-mods.com/misc/bike-idle-animations)
- [MrWitt](https://www.gta5-mods.com/users/MrWitt)
- [Vedere](https://discord.gg/XMywAMQ8Ef)
- [DRX Animations](https://www.gta5-mods.com/users/DRX%2DAnimations)
- [VNSIanims](https://discord.gg/cTNrjYSXXG)
- [PNWParksFan](https://www.gta5-mods.com/users/PNWParksFan)
- [LSPDFR member Sam](https://www.lcpdfr.com/downloads/gta5mods/misc/23386-lspd-police-badge/)
- [GTA5Mods user Sladus_Slawonkus](https://www.gta5-mods.com/misc/lspd-police-badge-replace-sladus_slawonkus)
- [EP](https://github.com/EpKouhia)
- [TayMcKenzieNZ](https://github.com/TayMcKenzieNZ)
- [41anims](https://www.gta5-mods.com/users/41anims)
- [corbs](https://www.gta5-mods.com/users/corbs)
- [jaysigx](https://www.gta5-mods.com/misc/improved-umbrella)
- [Payzee](https://pazeee.tebex.io/)
