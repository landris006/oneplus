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
    <k> ONE EOL => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>

    <stack> .List => ListItem(1) </stack>

  claim
    <k> ONE EOL => .K ... </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>

    <stack> .List => ListItem(1) </stack> [one-path]

  claim
    <k> ONE ONE + EOL => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>
    <stack> .List => ListItem(2) </stack>

  claim
    <k> ONE + EOL => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>
    <stack> ListItem(1) => ListItem(2) </stack>

  claim
    <k> ONE + EOL => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>
    <stack> ListItem(N:Int) => ListItem(N +Int 1) </stack>

  claim
    <k> + EOL => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>
    <stack> ListItem(N:Int) ListItem(N:Int) => ListItem(N *Int 2) </stack>

  claim
    <k> < EOL => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>
    <stack> ListItem(_:Int) ListItem(_:Int) => ListItem(?R) </stack>
    ensures (?R ==Int 0) orBool (?R ==Int 1)

  claim
    <k> < EOL => .K </k>
    <cmd> None </cmd>
    <scopes> .Bag </scopes>
    <stack> ListItem(_A:Int) ListItem(_B:Int) => ListItem(?R) </stack>
    ensures (?A <Int ?B impliesBool ?R ==Int 0) andBool (?A >=Int ?B impliesBool ?R ==Int 1)
endmodule
