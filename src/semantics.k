requires "syntax.k"
requires "utils.k"

module SEMANTICS
  imports SYNTAX
  imports UTILS
  imports INT
  imports BOOL
  imports STRING-COMMON

  configuration
  <T>
    <k> $PGM:Lines </k>
    <cmd> DONE </cmd>
    <line> .Commands </line>
    <ptr> 0 </ptr>
    <stack> .List </stack>
    <noop>0</noop>
    //<subroutines> .Map </subroutines>
    //<input> .List </input>
    //<output> .List </output>
  </T>

  rule <k> L:Line LS:Lines => L ~> LS ...</k> [priority(2)]

  // Reached end of line
  rule <line> CS:Commands => .Commands </line>  
       <ptr> P:Int => -1 </ptr> 
       requires P >=Int size(CS) [priority(2)]

  // Progress to next line
  rule <k> CS:Commands EOL => .K ...</k>    
       <line> .Commands => CS </line>
       <ptr> _:Int => 0 </ptr>
   [priority(2)]

  // No more lines, no more commands -> we're done
  rule <k> .Lines => .K</k>
       <line> .Commands </line>

  rule <line> CS:Commands </line>
       <ptr> P:Int </ptr> 
       <cmd> DONE => at(P, CS) </cmd>
       requires P <Int size(CS) andBool P >=Int 0


// Pushes 1 onto the stack
  rule <line> CS:Commands </line>
       <stack> L:List => ListItem(1) L </stack>
       <cmd> ONE => DONE </cmd>
       <ptr> P:Int => P +Int 1 </ptr> 


// Pushes 1 onto the stack
  //rule <line> ONE CS:Commands => ONE CS </line>
  //     <stack> L:List => ListItem(1) L </stack>
  //     <ptr> P:Int => P +Int 1 </ptr> 
  //     <cmd> ListItem(ONE) => ListItem(ONE) </cmd>

  //rule <cmd> .Command </cmd>
  //     <ptr> P:Int => P +Int 1 </ptr>


  //// Pops the top two values and pushes their sum
  //rule <line> + => .Command ...</line>
  //     <stack> ListItem(I1:Int) ListItem(I2:Int) L:List  => ListItem(I1 +Int I2) L </stack>
  //     <noop> C:Int </noop>
  //     requires C <=Int 0

  //// Pops the top two values and pushes their product
  //rule <line> * => .Command ...</line>
  //     <stack> ListItem(I1:Int) ListItem(I2:Int) L:List  => ListItem(I1 *Int I2) L </stack>
  //     <noop> C:Int </noop>
  //     requires C <=Int 0

  //// Duplicates the top value
  //rule <line> DUPLICATE => .Command ...</line>
  //     <stack> ListItem(I:Int) L:List => ListItem(I) ListItem(I) L </stack>
  //     <noop> C:Int </noop>
  //     requires C <=Int 0

  //// Sends the top value to the bottom
  //rule <line> / => .Command ...</line>
  //     <stack> ListItem(I:Int) L:List => L ListItem(I)  </stack>
  //     <noop> C:Int </noop>
  //     requires C <=Int 0

  //// Sends the bottom value to the top
  //rule <line> \ => .Command ...</line>
  //     <stack> L:List ListItem(I:Int) => ListItem(I) L </stack>
  //     <noop> C:Int </noop>
  //     requires C <=Int 0

  //// Swaps the top two values
  //rule <line> ^ => .Command ...</line>
  //     <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(I2) ListItem(I1) L </stack>
  //     <noop> C:Int </noop>
  //     requires C <=Int 0

  //// Pops the top two numbers and pushes 0 if the top number is less than the second-top number, 1 otherwise. 
  //rule <line> < => .Command ...</line>
  //     <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(0) L </stack>
  //     <noop> C:Int </noop>
  //     requires I1 <Int I2 andBool C <=Int 0
  //rule <line> < => .Command ...</line>
  //     <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(1) L </stack>
  //     <noop> C:Int </noop>
  //     requires I1 >=Int I2 andBool C <=Int 0

  //// No-op
  //rule <line> _:Command => .Command ...</line>
  //     <noop> I:Int </noop> 
  //      requires I >Int 0

  //// Decrease the noop counter
  //rule <line> # => .Command ...</line>
  //     <noop> I:Int => I -Int 1 </noop>
  //      requires I >Int 0

  //// Sets the noop counter
  //rule <line> # => .Command ...</line>
  //     <stack> ListItem(I) L:List  => ListItem(I) L:List </stack>
  //     <noop> C:Int => I +Int 1 </noop>
  //     requires C <=Int 0
endmodule
