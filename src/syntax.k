module SYNTAX
  imports INT-SYNTAX
  imports STRING-SYNTAX
  imports LIST

  syntax Command ::=  "ONE" [token]     
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

  syntax CommandOrComment
  syntax Commands ::= List{Command,""}

  syntax Cmd ::= Command

  syntax Line ::= Commands "EOL"
  syntax Lines ::= List{Line,""}

  syntax Comment ::= "[" String "]"
endmodule

