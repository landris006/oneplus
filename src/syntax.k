module SYNTAX
  imports INT-SYNTAX
  imports STRING-SYNTAX
  imports LIST
  imports ID-SYNTAX

  syntax Command ::=  "ONE"
                    | "+"
                    | "*"
                    | "DUPLICATE"
                    | "/"
                    | "BACKSLASH"
                    | "^"
                    | "<"
                    | "."
                    | ","
                    | ":"
                    | ";"
                    | "#"
                    | "(" Id "|" Commands ")"
                    | "(" Id ")"
  
  syntax Commands ::= List{Command,""}

  syntax Cmd ::= Command

  syntax Line ::= Commands "EOL"
  syntax Lines ::= List{Line,""}

  syntax Comment ::= "[" String "]"
endmodule

