package feathers.controls
{
    import feathers.controls.TextInput;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.system.Capabilities;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.text.TextFormat;
    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import feathers.events.FeathersEventType;

    public class FoveaTextInput extends TextInput
    {
        public override function set width(value:Number):void {
            if (width != value) {
                super.width = value;
                updateTextField();
            }
        }

        public override function set height(value:Number):void {
            if (height != value) {
                super.height = value;
                updateTextField();
            }
        }

        public override function set x(value:Number):void {
            if (x != value) {
                super.x = value;
                updateTextField();
            }
        }

        public override function set y(value:Number):void {
            if (y != value) {
                super.y = value;
                updateTextField();
            }
        }

        public override function set text(value:String):void {
            if (_text != value) {
                super.text = value;
                updateTextField();
            }
        }

        // flash.text.TextField
        private var _textField:TextField = null;

        public function FoveaTextInput()
        {
            addEventListener(starling.events.Event.ADDED_TO_STAGE, handleAdded);
        }

        private function handleAdded(event:starling.events.Event):void
        {
            removeEventListener(starling.events.Event.ADDED_TO_STAGE, handleAdded);
            addEventListener(starling.events.Event.REMOVED_FROM_STAGE, handleRemoved);

            var isAndroid:Boolean = Capabilities.manufacturer.indexOf('Android') > -1;
            if (isAndroid) {
            // if (true) {
                createTextField();
                Starling.current.nativeStage.addChild(_textField);
                isEditable = false;
                updateTextField();
            }
        }

        private function handleRemoved(event:starling.events.Event):void
        {
            removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, handleRemoved);
            addEventListener(starling.events.Event.ADDED_TO_STAGE, handleAdded);
            if (_textField) {
                Starling.current.nativeStage.removeChild(_textField);
                destroyTextField();
            }
        }

        private function createTextField():void
        {
            var tform:TextFormat = new TextFormat("_sans", 20, 0x000000);
            _textField = new TextField();
            _textField.type = TextFieldType.INPUT;
            _textField.defaultTextFormat = tform;
            _textField.needsSoftKeyboard = true;
            _textField.alpha = 0.00001;
            _textField.addEventListener(flash.events.Event.CHANGE, handleTextFieldInput);
            _textField.addEventListener(MouseEvent.CLICK, handleTextFieldClick);
            _textField.addEventListener(FocusEvent.FOCUS_IN, handleTextFieldFocusIn);
            _textField.addEventListener(FocusEvent.FOCUS_OUT, handleTextFieldFocusOut);
        }

        private function destroyTextField():void
        {
            _textField.removeEventListener(MouseEvent.CLICK, handleTextFieldClick);
            _textField.removeEventListener(flash.events.Event.CHANGE, handleTextFieldInput);
            _textField.removeEventListener(FocusEvent.FOCUS_IN, handleTextFieldFocusIn);
            _textField.removeEventListener(FocusEvent.FOCUS_OUT, handleTextFieldFocusOut);
            _textField = null;
        }

        public function handleTextFieldClick(event:MouseEvent):void
        {
            _textField.setSelection(_textField.text.length, _textField.text.length);
        }

        public function handleTextFieldInput(event:flash.events.Event):void
        {
            if (_textField.caretIndex !== _textField.text.length)
                _textField.text = text.substr(0, text.length - 1);
            _textField.setSelection(_textField.text.length, _textField.text.length);
            super.text = _textField.text + "_";
        }

        private var _savePrompt:String;
        public function handleTextFieldFocusIn(event:FocusEvent):void
        {
            _savePrompt = super.prompt;
            super.prompt = '';
            super.text = _textField.text + "_";
            super.currentState = TextInput.STATE_FOCUSED;
            _textField.setSelection(_textField.text.length, _textField.text.length);
            dispatchEvent(new starling.events.Event(FeathersEventType.FOCUS_IN));
        }

        public function handleTextFieldFocusOut(event:FocusEvent):void
        {
            super.prompt = _savePrompt;
            super.text = _textField.text;
            super.currentState = TextInput.STATE_ENABLED;
            dispatchEvent(new starling.events.Event(FeathersEventType.FOCUS_OUT));
        }

        private function updateTextField():void
        {
            if (_textField != null) {
                _textField.x = x;
                _textField.y = y;
                _textField.width  = width;
                _textField.height = height;
                _textField.text   = text;
            }
        }
    }
}
