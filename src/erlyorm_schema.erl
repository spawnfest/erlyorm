-module(erlyorm_schema).


-type field () :: {field, Ident :: atom(), Type :: atom()}.

-callback schema(Identifier :: string() | binary()) -> [Field :: field()].
