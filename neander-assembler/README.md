## About

Assembler for the NEANDER processor simulator. NEANDER source URL: https://www.inf.ufrgs.br/arq/wiki/doku.php?id=neander

## Files
- input.asm: input example
- neander_assembler.l: assembler
- neander_assembler.out: compiled assembler
- neander.mem: binary output

## To compile
```bash
flex neander_assembler.l
gcc -o neander_assembler.out -g lex.yy.c -lfl
```
