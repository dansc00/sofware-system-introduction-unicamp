%{ 
#include <stdio.h>
#include <stdlib.h>

#define MAX_INST 512
#define MAX_HEADER 4
#define LDA 0x20
#define STA 0x10 
#define ADD 0x30
#define AND 0x50
#define OR 0x40
#define NOT 0x60
#define JMP 0x80
#define JN 0x90
#define JZ 0xA0
#define NOP 0x0
#define HLT 0xF0 
#define DATA 100 
#define X 999 
%}
%% 
^LDA {return LDA;}
^STA {return STA;}
^ADD {return ADD;}
^AND {return AND;}
^OR {return OR;}
^NOT {return NOT;}
^JMP {return JMP;}
^JN {return JN;}
^JZ {return JZ;}
^NOP {return NOP;}
^HLT {return HLT;}
[0-9A-F]+ {return DATA;}
<<EOF>> {return X;}
%% 

typedef struct Buffer{
	
	char* opcBuffer; // buffer armazena opcodes hexadecimais
	int nPos; // primeira posição livre no buffer e numero de opcodes adicionados
} buffer;

buffer* bufferInitializer(){
	
	buffer* buffer = malloc(sizeof(buffer));
	buffer->opcBuffer = (char*)malloc(MAX_INST);
	buffer->nPos = 0;
	return buffer;
}

void bufferWrite(buffer* buffer, int opc){

	buffer->opcBuffer[buffer->nPos] = opc;
	buffer->nPos++;
}

int strIntConversor(char* str){

	int res;
	sscanf(str, "%x", &res);
	return res;
}

int main(int argc, char *argv[]){

	int header[MAX_HEADER] = {0x03, 0x4E, 0x44, 0x52}; // cabeçalho padrão
	FILE *fin; // ponteiro para arquivo de entrada
	FILE *fout; // ponteiro para arquivo de saida
	int tokenType; // marca tipo de token
	buffer* buffer = bufferInitializer(); // buffer que armazena dados a serem escritos
	
	if(argc == 2){ // se existe arquivo passado por parametro
		fin = fopen(argv[1], "r"); // cria arquivo de entrada em modo leitura
		if(fin)
			yyin = fin; // arquivo a ser lido pelo lex
		else
			perror(argv[0]); // arquivo não pode ser lido
	}
	else{
		yyin = stdin; // atribui buffer da entrada padrão	
	}

	fout = fopen("neander.mem", "wb"); // cria arquivo de saida em modo escrita binária
	if(!fout){ // falha na escrita do arquivo
		printf("Não foi possível escrever o arquivo\n");
		exit(1);
	}	

	for(int i = 0; i < MAX_HEADER; i++)
		bufferWrite(buffer, header[i]); // escreve header no buffer 

	while((tokenType = yylex()) != X){ // chama analisador léxico e recebe código do token identificado

		switch(tokenType){ // identifica token e escreve opcode hexadecimal correspondente no buffer

			case LDA:
				bufferWrite(buffer, LDA);
			break;

			case STA:
				bufferWrite(buffer, STA);
			break;

			case ADD:
				bufferWrite(buffer, ADD);
			break;

			case AND:
				bufferWrite(buffer, AND);
			break;

			case OR:
				bufferWrite(buffer, OR);
			break;

			case NOT:
				bufferWrite(buffer, NOT);
			break;

			case JMP:
				bufferWrite(buffer, JMP);
			break;

			case JN:
				bufferWrite(buffer, JN);
			break;

			case JZ:
				bufferWrite(buffer, JZ);
			break;

			case NOP:
				bufferWrite(buffer, NOP);
			break;

			case HLT:
				bufferWrite(buffer, HLT);
			break;

			case DATA:
				bufferWrite(buffer, strIntConversor(yytext));
			break;
		}
		bufferWrite(buffer, 0x00); // escreve byte zero para cada opcode escrito
	}

	fwrite(buffer->opcBuffer, sizeof(char), buffer->nPos, fout); // realiza escrita binária do buffer no arquivo de saida
	fclose(fout); // fecha arquivo de saida
	fclose(fin); // fecha arquivo de entrada
	free(buffer->opcBuffer); // desaloca memória
	free(buffer);
	return 0;
}

