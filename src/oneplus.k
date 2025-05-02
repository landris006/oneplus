module ONEPLUS-SYNTAX
  imports INT-SYNTAX
  imports STRING-SYNTAX
  imports LIST

  syntax Command ::=  "ONE"  [token]
                    | "+"  [token]
                    | "*"  [token]
                    | "DUPLICATE" [token]
                    | "/"  [token]
                    | "\\" [token]
                    | "^"  [token]
                    | "<"  [token]
                    | "." [token]
                    | "," [token]
                    | ":" [token]
                    | ";" [token]
                    | "#"  [token]

  syntax Commands ::= List{Command,""}

  syntax Comment ::= "[" String "]"
endmodule

module ONEPLUS
  imports ONEPLUS-SYNTAX
  imports INT
  imports BOOL

  configuration <k> $PGM:Commands </k>
                <stack> .List </stack>
                <noop>0</noop>
                //<subroutines> .Map </subroutines>
                //<input> .List </input>
                //<output> .List </output>

  rule <k> C:Command CS:Commands => C ~> CS ...</k>
  rule <k> .Commands => .K ...</k> 

  // Pushes 1 onto the stack
  rule <k> ONE => .K ...</k>
       <stack> L:List => ListItem(1) L </stack>
       <noop> C:Int </noop>
       requires C <=Int 0


  // Pops the top two values and pushes their sum
  rule <k> + => .K ...</k>
       <stack> ListItem(I1:Int) ListItem(I2:Int) L:List  => ListItem(I1 +Int I2) L </stack>
       <noop> C:Int </noop>
       requires C <=Int 0

  // Pops the top two values and pushes their product
  rule <k> * => .K ...</k>
       <stack> ListItem(I1:Int) ListItem(I2:Int) L:List  => ListItem(I1 *Int I2) L </stack>
       <noop> C:Int </noop>
       requires C <=Int 0

  // Duplicates the top value
  rule <k> DUPLICATE => .K ...</k>
       <stack> ListItem(I:Int) L:List => ListItem(I) ListItem(I) L </stack>
       <noop> C:Int </noop>
       requires C <=Int 0

  // Sends the top value to the bottom
  rule <k> / => .K ...</k>
       <stack> ListItem(I:Int) L:List => L ListItem(I)  </stack>
       <noop> C:Int </noop>
       requires C <=Int 0

  // Sends the bottom value to the top
  rule <k> \ => .K ...</k>
       <stack> L:List ListItem(I:Int) => ListItem(I) L </stack>
       <noop> C:Int </noop>
       requires C <=Int 0

  // Swaps the top two values
  rule <k> ^ => .K ...</k>
       <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(I2) ListItem(I1) L </stack>
       <noop> C:Int </noop>
       requires C <=Int 0

  // Pops the top two numbers and pushes 0 if the top number is less than the second-top number, 1 otherwise. 
  rule <k> < => .K ...</k>
       <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(0) L </stack>
       <noop> C:Int </noop>
       requires I1 <Int I2 andBool C <=Int 0
  rule <k> < => .K ...</k>
       <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(1) L </stack>
       <noop> C:Int </noop>
       requires I1 >=Int I2 andBool C <=Int 0

  // No-op
  rule <k> _:Command => .K ...</k>
       <noop> I:Int </noop> 
        requires I >Int 0

  // Decrease the noop counter
  rule <k> # => .K ...</k>
       <noop> I:Int => I -Int 1 </noop>
        requires I >Int 0

  // Sets the noop counter
  rule <k> # => .K ...</k>
       <stack> ListItem(I) L:List  => ListItem(I) L:List </stack>
       <noop> C:Int => I +Int 1 </noop>
       requires C <=Int 0
endmodule
