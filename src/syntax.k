module SYNTAX
  imports INT-SYNTAX
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

  syntax Line ::= Commands "EOL"
  syntax Lines ::= List{Line,""}
endmodule
