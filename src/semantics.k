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

    <cmd> None </cmd> // The current command to be evaluated

    <scopes>
      <scope multiplicity="*" type="List"> // Starts out empty by default
        <noop> 0 </noop>
        <ptr> 0 </ptr>
        <commands> .Commands </commands>
      </scope>
    </scopes>

    <subroutines> .Map </subroutines>
    <stack> .List </stack>

    <input> .List </input>
    <output> .List </output>
  </T>

  rule <k> L:Line LS:Lines => L ~> LS ... </k>

  // Progress to next line
  rule <k> CS:Commands EOL => .K ...</k>    
       <scopes>
        (.Bag =>
          <scope>
            <noop> 0 </noop>
            <ptr> 0 </ptr>
            <commands> CS </commands>
          </scope>
        ) // Notice: no "...", so we can only progress to the next line if the scope is empty
       </scopes>

  // Reached end of line
  rule <scopes>
        (<scope> ...
          <commands> CS:Commands </commands>
          <ptr> P:Int </ptr>
        ... </scope>
          =>
        .Bag
        ) ...
       </scopes>
       requires P >=Int size(CS)

  // If <cmd> is empty, increment <ptr> and load the next command
  rule <scopes>
        <scope>
          <noop> N:Int </noop>
          <ptr> P:Int </ptr>
          <commands> CS:Commands </commands>
        </scope>
          =>
        <scope>
          <ptr> P +Int 1 </ptr>
          <commands> CS:Commands </commands>
          <noop> N </noop>
        </scope>
        ...
       </scopes>
       <cmd> None => Some(at(P, CS)) </cmd>
       requires P >=Int 0 andBool P <Int size(CS)

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

  // Function definition (which is also a call)
  rule <cmd> Some((X:Id | CS:Commands)) => None </cmd>
       <scopes>
        (.Bag =>
          <scope>
            <noop> 0 </noop>
            <ptr> 0 </ptr>
            <commands> CS </commands>
          </scope>
        ) ...
       </scopes>
       <subroutines> M:Map => M[X <- CS] </subroutines>

  // Function call
  rule <cmd> Some((X:Id)) => None </cmd>
       <subroutines> ( X |-> CS:Commands ) ... </subroutines>
       <scopes>
        (.Bag =>
          <scope>
            <noop> 0 </noop>
            <ptr> 0 </ptr>
            <commands> CS </commands>
          </scope>
        ) ...
       </scopes>

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
