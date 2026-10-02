Custom software for a Maccro Keyboard with 12 buttons and 3 Knobs bought on Amazon.

Known bugs:
- Media "Mute", "Play/Pause" are not working. I need the original software to be able to compare the commands..

This is a first release, so there may be bugs that im not aware of. If you want to help, please submit a pull request.
Download link: https://github.com/erdesigns-eu/HID-Macro-Keyboard/blob/main/MacroKeyboard.rar

The software should be self explainatory, you can click a button/knob to select it and use the menu to clear or assign a macro, or you can use the context menu (right click). You can enable/disable some things in the settings, for now there is no installer because this is jus the first BETA release. After the first bugs will be fixed i will create a installer and maybe add some more functions, documentation, etc.

## Custom keyboard layouts

The visual keyboard can load validated JSON layout files through **View > Load Layout**. Included examples cover 12-key/3-encoder, 9-key/3-encoder, and 6-key/1-encoder arrangements. See [the layout schema and authoring guide](docs/layout-schema.md) for the file format and instructions.

A layout defines drawing and interaction only. Programming a different keyboard also requires a verified USB identity and HID protocol definition; the application deliberately disables programming for layouts that do not match the currently supported CH552 mapping.

![Assign a macro to a key](Resources/screen1.png)
![Context menu](Resources/screen2.png)
![Settings](Resources/Screen3.png)
