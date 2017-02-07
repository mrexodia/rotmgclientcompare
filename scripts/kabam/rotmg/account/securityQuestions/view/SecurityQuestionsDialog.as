package kabam.rotmg.account.securityQuestions.view {
    import com.company.assembleegameclient.account.ui.Frame;
    import com.company.assembleegameclient.account.ui.TextInputField;
    import kabam.rotmg.text.model.TextKey;
    import kabam.rotmg.text.view.stringBuilder.LineBuilder;
    
    public class SecurityQuestionsDialog extends Frame {
         
        
        private var errors:Array;
        
        private const minQuestionLength:int = 3;
        
        private const maxQuestionLength:int = 50;
        
        private const inputPattern:RegExp = /^[a-zA-Z0-9 ]+$/;
        
        private var fields:Array;
        
        private var questionsList:Array;
        
        public function SecurityQuestionsDialog(param1:Array, param2:Array) {
            this.errors = [];
            this.questionsList = param1;
            super(TextKey.SECURITY_QUESTIONS_DIALOG_TITLE,"",TextKey.SECURITY_QUESTIONS_DIALOG_SAVE);
            this.createAssets();
            if(param1.length == param2.length) {
                this.updateAnswers(param2);
            }
        }
        
        public function updateAnswers(param1:Array) : * {
            var _local_3:TextInputField = null;
            var _local_2:int = 1;
            for each(_local_3 in this.fields) {
                _local_3.inputText_.text = param1[_local_2 - 1];
                _local_2++;
            }
        }
        
        private function createAssets() : void {
            var _local_2:String = null;
            var _local_3:TextInputField = null;
            var _local_1:int = 1;
            this.fields = [];
            for each(_local_2 in this.questionsList) {
                _local_3 = new TextInputField(_local_2,false,240);
                addTextInputField(_local_3);
                _local_3.inputText_.tabEnabled = true;
                _local_3.inputText_.tabIndex = _local_1;
                _local_3.inputText_.maxChars = this.maxQuestionLength;
                _local_1++;
                this.fields.push(_local_3);
            }
            rightButton_.tabIndex = _local_1 + 1;
            rightButton_.tabEnabled = true;
        }
        
        public function clearErrors() : void {
            var _local_1:TextInputField = null;
            titleText_.setStringBuilder(new LineBuilder().setParams(TextKey.SECURITY_QUESTIONS_DIALOG_TITLE));
            titleText_.setColor(11776947);
            this.errors = [];
            for each(_local_1 in this.fields) {
                _local_1.setErrorHighlight(false);
            }
        }
        
        public function areQuestionsValid() : Boolean {
            var _local_1:TextInputField = null;
            for each(_local_1 in this.fields) {
                if(_local_1.inputText_.length < this.minQuestionLength) {
                    this.errors.push(TextKey.SECURITY_QUESTIONS_TOO_SHORT);
                    _local_1.setErrorHighlight(true);
                    return false;
                }
                if(_local_1.inputText_.length > this.maxQuestionLength) {
                    this.errors.push(TextKey.SECURITY_QUESTIONS_TOO_LONG);
                    _local_1.setErrorHighlight(true);
                    return false;
                }
            }
            return true;
        }
        
        public function displayErrorText() : void {
            var _local_1:String = this.errors.length == 1?this.errors[0]:TextKey.MULTIPLE_ERRORS_MESSAGE;
            this.setError(_local_1);
        }
        
        public function dispose() : void {
            this.errors = null;
            this.fields = null;
            this.questionsList = null;
        }
        
        public function getAnswers() : Array {
            var _local_2:TextInputField = null;
            var _local_1:Array = [];
            for each(_local_2 in this.fields) {
                _local_1.push(_local_2.inputText_.text);
            }
            return _local_1;
        }
        
        override public function disable() : void {
            super.disable();
            titleText_.setStringBuilder(new LineBuilder().setParams(TextKey.SECURITY_QUESTIONS_SAVING_IN_PROGRESS));
        }
        
        public function setError(param1:String) : * {
            titleText_.setStringBuilder(new LineBuilder().setParams(param1,{"min":this.minQuestionLength}));
            titleText_.setColor(16549442);
        }
    }
}
