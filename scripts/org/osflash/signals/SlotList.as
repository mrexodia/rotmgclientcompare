package org.osflash.signals {
    public final class SlotList {
        
        public static const NIL:SlotList = new SlotList(null,null);
         
        
        public var head:ISlot;
        
        public var tail:SlotList;
        
        public var nonEmpty:Boolean = false;
        
        public function SlotList(param1:ISlot, param2:SlotList = null) {
            super();
            if(!param1 && !param2) {
                if(NIL) {
                    throw new ArgumentError("Parameters head and tail are null. Use the NIL element instead.");
                }
                this.nonEmpty = false;
            } else {
                if(!param1) {
                    throw new ArgumentError("Parameter head cannot be null.");
                }
                this.head = param1;
                this.tail = param2 || NIL;
                this.nonEmpty = true;
            }
        }
        
        public function get length() : uint {
            if(!this.nonEmpty) {
                return 0;
            }
            if(this.tail == NIL) {
                return 1;
            }
            var _local_1:uint = 0;
            var _local_2:SlotList = this;
            while(_local_2.nonEmpty) {
                _local_1++;
                _local_2 = _local_2.tail;
            }
            return _local_1;
        }
        
        public function prepend(param1:ISlot) : SlotList {
            return new SlotList(param1,this);
        }
        
        public function append(param1:ISlot) : SlotList {
            if(!param1) {
                return this;
            }
            if(!this.nonEmpty) {
                return new SlotList(param1);
            }
            if(this.tail == NIL) {
                return new SlotList(param1).prepend(this.head);
            }
            var _local_2:SlotList = new SlotList(this.head);
            var _local_3:SlotList = _local_2;
            var _local_4:SlotList = this.tail;
            while(_local_4.nonEmpty) {
                _local_3 = _local_3.tail = new SlotList(_local_4.head);
                _local_4 = _local_4.tail;
            }
            _local_3.tail = new SlotList(param1);
            return _local_2;
        }
        
        public function insertWithPriority(param1:ISlot) : SlotList {
            if(!this.nonEmpty) {
                return new SlotList(param1);
            }
            var _local_2:int = param1.priority;
            if(_local_2 > this.head.priority) {
                return this.prepend(param1);
            }
            var _local_3:SlotList = new SlotList(this.head);
            var _local_4:SlotList = _local_3;
            var _local_5:SlotList = this.tail;
            while(_local_5.nonEmpty) {
                if(_local_2 > _local_5.head.priority) {
                    _local_4.tail = _local_5.prepend(param1);
                    return _local_3;
                }
                _local_4 = _local_4.tail = new SlotList(_local_5.head);
                _local_5 = _local_5.tail;
            }
            _local_4.tail = new SlotList(param1);
            return _local_3;
        }
        
        public function filterNot(param1:Function) : SlotList {
            if(!this.nonEmpty || param1 == null) {
                return this;
            }
            if(param1 == this.head.listener) {
                return this.tail;
            }
            var _local_2:SlotList = new SlotList(this.head);
            var _local_3:SlotList = _local_2;
            var _local_4:SlotList = this.tail;
            while(_local_4.nonEmpty) {
                if(_local_4.head.listener == param1) {
                    _local_3.tail = _local_4.tail;
                    return _local_2;
                }
                _local_3 = _local_3.tail = new SlotList(_local_4.head);
                _local_4 = _local_4.tail;
            }
            return this;
        }
        
        public function contains(param1:Function) : Boolean {
            if(!this.nonEmpty) {
                return false;
            }
            var _local_2:SlotList = this;
            while(_local_2.nonEmpty) {
                if(_local_2.head.listener == param1) {
                    return true;
                }
                _local_2 = _local_2.tail;
            }
            return false;
        }
        
        public function find(param1:Function) : ISlot {
            if(!this.nonEmpty) {
                return null;
            }
            var _local_2:SlotList = this;
            while(_local_2.nonEmpty) {
                if(_local_2.head.listener == param1) {
                    return _local_2.head;
                }
                _local_2 = _local_2.tail;
            }
            return null;
        }
        
        public function toString() : String {
            var _local_1:* = "";
            var _local_2:SlotList = this;
            while(_local_2.nonEmpty) {
                _local_1 = _local_1 + (_local_2.head + " -> ");
                _local_2 = _local_2.tail;
            }
            _local_1 = _local_1 + "NIL";
            return "[List " + _local_1 + "]";
        }
    }
}
