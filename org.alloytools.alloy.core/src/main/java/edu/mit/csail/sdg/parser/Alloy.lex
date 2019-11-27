// Alloy Analyzer 4 -- Copyright (c) 2006-2008, Felix Chang
// Electrum -- Copyright (c) 2015-present, Nuno Macedo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
// merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
// OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

package edu.mit.csail.sdg.parser;

import edu.mit.csail.sdg.alloy4.Err;
import edu.mit.csail.sdg.alloy4.ErrorSyntax;
import edu.mit.csail.sdg.alloy4.Pos;
import edu.mit.csail.sdg.alloy4.Version;
import edu.mit.csail.sdg.ast.ExprConstant;
import edu.mit.csail.sdg.ast.ExprVar;
import java.util.List;
import java_cup.runtime.*;

/** Autogenerated by JFlex 1.4.1 */

// @modified: Nuno Macedo // [HASLab] electrum-temporal, electrum-features

%%

// There are 3 sets of "special tokens" that the lexer will not output.
// But the Parser expects them.
// So a special Filter class is written that sits between Lexer and Parser.
// The Filter class observes the stream of tokens, and intelligently
// merges or changes some primitive tokens into special tokens.
// For more details, refer to the main documentation.
//
// But, very briefly, here are the 3 groups:
//
// (1) The lexer will generate only ALL, NO, LONE, ONE, SUM, SOME.
// It will not output ALL2, NO2, LONE2, ONE2, SUM2, SOME2.
// (The Filter class will change some ONE into ONE2, etc)
//
// (2) The lexer won't output NOTEQUALS, NOTIN, NOTLT, NOTLTE, NOTGT, NOTGTE.
// Instead it outputs them as separate tokens (eg. "NOT" "EQUALS").
// (The Filter class is used to merge them into a single "NOTEQUALS" token)
//
// (3) The lexer willn't output the 15 special arrows (eg. ONE_ARROW_ONE)
// Instead it outputs them as separate tokens (eg. "ONE", "ARROW", "ONE")
// (The Filter class is used to merge them into a single "ONE_ARROW_ONE" token)

%class CompLexer // The ordering of these directives is important
%cupsym CompSym
%cup
%eofval{
  return new Symbol(CompSym.EOF, alloy_here(" "), alloy_here(" "));
%eofval}
%public
%final
%unicode
%line
%column
%pack

%{
 public String alloy_filename="";
 public int alloy_lineoffset=0; // If not zero, it is added to the current LINE NUMBER
 public List<Object> alloy_seenDollar;
 public CompModule alloy_module;
 private final Pos alloy_here(String txt) {
    return new Pos(alloy_filename,yycolumn+1,yyline+1+alloy_lineoffset,yycolumn+txt.length(),yyline+1);
 }
 private final Symbol alloy_sym(String txt, int type) {
    Pos p = alloy_here(txt); return new Symbol(type, p, p);
 }
 private final Symbol alloy_string(String txt) throws Err {
    Pos p = alloy_here(txt);
    if (!Version.experimental) throw new ErrorSyntax(p, "String literal is not currently supported.");
    StringBuilder sb = new StringBuilder(txt.length());
    for(int i=0; i<txt.length(); i++) {
       char c = txt.charAt(i);
       if (c=='\r' || c=='\n') throw new ErrorSyntax(p, "String literal cannot span multiple lines; use \\n instead.");
       if (c=='\\') {
          i++;
          if (i>=txt.length()) throw new ErrorSyntax(p, "String literal cannot end with a single \\");
          c = txt.charAt(i);
          if (c=='n') c='\n'; else if (c!='\"' && c!='\\') throw new ErrorSyntax(p, "String literal currently only supports\nthree escape sequences: \\\\, \\n, and \\\""); // [HASLab] protect primes
       }
       sb.append(c);
    }
    txt = sb.toString();
    if (txt.length()==2) throw new ErrorSyntax(p, "Empty string is not allowed; try rewriting your model to use an empty set instead.");
    return new Symbol(CompSym.STR, p, ExprConstant.Op.STRING.make(p, txt));
 }
 private final Symbol alloy_id(String txt) throws Err {
    Pos p=alloy_here(txt);
    if (alloy_seenDollar.size()==0 && txt.indexOf('$')>=0) alloy_seenDollar.add(null);
    return new Symbol(CompSym.ID, p, ExprVar.make(p,txt));
 }
 private final Symbol alloy_num(String txt) throws Err {
    Pos p=alloy_here(txt);
    int n=0;
    try {
        txt = txt.replaceAll("_","");
        n=Integer.parseInt(txt);
    } catch(NumberFormatException ex) {
       throw new ErrorSyntax(p, "The number "+txt+" " + ex);
    }
    return new Symbol(CompSym.NUMBER, p, ExprConstant.Op.NUMBER.make(p, n));
 }
 private final Symbol alloy_hexnum(String txt) throws Err {
    Pos p=alloy_here(txt);
    int n=0;
    try {
        txt = txt.substring(2).replaceAll("_","");
        n=Integer.parseInt(txt, 16);
    } catch(NumberFormatException ex) {
       throw new ErrorSyntax(p, "The hex number "+txt+" " + ex);
    }
    return new Symbol(CompSym.NUMBER, p, ExprConstant.Op.NUMBER.make(p, n));
 }
 private final Symbol alloy_binarynum(String txt) throws Err {
    Pos p=alloy_here(txt);
    int n=0;
    try {
        txt = txt.substring(2).replaceAll("_","");
        n=Integer.parseInt(txt, 2);
    } catch(NumberFormatException ex) {
       throw new ErrorSyntax(p, "The binary number "+txt+" " + ex);
    }
    return new Symbol(CompSym.NUMBER, p, ExprConstant.Op.NUMBER.make(p, n));
 }
%}

%%

"!"                   { return alloy_sym(yytext(), CompSym.NOT         );}
"#"                   { return alloy_sym(yytext(), CompSym.HASH        );}
"&&"                  { return alloy_sym(yytext(), CompSym.AND         );}
"&"                   { return alloy_sym(yytext(), CompSym.AMPERSAND   );}
"("                   { return alloy_sym(yytext(), CompSym.LPAREN      );}
")"                   { return alloy_sym(yytext(), CompSym.RPAREN      );}
"*"                   { return alloy_sym(yytext(), CompSym.STAR        );}
"++"                  { return alloy_sym(yytext(), CompSym.PLUSPLUS    );}
"+"                   { return alloy_sym(yytext(), CompSym.PLUS        );}
","                   { return alloy_sym(yytext(), CompSym.COMMA       );}
"->"                  { return alloy_sym(yytext(), CompSym.ARROW       );}
"-"                   { return alloy_sym(yytext(), CompSym.MINUS       );}
"."                   { return alloy_sym(yytext(), CompSym.DOT         );}
"/"                   { return alloy_sym(yytext(), CompSym.SLASH       );}
"::"                  { return alloy_sym(yytext(), CompSym.DOT         );}
":>"                  { return alloy_sym(yytext(), CompSym.RANGE       );}
":"                   { return alloy_sym(yytext(), CompSym.COLON       );}
"<=>"                 { return alloy_sym(yytext(), CompSym.IFF         );}
"<="                  { return alloy_sym(yytext(), CompSym.LTE         );}
"<:"                  { return alloy_sym(yytext(), CompSym.DOMAIN      );}
"<<"                  { return alloy_sym(yytext(), CompSym.SHL         );}
"<"                   { return alloy_sym(yytext(), CompSym.LT          );}
"=<"                  { return alloy_sym(yytext(), CompSym.LTE         );}
"=>"                  { return alloy_sym(yytext(), CompSym.IMPLIES     );}
"="                   { return alloy_sym(yytext(), CompSym.EQUALS      );}
">>>"                 { return alloy_sym(yytext(), CompSym.SHR         );}
">>"                  { return alloy_sym(yytext(), CompSym.SHA         );}
">="                  { return alloy_sym(yytext(), CompSym.GTE         );}
">"                   { return alloy_sym(yytext(), CompSym.GT          );}
"@"                   { return alloy_sym(yytext(), CompSym.AT          );}
"["                   { return alloy_sym(yytext(), CompSym.LBRACKET    );}
"]"                   { return alloy_sym(yytext(), CompSym.RBRACKET    );}
"^"                   { return alloy_sym(yytext(), CompSym.CARET       );}
"{"                   { return alloy_sym(yytext(), CompSym.LBRACE      );}
"||"                  { return alloy_sym(yytext(), CompSym.OR          );}
"|"                   { return alloy_sym(yytext(), CompSym.BAR         );}
"}"                   { return alloy_sym(yytext(), CompSym.RBRACE      );}
"~"                   { return alloy_sym(yytext(), CompSym.TILDE       );}
"abstract"            { return alloy_sym(yytext(), CompSym.ABSTRACT    );}
"all"                 { return alloy_sym(yytext(), CompSym.ALL         );}
"and"                 { return alloy_sym(yytext(), CompSym.AND         );}
"assert"              { return alloy_sym(yytext(), CompSym.ASSERT      );}
"as"                  { return alloy_sym(yytext(), CompSym.AS          );}
"but"                 { return alloy_sym(yytext(), CompSym.BUT         );}
"check"               { return alloy_sym(yytext(), CompSym.CHECK       );}
"disjoint"            { return alloy_sym(yytext(), CompSym.DISJ        );}
"disj"                { return alloy_sym(yytext(), CompSym.DISJ        );}
"else"                { return alloy_sym(yytext(), CompSym.ELSE        );}
"enum"                { return alloy_sym(yytext(), CompSym.ENUM        );}
"exactly"             { return alloy_sym(yytext(), CompSym.EXACTLY     );}
"exhaustive"          { return alloy_sym(yytext(), CompSym.EXH         );}
"exh"                 { return alloy_sym(yytext(), CompSym.EXH         );}
"expect"              { return alloy_sym(yytext(), CompSym.EXPECT      );}
"extends"             { return alloy_sym(yytext(), CompSym.EXTENDS     );}
"fact"                { return alloy_sym(yytext(), CompSym.FACT        );}
"for"                 { return alloy_sym(yytext(), CompSym.FOR         );}
"fun"                 { return alloy_sym(yytext(), CompSym.FUN         );}
"iden"                { return alloy_sym(yytext(), CompSym.IDEN        );}
"iff"                 { return alloy_sym(yytext(), CompSym.IFF         );}
"implies"             { return alloy_sym(yytext(), CompSym.IMPLIES     );}
"Int"                 { return alloy_sym(yytext(), CompSym.SIGINT      );}
"int"                 { return alloy_sym(yytext(), CompSym.INT         );}
"in"                  { return alloy_sym(yytext(), CompSym.IN          );}
"let"                 { return alloy_sym(yytext(), CompSym.LET         );}
"lone"                { return alloy_sym(yytext(), CompSym.LONE        );}
"module"              { return alloy_sym(yytext(), CompSym.MODULE      );}
"none"                { return alloy_sym(yytext(), CompSym.NONE        );}
"not"                 { return alloy_sym(yytext(), CompSym.NOT         );}
"no"                  { return alloy_sym(yytext(), CompSym.NO          );}
"one"                 { return alloy_sym(yytext(), CompSym.ONE         );}
"open"                { return alloy_sym(yytext(), CompSym.OPEN        );}
"or"                  { return alloy_sym(yytext(), CompSym.OR          );}
"partition"           { return alloy_sym(yytext(), CompSym.PART        );}
"part"                { return alloy_sym(yytext(), CompSym.PART        );}
"pred"                { return alloy_sym(yytext(), CompSym.PRED        );}
"private"             { return alloy_sym(yytext(), CompSym.PRIVATE     );}
"run"                 { return alloy_sym(yytext(), CompSym.RUN         );}
"seq"                 { return alloy_sym(yytext(), CompSym.SEQ         );}
"set"                 { return alloy_sym(yytext(), CompSym.SET         );}
"sig"                 { return alloy_sym(yytext(), CompSym.SIG         );}
"some"                { return alloy_sym(yytext(), CompSym.SOME        );}
"String"              { return alloy_sym(yytext(), CompSym.STRING      );}
"sum"                 { return alloy_sym(yytext(), CompSym.SUM         );}
"this"                { return alloy_sym(yytext(), CompSym.THIS        );}
"univ"                { return alloy_sym(yytext(), CompSym.UNIV        );}
"always"              { return alloy_sym(yytext(), CompSym.ALWAYS      );} // [HASLab] temporal tokens
"after"               { return alloy_sym(yytext(), CompSym.AFTER       );} // [HASLab] temporal tokens
"eventually"          { return alloy_sym(yytext(), CompSym.EVENTUALLY  );} // [HASLab] temporal tokens
"historically"        { return alloy_sym(yytext(), CompSym.HISTORICALLY);} // [HASLab] temporal tokens
"before"              { return alloy_sym(yytext(), CompSym.BEFORE      );} // [HASLab] temporal tokens
"once"                { return alloy_sym(yytext(), CompSym.ONCE        );} // [HASLab] temporal tokens
"releases"            { return alloy_sym(yytext(), CompSym.RELEASES    );} // [HASLab] temporal tokens
"until"               { return alloy_sym(yytext(), CompSym.UNTIL       );} // [HASLab] temporal tokens
"since"               { return alloy_sym(yytext(), CompSym.SINCE       );} // [HASLab] temporal tokens
"triggered"           { return alloy_sym(yytext(), CompSym.TRIGGERED   );} // [HASLab] temporal tokens
";"                   { return alloy_sym(yytext(), CompSym.TRCSEQ      );} // [HASLab] temporal tokens
"var"                 { return alloy_sym(yytext(), CompSym.VAR         );} // [HASLab] temporal tokens
"Time"                { return alloy_sym(yytext(), CompSym.TIME        );} // [HASLab] temporal tokens
"'"                   { return alloy_sym(yytext(), CompSym.PRIME       );} // [HASLab] temporal tokens
"with"          	  { return alloy_sym(yytext(), CompSym.WITH        );} // [HASLab] colorful marks
"\u2780"           	  { return alloy_sym(yytext(), CompSym.PFEAT1      );} // [HASLab] colorful marks
"\u2781"           	  { return alloy_sym(yytext(), CompSym.PFEAT2      );} // [HASLab] colorful marks
"\u2782"           	  { return alloy_sym(yytext(), CompSym.PFEAT3      );} // [HASLab] colorful marks
"\u2783"           	  { return alloy_sym(yytext(), CompSym.PFEAT4      );} // [HASLab] colorful marks
"\u2784"           	  { return alloy_sym(yytext(), CompSym.PFEAT5      );} // [HASLab] colorful marks
"\u2785"           	  { return alloy_sym(yytext(), CompSym.PFEAT6      );} // [HASLab] colorful marks
"\u2786"           	  { return alloy_sym(yytext(), CompSym.PFEAT7      );} // [HASLab] colorful marks
"\u2787"           	  { return alloy_sym(yytext(), CompSym.PFEAT8      );} // [HASLab] colorful marks
"\u2788"           	  { return alloy_sym(yytext(), CompSym.PFEAT9      );} // [HASLab] colorful marks
"\u24ea"        	  { return alloy_sym(yytext(), CompSym.PFEAT0      );} // [HASLab] colorful marks
"\u278A"          	  { return alloy_sym(yytext(), CompSym.NFEAT1      );} // [HASLab] colorful marks
"\u278B"          	  { return alloy_sym(yytext(), CompSym.NFEAT2      );} // [HASLab] colorful marks
"\u278C"          	  { return alloy_sym(yytext(), CompSym.NFEAT3      );} // [HASLab] colorful marks
"\u278D"          	  { return alloy_sym(yytext(), CompSym.NFEAT4      );} // [HASLab] colorful marks
"\u278E"          	  { return alloy_sym(yytext(), CompSym.NFEAT5      );} // [HASLab] colorful marks
"\u278F"          	  { return alloy_sym(yytext(), CompSym.NFEAT6      );} // [HASLab] colorful marks
"\u2790"          	  { return alloy_sym(yytext(), CompSym.NFEAT7      );} // [HASLab] colorful marks
"\u2791"          	  { return alloy_sym(yytext(), CompSym.NFEAT8      );} // [HASLab] colorful marks
"\u2792"          	  { return alloy_sym(yytext(), CompSym.NFEAT9      );} // [HASLab] colorful marks

[\"] ([^\\\"] | ("\\" .))* [\"] [\$0-9a-zA-Z_\"] [\$0-9a-zA-Z_\"]* 	   { throw new ErrorSyntax(alloy_here(yytext()),"String literal cannot be followed by a legal identifier character."); }  // [HASLab] protect primes
[\"] ([^\\\"] | ("\\" .))* [\"]                                        { return alloy_string(yytext()); }
[\"] ([^\\\"] | ("\\" .))*                                             { throw new ErrorSyntax(alloy_here(yytext()),"String literal is missing its closing \" character"); }
[0]"x"([_]|([0-9A-Fa-f][0-9A-Fa-f]))+                                  { return alloy_hexnum (yytext()); }
[0]"b"[01_]+                                                           { return alloy_binarynum (yytext()); }
[0-9][0-9]*[\$a-zA-Z_\"][\$0-9a-zA-Z_\"]*                              { throw new ErrorSyntax(alloy_here(yytext()),"Name cannot start with a number."); } // [HASLab] protect primes
[0-9][0-9_]*                                                           { return alloy_num (yytext()); }
[:jletter:][[:jletterdigit:]\"]*                                       { return alloy_id  (yytext()); } // [HASLab] protect primes


"/**" ~"*/"                  { }

"/*" ~"*/"                   { }

("//"|"--") [^\r\n]* [\r\n]  { }

("//"|"--") [^\r\n]*         { } // This rule is shorter than the previous rule,
                                 // so it will only apply if the final line of a file is missing the \n or \r character.

[ \t\f\r\n]                  { }

. { throw new ErrorSyntax(alloy_here(" "), "Syntax error at the "+yytext()+" character. HEX: \\u"+Integer.toString(yytext().charAt(0),16)+")"); }
