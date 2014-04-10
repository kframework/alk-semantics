require "../alk.k"

/*

  Compiling command:
    kompile alk --syntax-module NALK-SYNTAX
*/

module NALK-SYNTAX 

  imports ALK-SYNTAX
  
//  syntax Exp ::= "random" "(" Exp ")" [strict, rand]

  syntax Id ::= "random"
  syntax Stmt ::= "success" ";" | "failure" ";"

endmodule

module ALK
  imports NALK-SYNTAX
  imports ALK-SEMANTICS

  rule isVal(random) => true  [anywhere]

  configuration 
    <k> copyGlobalState; ~> $PGM:Stmts </k>
    <state> .Map </state>
    <gstate multiplicity="?"> $ST:Map </gstate>
    <randseed multiplicity="?"> $SEED:Int </randseed>

  rule <k> random(N:Int) => ((SEED /Int 65536) %Int 32768) %Int N ...</k>
       <randseed> SEED:Int => SEED *Int  1103515245 +Int 12345 </randseed>

  rule <k> success; </k>
       (<randseed> _:K </randseed> => .)
       (<gstate> _:Map </gstate> => .)

  rule <k> failure; </k>
       (<randseed> _:K </randseed> => .)
       (<gstate> _:Map </gstate> => .)


  rule <k> failure; </k>
       <state>... F |-> lambda(_ @ _) => . ...</state>

  rule <k> success; </k>
       <state>... F |-> lambda(_ @ _) => . ...</state>
endmodule

