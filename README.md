Feathers-FoveaTextInput
=======================

Feathers TextInput replacement to get rid of StageText Crashes on Android

Documentation
-------------

Import FoveaTextInput:

    import feathers.controls.FoveaTextInput;

Use it as a any TextInput:

    var input:FoveaTextInput = new FoveaTextInput();
    addChild(input);
    input.prompt = "Enter your name";
    input.x = 100;
    input.y = 100;
    input.width  = 300;
    input.height = 60;

Behaviour
---------

FoveaTextInput will be a regular feathers TextInput on all platform except Android.

On Android, an invisible flash.text.TextField is added over the TextInput to prevent the StageText crash that occurs on some devices. It provides less features, but more stability.

Known Issue
-----------

On Android, if some feathers elements are drawn over the FoveaTextInput, the invisible flash.text.TextInput will still be there (not visible, but still active). You may have to remove the text input from the stage to prevent weird behaviours.
