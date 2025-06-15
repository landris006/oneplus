requires "domains.md"
requires "../src/syntax.k"
requires "../src/semantics.k"
requires "../src/utils.k"

module SPEC-SYNTAX
imports SYNTAX
endmodule

module VERIFICATION
    imports K-EQUAL
    imports SYNTAX
    imports SEMANTICS
    imports MAP-SYMBOLIC
    imports UTILS

endmodule

module SPEC
imports VERIFICATION
imports UTILS
  claim
    <k> .K </k>
    <cmd> Some(ONE) => None </cmd>
    <stack> L:List => ListItem(1) L </stack>
    <scopes>
      <scope>
        ...
        <noop> N:Int </noop>
        ...
      </scope>
    </scopes>
    requires N ==Int 0

  claim
    <k> ONE .Commands EOL .Lines ~> .K => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>

    <stack> .List => ListItem(1) ... </stack>
endmodule
