-module(erlyorm_migration).
-export([
         parse_transform/2
        ]).


parse_transform(Forms, _Options) ->
    {ok, Forms1} = epp:parse_file("erlyorm_base.erl", []),
    compile(Forms, Forms1).

compile(AST1, AST2) ->
    fix_exports(AST1 ++ AST2, {undefined, [], []}, false).

fix_exports([], {Name, Exports, Ack}, _) ->
    %% Let's assemble
    [{attribute, 1, module, Name}|[{attribute, 2, export, Exports}|lists:reverse(Ack)]];
fix_exports([{attribute, _LineNo, module, Name}|Tl], {ModName, Exports, Ack}, SecondRun) ->
    case SecondRun of
        false ->
            %% We can skip this since it's the first occurence of module-attribute
            fix_exports(Tl, {Name, Exports, Ack}, false);
        _ ->
            fix_exports(Tl, {ModName, Exports, Ack}, SecondRun)
    end;
fix_exports([{attribute, _LineNo, export, Exports}|Tl], {Name, _, Ack}, false) ->
    %% We are at the right place - just extract the exports
    fix_exports(Tl, {Name, Exports, Ack}, true);
fix_exports([{attribute, _LineNo, export, Exports}|Tl], {Name, ExportsAck, Ack}, true) ->
    fix_exports(Tl, {Name, Exports++ExportsAck, Ack}, true);
fix_exports([Hd|Tl], {Name, Exports, Ack}, SecondRun) ->
    fix_exports(Tl, {Name, Exports, [Hd|Ack]}, SecondRun).
