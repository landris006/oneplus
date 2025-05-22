module UTILS
  imports SYNTAX
  imports INT

  syntax Int ::= size(Commands) [function]
  rule size(_:Command CS:Commands) => 1 +Int size(CS)
  rule size(.Commands) => 0

  syntax Command ::= at(Int, Commands) [function]
  rule at(I:Int, C:Command _:Commands) => C
    requires I ==Int 0
  rule at(I:Int, _:Command CS:Commands) => at(I -Int 1, CS)
    requires I >Int 0

  syntax Option ::= "None" | Some(Command) // the Rust influence...
endmodule
