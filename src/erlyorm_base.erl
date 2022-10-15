-module(erlyorm_base).
-export([
         create/3,
         add/2,
         timestamps/0
        ]).

create(table, Ident, Fields) ->
    {table, Ident, Fields};
create(unique_index, Ident, Field) ->
    {unique_index, Ident, Field}.

add(Fieldname, Type) when is_atom(Type) ->
    {field, Fieldname, Type};
add(Fieldname, Args) ->
    {field, Fieldname, Args}.


timestamps() ->
    [add(updated_at, timestamp),
     add(inserted_at, timestamp)].
