module SYNTAX
  imports INT-SYNTAX
  imports STRING-SYNTAX
  imports LIST

  syntax Command ::=  "ONE" [token]     
                    | "+"  [token]
                    //| "*"  [token]
                    //| "DUPLICATE" [token]
                    //| "/"  [token]
                    //| "\\" [token]
                    //| "^"  [token]
                    //| "<"  [token]
                    //| "." [token]
                    //| "," [token]
                    //| ":" [token]
                    //| ";" [token]
                    //| "#"  [token]

  syntax Commands ::= List{Command,""}

  syntax Cmd ::= Command | "DONE"

  syntax Line ::= Commands "EOL"
  syntax Lines ::= List{Line,""}

  syntax Comment ::= "[" String "]"
endmodule

