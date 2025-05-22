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
    <cmd> None </cmd> // The current command to evaluate
    <line> .Commands </line>
    <ptr> 0 </ptr> // Pointer to the command we should load into <cmd>
    <stack> .List </stack>
    <noop>0</noop>
    //<subroutines> .Map </subroutines>
    //<input> .List </input>
    <output> .List </output>
  </T>

  rule <k> L:Line LS:Lines => L ~> LS ...</k>

  // Progress to next line
  rule <k> CS:Commands EOL => .K ...</k>    
       <line> .Commands => CS </line>
       <ptr> _:Int => 0 </ptr>

  // Reached end of line
  rule <line> CS:Commands => .Commands </line>  
       <ptr> P:Int => -1 </ptr> 
       requires P >=Int size(CS)

  // If <cmd> is empty, increment <ptr> and load the next command
  rule <line> CS:Commands </line>
       <ptr> P:Int => P +Int 1 </ptr>
       <cmd> None => Some(at(P, CS)) </cmd>
       requires P >=Int 0

  // --- CMD EVALUATIONS ---

  // Pushes 1 onto the stack
  rule <cmd> Some(ONE) => None </cmd>
       <stack> L:List => ListItem(1) L </stack>

  // Pops the top two values and pushes their sum
  rule <cmd> Some(+) => None </cmd>
       <stack> ListItem(I1:Int) ListItem(I2:Int) L:List => ListItem(I1 +Int I2) L </stack>

  // Pops the top two values and pushes their product
  rule <cmd> Some(*) => None </cmd>
       <stack> ListItem(I1:Int) ListItem(I2:Int) L:List  => ListItem(I1 *Int I2) L </stack>

  // Duplicates the top value
  rule <cmd> Some(DUPLICATE) => None </cmd>
       <stack> ListItem(I:Int) L:List => ListItem(I) ListItem(I) L </stack>

  // Sends the top value to the bottom
  rule <cmd> Some(/) => None </cmd>
       <stack> ListItem(I:Int) L:List => L ListItem(I)  </stack>

  // Sends the bottom value to the top
  rule <cmd> Some(\) => None </cmd>
       <stack> L:List ListItem(I:Int) => ListItem(I) L </stack>

  // Swaps the top two values
  rule <cmd> Some(^) => None </cmd>
       <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(I2) ListItem(I1) L </stack>

  // Pops the top two numbers and pushes 0 if the top number is less than the second-top number, 1 otherwise. 
  rule <cmd> Some(<) => None </cmd>
       <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(0) L </stack>
       requires I1 <Int I2
  rule <cmd> Some(<) => None </cmd>
       <stack> ListItem(I1) ListItem(I2) L:List  => ListItem(1) L </stack>
       requires I1 >=Int I2


  // Pops the top value and prints it as a number
  rule <cmd> Some(:) => None </cmd>
       <stack> ListItem(I:Int) L:List => L </stack>
       <output> O:List => ListItem(Int2String(I)) O </output>

  // Pops the top value and prints it as a string
  rule <cmd> Some(;) => None </cmd>
       <stack> ListItem(I:Int) L:List => L </stack>
       <output> O:List => ListItem(chrChar(I)) O </output>

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
