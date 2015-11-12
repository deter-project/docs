metadescription> ::= declaration dimensions

declaration ::= *define* identifier ":"

dimensions ::= dimension {dimensions}

dimension ::= logtopo | evtimeline

logtopo ::= *topology* objects cardinality relationships

evtimeline ::= *timeline* definitions timeline invariants

objects ::= *objects* object {object}

object ::= alias | dobject

alias ::= obname "." obfield

dobject ::= obtype [obname] ":=" "{" obass "}"

obass ::= obass ["," obass]

obass ::= obvar | obstate

obvar ::= obtype obname ["=" value] 

obstate ::= state "=" value

obname ::= identifier

obtype from list of object types

value ::= number | string

identifier ::=  letter { letter | digit }

letter
diggit
number 
string
