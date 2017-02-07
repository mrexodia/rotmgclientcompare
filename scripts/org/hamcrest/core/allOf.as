package org.hamcrest.core {
    import org.hamcrest.Matcher;
    
    public function allOf(... rest) : Matcher {
        var _local_2:Array = rest;
        if(rest.length == 1 && rest[0] is Array) {
            _local_2 = rest[0];
        }
        return new AllOfMatcher(_local_2);
    }
}
