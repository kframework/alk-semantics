require "../alk.k"


module NALK-SYNTAX 

  imports ALK-SYNTAX
  
  syntax Exp ::= "random" "(" Exp ")" [strict]

  syntax Stmt ::= "success" ";" | "failure" ";"

endmodule

module NALK
  imports NALK-SYNTAX
  imports ALK-SEMANTICS

  configuration 
    <k> copyGlobalState; ~> $PGM:Stmts </k>
    <state> $ST:Map </state>
    <gstate multiplicity="?"> $GST:Map </gstate>
    <randseed multiplicity="?"> $SEED:Int </randseed>

  rule <k> random(N:Int) => ((SEED /Int 65536) %Int 32768) %Int N ...</k>
       <randseed> SEED:Int => SEED *Int  1103515245 +Int 12345 </randseed>

  rule <k> success; </k>
       (<randseed> _:K </randseed> => .)
       (<gstate> _:Map </gstate> => .)

  rule <k> failure; </k>
       (<randseed> _:K </randseed> => .)
       (<gstate> _:Map </gstate> => .)

endmodule

