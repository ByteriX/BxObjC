#include "bx_unicode_sqlite3.h"
#include "fts3_tokenizer.h"

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

#define utf8letterA 0xB0D0U
#define utf8letterB 0xB1D0U
#define utf8letterV 0xB2D0U
#define utf8letterG 0xB3D0U
#define utf8letterD 0xB4D0U
#define utf8letterE 0xB5D0U
#define utf8letterYO 0x91D1U
#define utf8letterZH 0xB6D0U
#define utf8letterZ 0xB7D0U
#define utf8letterI 0xB8D0U
#define utf8letterIY 0xB9D0U
#define utf8letterK 0xBAD0U
#define utf8letterL 0xBBD0U
#define utf8letterM 0xBCD0U
#define utf8letterN 0xBDD0U
#define utf8letterO 0xBED0U
#define utf8letterP 0xBFD0U
#define utf8letterR 0x80D1U
#define utf8letterS 0x81D1U
#define utf8letterT 0x82D1U
#define utf8letterU 0x83D1U
#define utf8letterF 0x84D1U
#define utf8letterH 0x85D1U
#define utf8letterTS 0x86D1U
#define utf8letterCH 0x87D1U
#define utf8letterSH 0x88D1U
#define utf8letterSCH 0x89D1U
#define utf8letterTVY 0x8AD1U // TVYordiy znak
#define utf8letterY 0x8BD1U
#define utf8letterMYA 0x8CD1U // MYAgkiy znak
#define utf8letterEE 0x8DD1U
#define utf8letterYU 0x8ED1U
#define utf8letterYA 0x8FD1U

#define LOC_CHAR_TYPE unsigned short
#define LOC_PREFIX(_a) _a##_utf8

#undef LOC_TABLE_ENTRY
#undef LOC_TABLE_INDEX
#define LOC_TABLE_ENTRY struct LOC_PREFIX(stem_table_entry_)
#define LOC_TABLE_INDEX struct LOC_PREFIX(stem_table_index_)


LOC_TABLE_ENTRY
{
	LOC_CHAR_TYPE	suffix[8];
	int				remove, len;
};


LOC_TABLE_INDEX
{
	LOC_CHAR_TYPE	first;
	int				count;
};


// TableStringN, where N is a number of chars
#undef TS1
#undef TS2
#undef TS3
#undef TS4
#undef TS5
#define TS1(c1) { utf8letter##c1 }
#define TS2(c1,c2) { utf8letter##c1, utf8letter##c2 }
#define TS3(c1,c2,c3) { utf8letter##c1, utf8letter##c2, utf8letter##c3 }
#define TS4(c1,c2,c3,c4) { utf8letter##c1, utf8letter##c2, utf8letter##c3, utf8letter##c4 }
#define TS5(c1,c2,c3,c4,c5) { utf8letter##c1, utf8letter##c2, utf8letter##c3, utf8letter##c4, utf8letter##c5 }


static LOC_TABLE_INDEX LOC_PREFIX(ru_adj_i)[] =
{
	{ utf8letterE,	4 },
	{ utf8letterI,	2 },
	{ utf8letterIY,	4 },
	{ utf8letterM,	7 },
	{ utf8letterO,	2 },
	{ utf8letterU,	2 },
	{ utf8letterH,	2 },
	{ utf8letterYU,	4 },
	{ utf8letterYA,	4 },
};


static LOC_TABLE_ENTRY LOC_PREFIX(ru_adj)[] =
{
	{ TS2(E,E),		2, 0 },
	{ TS2(I,E),		2, 0 },
	{ TS2(Y,E),		2, 0 },
	{ TS2(O,E),		2, 0 },

	{ TS3(I,M,I),	3, 0 },
	{ TS3(Y,M,I),	3, 0 },

	{ TS2(E,IY),	2, 0 },
	{ TS2(I,IY),	2, 0 },
	{ TS2(Y,IY),	2, 0 },
	{ TS2(O,IY),	2, 0 },

	{ TS3(A,E,M),	0, 0 },
	{ TS3(U,E,M),	0, 0 },
	{ TS3(YA,E,M),	0, 0 },
	{ TS2(E,M),		2, 0 },
	{ TS2(I,M),		2, 0 },
	{ TS2(Y,M),		2, 0 },
	{ TS2(O,M),		2, 0 },

	{ TS3(E,G,O),	3, 0 },
	{ TS3(O,G,O),	3, 0 },

	{ TS3(E,M,U),	3, 0 },
	{ TS3(O,M,U),	3, 0 },

	{ TS2(I,H),		2, 0 },
	{ TS2(Y,H),		2, 0 },

	{ TS2(E,YU),	2, 0 },
	{ TS2(O,YU),	2, 0 },
	{ TS2(U,YU),	2, 0 },
	{ TS2(YU,YU),	2, 0 },

	{ TS2(A,YA),	2, 0 },
	{ TS2(YA,YA),	2, 0 }
};


static LOC_TABLE_INDEX LOC_PREFIX(ru_part_i)[] =
{
	{ utf8letterA,	3 },
	{ utf8letterM,	1 },
	{ utf8letterN,	3 },
	{ utf8letterO,	3 },
	{ utf8letterY,	3 },
	{ utf8letterSH,	4 },
	{ utf8letterSCH,	5 }
};


static LOC_TABLE_ENTRY LOC_PREFIX(ru_part)[] =
{
	{ TS4(A,N,N,A),		2, 0 },
	{ TS4(E,N,N,A),		2, 0 },
	{ TS4(YA,N,N,A),	2, 0 },

	{ TS3(YA,E,M),		2, 0 },

	{ TS3(A,N,N),		1, 0 },
	{ TS3(E,N,N),		1, 0 },
	{ TS3(YA,N,N),		1, 0 },

	{ TS4(A,N,N,O),		2, 0 },
	{ TS4(E,N,N,O),		2, 0 },
	{ TS4(YA,N,N,O),	2, 0 },

	{ TS4(A,N,N,Y),		2, 0 },
	{ TS4(E,N,N,Y),		2, 0 },
	{ TS4(YA,N,N,Y),	2, 0 },

	{ TS3(A,V,SH),		2, 0 },
	{ TS3(I,V,SH),		3, 0 },
	{ TS3(Y,V,SH),		3, 0 },
	{ TS3(YA,V,SH),		2, 0 },

	{ TS3(A,YU,SCH),	2, 0 },
	{ TS2(A,SCH),		1, 0 },
	{ TS3(YA,YU,SCH),	2, 0 },
	{ TS2(YA,SCH),		1, 0 },
	{ TS3(U,YU,SCH),	3, 0 }
};


static LOC_TABLE_INDEX LOC_PREFIX(ru_verb_i)[] =
{
	{ utf8letterA,	7 },
	{ utf8letterE,	9 },
	{ utf8letterI,	4 },
	{ utf8letterIY,	4 },
	{ utf8letterL,	4 },
	{ utf8letterM,	5 },
	{ utf8letterO,	7 },
	{ utf8letterT,	9 },
	{ utf8letterY,	3 },
	{ utf8letterMYA,	10 },
	{ utf8letterYU,	4 },
	{ utf8letterYA,	1 }
};


static LOC_TABLE_ENTRY LOC_PREFIX(ru_verb)[] =
{
	{ TS3(A,L,A),	3, 0 },
	{ TS3(A,N,A),	3, 0 },
	{ TS3(YA,L,A),	3, 0 },
	{ TS3(YA,N,A),	3, 0 },
	{ TS3(I,L,A),	3, 0 },
	{ TS3(Y,L,A),	3, 0 },
	{ TS3(E,N,A),	3, 0 },

	{ TS4(A,E,T,E),		4, 0 },
	{ TS4(A,IY,T,E),	4, 0 },
	{ TS3(MYA,T,E),		3, 0 },
	{ TS4(U,E,T,E),		4, 0 },
	{ TS4(YA,E,T,E),	4, 0 },
	{ TS4(YA,IY,T,E),	4, 0 },
	{ TS4(E,IY,T,E),	4, 0 },
	{ TS4(U,IY,T,E),	4, 0 },
	{ TS3(I,T,E),		3, 0 },

	{ TS3(A,L,I),	3, 0 },
	{ TS3(YA,L,I),	3, 0 },
	{ TS3(I,L,I),	3, 0 },
	{ TS3(Y,L,I),	3, 0 },

	{ TS2(A,IY),	2, 0 },
	{ TS2(YA,IY),	2, 0 },
	{ TS2(E,IY),	2, 0 },
	{ TS2(U,IY),	2, 0 },

	{ TS2(A,L),		2, 0 },
	{ TS2(YA,L),	2, 0 },
	{ TS2(I,L),		2, 0 },
	{ TS2(Y,L),		2, 0 },

	{ TS3(A,E,M),	3, 0 },
	{ TS3(YA,E,M),	3, 0 },
	{ TS3(U,E,M),	3, 0 },
	{ TS2(I,M),		2, 0 },
	{ TS2(Y,M),		2, 0 },

	{ TS3(A,L,O),	3, 0 },
	{ TS3(A,N,O),	3, 0 },
	{ TS3(YA,L,O),	3, 0 },
	{ TS3(YA,N,O),	3, 0 },
	{ TS3(I,L,O),	3, 0 },
	{ TS3(Y,L,O),	3, 0 },
	{ TS3(E,N,O),	3, 0 },

	{ TS3(A,E,T),	3, 0 },
	{ TS3(A,YU,T),	3, 0 },
	{ TS3(YA,E,T),	3, 0 },
	{ TS3(YA,YU,T),	3, 0 },
	{ TS2(YA,T),	2, 0 },
	{ TS3(U,E,T),	3, 0 },
	{ TS3(U,YU,T),	3, 0 },
	{ TS2(I,T),		2, 0 },
	{ TS2(Y,T),		2, 0 },

	{ TS3(A,N,Y),	3, 0 },
	{ TS3(YA,N,Y),	3, 0 },
	{ TS3(E,N,Y),	3, 0 },

	{ TS4(A,E,SH,MYA),	4, 0 },
	{ TS4(U,E,SH,MYA),	4, 0 },
	{ TS4(YA,E,SH,MYA),	4, 0 },
	{ TS3(A,T,MYA),		3, 0 },
	{ TS3(E,T,MYA),		3, 0 },
	{ TS3(I,T,MYA),		3, 0 },
	{ TS3(U,T,MYA),		3, 0 },
	{ TS3(Y,T,MYA),		3, 0 },
	{ TS3(I,SH,MYA),	3, 0 },
	{ TS3(YA,T,MYA),	3, 0 },

	{ TS2(A,YU),	2, 0 },
	{ TS2(U,YU),	2, 0 },
	{ TS2(YA,YU),	2, 0 },
	{ TS1(YU),		1, 0 },

	{ TS2(U,YA),	2, 0 }
};


static LOC_TABLE_INDEX LOC_PREFIX(ru_dear_i)[] =
{
	{ utf8letterK,	3 },
	{ utf8letterA,	2 },
	{ utf8letterV,	2 },
	{ utf8letterE,	2 },
	{ utf8letterI,	4 },
	{ utf8letterIY,	2 },
	{ utf8letterM,	4 },
	{ utf8letterO,	2 },
	{ utf8letterU,	2 },
	{ utf8letterH,	2 },
	{ utf8letterYU,	2 }
};


static LOC_TABLE_ENTRY LOC_PREFIX(ru_dear)[] =
{
	{ TS3(CH,E,K),		3, 0 },
	{ TS3(CH,O,K),		3, 0 },
	{ TS3(N,O,K),		3, 0 },

	{ TS3(CH,K,A),		3, 0 },
	{ TS3(N, K,A),		3, 0 },
	{ TS4(CH,K,O,V),	4, 0 },
	{ TS4(N, K,O,V),	4, 0 },
	{ TS3(CH,K,E),		3, 0 },
	{ TS3(N, K,E),		3, 0 },
	{ TS3(CH,K,I),		3, 0 },
	{ TS3(N, K,I),		3, 0 },
	{ TS5(CH,K,A,M,I),	5, 0 },
	{ TS5(N, K,A,M,I),	5, 0 },
	{ TS4(CH,K,O,IY),	4, 0 },
	{ TS4(N, K,O,IY),	4, 0 },
	{ TS4(CH,K,A,M),	4, 0 },
	{ TS4(N, K,A,M),	4, 0 },
	{ TS4(CH,K,O,M),	4, 0 },
	{ TS4(N, K,O,M),	4, 0 },
	{ TS3(CH,K,O),		3, 0 },
	{ TS3(N, K,O),		3, 0 },
	{ TS3(CH,K,U),		3, 0 },
	{ TS3(N, K,U),		3, 0 },
	{ TS4(CH,K,A,H),	4, 0 },
	{ TS4(N, K,A,H),	4, 0 },
	{ TS4(CH,K,O,YU),	4, 0 },
	{ TS4(N, K,O,YU),	4, 0 }
};


static LOC_TABLE_INDEX LOC_PREFIX(ru_noun_i)[] =
{
	{ utf8letterA,	1 },
	{ utf8letterV,	2 },
	{ utf8letterE,	3 },
	{ utf8letterI,	6 },
	{ utf8letterIY,	4 },
	{ utf8letterM,	5 },
	{ utf8letterO,	1 },
	{ utf8letterU,	1 },
	{ utf8letterH,	3 },
	{ utf8letterY,	1 },
	{ utf8letterMYA,	1 },
	{ utf8letterYU,	3 },
	{ utf8letterYA,	3 }
};


static LOC_TABLE_ENTRY LOC_PREFIX(ru_noun)[] =
{
	{ TS1(A),		1, 0 },

	{ TS2(E,V),		2, 0 },
	{ TS2(O,V),		2, 0 },

	{ TS2(I,E),		2, 0 },
	{ TS2(MYA,E),	2, 0 },
	{ TS1(E),		1, 0 },

	{ TS4(I,YA,M,I),4, 0 },
	{ TS3(YA,M,I),	3, 0 },
	{ TS3(A,M,I),	3, 0 },
	{ TS2(E,I),		2, 0 },
	{ TS2(I,I),		2, 0 },
	{ TS1(I),		1, 0 },

	{ TS3(I,E,IY),	3, 0 },
	{ TS2(E,IY),	2, 0 },
	{ TS2(O,IY),	2, 0 },
	{ TS2(I,IY),	2, 0 },

	{ TS3(I,YA,M),	3, 0 },
	{ TS2(YA,M),	2, 0 },
	{ TS3(I,E,M),	3, 0 },
	{ TS2(A,M),		2, 0 },
	{ TS2(O,M),		2, 0 },

	{ TS1(O),		1, 0 },

	{ TS1(U),		1, 0 },

	{ TS2(A,H),		2, 0 },
	{ TS3(I,YA,H),	3, 0 },
	{ TS2(YA,H),	2, 0 },

	{ TS1(Y),		1, 0 },

	{ TS1(MYA),		1, 0 },

	{ TS2(I,YU),	2, 0 },
	{ TS2(MYA,YU),	2, 0 },
	{ TS1(YU),		1, 0 },

	{ TS2(I,YA),	2, 0 },
	{ TS2(MYA,YA),	2, 0 },
	{ TS1(YA),		1, 0 }
};


int stem_ru_table_i ( LOC_CHAR_TYPE * word, int len, LOC_TABLE_ENTRY * table, LOC_TABLE_INDEX * itable, int icount )
{
	int i, j, k, m;
	LOC_CHAR_TYPE l = word[--len];

	for ( i=0, j=0; i<icount; i++ )
	{
		if ( l==itable[i].first )
		{
			m = itable[i].count;
			i = j-1;
			while ( m-- )
			{
				i++;
				j = table[i].len;
				k = len;
				if ( j>k )
					continue;
				for ( ; j>=0; k--, j-- )
					if ( word[k]!=table[i].suffix[j] )
						break;
				if ( j>=0 )
					continue;
				return table[i].remove;
			}
			return 0;
		}
		j += itable[i].count;
	}
	return 0;
}


#undef STEM_RU_FUNC
#define STEM_RU_FUNC(func,table) \
	int func ( LOC_CHAR_TYPE * word, int len ) \
	{ \
		return stem_ru_table ( word, len, LOC_PREFIX(table), \
			sizeof(LOC_PREFIX(table))/sizeof(LOC_TABLE_ENTRY) ); \
	}

#undef STEM_RU_FUNC_I
#define STEM_RU_FUNC_I(table) \
	int LOC_PREFIX(stem_##table##_i) ( LOC_CHAR_TYPE * word, int len ) \
	{ \
		return stem_ru_table_i ( word, len, LOC_PREFIX(table), LOC_PREFIX(table##_i), \
			sizeof(LOC_PREFIX(table##_i))/sizeof(LOC_TABLE_INDEX) ); \
	}


STEM_RU_FUNC_I(ru_adj)
STEM_RU_FUNC_I(ru_part)
STEM_RU_FUNC_I(ru_dear)
STEM_RU_FUNC_I(ru_verb)
STEM_RU_FUNC_I(ru_noun)


static int LOC_PREFIX(stem_ru_adjectival) ( LOC_CHAR_TYPE * word, int len )
{
	register int i = LOC_PREFIX(stem_ru_adj_i) ( word, len );
	if ( i )
		i += LOC_PREFIX(stem_ru_part_i) ( word, len-i );
	return i;
}


static int LOC_PREFIX(stem_ru_verb_ov) ( LOC_CHAR_TYPE * word, int len )
{
	register int i = LOC_PREFIX(stem_ru_verb_i) ( word, len );
	if ( i && (len>=i+2) && word[len-i-2] == utf8letterO && word[len-i-1] == utf8letterV )
		return i+2;
	return i;
}


void LOC_PREFIX(stem_ru_init) ()
{
	unsigned int i;

	#undef STEM_RU_INIT_TABLE
	#define STEM_RU_INIT_TABLE(table) \
		for ( i=0; i<(sizeof(LOC_PREFIX(table))/sizeof(LOC_TABLE_ENTRY)); i++ ) \
			LOC_PREFIX(table)[i].len = ((int)strlen((char*)LOC_PREFIX(table)[i].suffix)/sizeof(LOC_CHAR_TYPE))- 1;

	STEM_RU_INIT_TABLE(ru_adj)
	STEM_RU_INIT_TABLE(ru_part)
	STEM_RU_INIT_TABLE(ru_verb)
	STEM_RU_INIT_TABLE(ru_noun)
	STEM_RU_INIT_TABLE(ru_dear)
}


size_t LOC_PREFIX(stem_ru) ( LOC_CHAR_TYPE * word )
{
	size_t startWordAddr = (size_t)word;
	int r1, r2;
	int i, len;

	// IsVowel
	#undef IV
	#define IV(c) ( \
		c==utf8letterA || c==utf8letterE || c==utf8letterYO || c==utf8letterI || c==utf8letterO || \
		c==utf8letterU || c==utf8letterY || c==utf8letterEE || c==utf8letterYU || c==utf8letterYA )

	// EndOfWord
	#undef EOW
	#define EOW(_arg) (!(*((unsigned char*)(_arg))))

	while ( !EOW(word) ) if ( IV(*word) ) break; else word++;
	if ( !EOW(word) ) word++; else return -1;
	len = 0; while ( !EOW(word+len) ) len++;

	r1 = r2 = len;
	for ( i=-1; i<len-1; i++ ) if ( IV(word[i]) && !IV(word[i+1]) ) { r1 = i+2; break; }
	for ( i=r1; i<len-1; i++ ) if ( IV(word[i]) && !IV(word[i+1]) ) { r2 = i+2; break; }

	#define C(p) word[len-p]
	#define W(p,c) ( C(p)==c )
	#define XSUFF2(c2,c1) ( W(1,c1) && W(2,c2) )
	#define XSUFF3(c3,c2,c1) ( W(1,c1) && W(2,c2) && W(3,c3) )
	#define XSUFF4(c4,c3,c2,c1) ( W(1,c1) && W(2,c2) && W(3,c3) && W(4,c4) )
	#define XSUFF5(c5,c4,c3,c2,c1) ( W(1,c1) && W(2,c2) && W(3,c3) && W(4,c4) && W(5,c5) )
	#define BRK(_arg) { len -= _arg; break; }
	#define CHK(_func) { i = LOC_PREFIX(_func) ( word, len ); if ( i ) BRK ( i ); }

	for ( ;; )
	{
		CHK ( stem_ru_dear_i );

		if ( C(1)==utf8letterV && len>=2 )
		{
			if ( C(2)==utf8letterI || C(2)==utf8letterY || C(2)==utf8letterYA )
				BRK(2);

			if ( C(2)==utf8letterA )
			{
				if ( C(3)==utf8letterV && C(4)==utf8letterA )
					BRK(4);
				BRK(2);
			}
		}

		if ( len>=3 && XSUFF3 ( utf8letterV, utf8letterSH, utf8letterI )
			&& ( C(4)==utf8letterA || C(4)==utf8letterI || C(4)==utf8letterY || C(4)==utf8letterYA ) )
				BRK(4);

		if ( len>=5 && XSUFF5 ( utf8letterV, utf8letterSH, utf8letterI, utf8letterS, utf8letterMYA )
			&& ( C(6)==utf8letterA || C(6)==utf8letterI || C(6)==utf8letterY || C(6)==utf8letterYA ) )
				BRK(6);

		CHK ( stem_ru_adjectival );

		if ( len>=2 && ( XSUFF2 ( utf8letterS, utf8letterMYA ) || XSUFF2 ( utf8letterS, utf8letterYA ) ) )
		{
			len -= 2;
			CHK ( stem_ru_adjectival );
			CHK ( stem_ru_verb_ov );
		} else
		{
			CHK ( stem_ru_verb_ov );
		}

		CHK ( stem_ru_noun_i );
		break;
	}

	if ( len && ( W(1,utf8letterIY) || W(1,utf8letterI) ) )
		len--;

	if ( len-r2>=3 && XSUFF3 ( utf8letterO, utf8letterS, utf8letterT ) )
		len -= 3;
	else if ( len-r2>=4 && XSUFF4 ( utf8letterO, utf8letterS, utf8letterT, utf8letterMYA ) )
		len -= 4;

	if ( len>=3 && XSUFF3 ( utf8letterE, utf8letterIY, utf8letterSH ) )
		len -= 3;
	else if ( len>=4 && XSUFF4 ( utf8letterE, utf8letterIY, utf8letterSH, utf8letterE ) )
		len -= 4;

	if ( len>=2 && XSUFF2 ( utf8letterN, utf8letterN ) )
		len--;

	if ( len && W(1,utf8letterMYA) )
		len--;

	return ((size_t) ((unsigned char*)(word+len)) - startWordAddr);
//	return  ((int) (word + len)) - startWordAddr  - 2;
}

// undefine externally defined stuff
#undef LOC_CHAR_TYPE
#undef LOC_PREFIX
#undef RUS

/////////////////////////////////////////////////////////////////////////////

void stem_ru_init ()
{
	stem_ru_init_utf8 ();
}


static inline bool isUnicode(const char *zIn, int nIn) {
	if (nIn <= 0) {
		return false;
	}

	if ((nIn & 1) == 1) {
		return false;
	}

	return *((unsigned char * )zIn) >0x80U;
}


static void copyEnsuredLowerCase(unsigned short * res, unsigned short * symbol) {

	switch (*symbol) {
	case 0x90d0:
		*res = 0xb0d0;
		return;
	case 0x91d0:
		*res = 0xb1d0;
		return;
	case 0x92d0:
		*res = 0xb2d0;
		return;
	case 0x93d0:
		*res = 0xb3d0;
		return;
	case 0x94d0:
		*res = 0xb4d0;
		return;
	case 0x95d0:
		*res = 0xb5d0;
		return;
	case 0x81d0:
		*res = 0x91d1;
		return;
	case 0x96d0:
		*res = 0xb6d0;
		return;
	case 0x97d0:
		*res = 0xb7d0;
		return;
	case 0x98d0:
		*res = 0xb8d0;
		return;
	case 0x99d0:
		*res = 0xb9d0;
		return;
	case 0x9ad0:
		*res = 0xbad0;
		return;
	case 0x9bd0:
		*res = 0xbbd0;
		return;
	case 0x9cd0:
		*res = 0xbcd0;
		return;
	case 0x9dd0:
		*res = 0xbdd0;
		return;
	case 0x9ed0:
		*res = 0xbed0;
		return;
	case 0x9fd0:
		*res = 0xbfd0;
		return;
	case 0xa0d0:
		*res = 0x80d1;
		return;
	case 0xa1d0:
		*res = 0x81d1;
		return;
	case 0xa2d0:
		*res = 0x82d1;
		return;
	case 0xa3d0:
		*res = 0x83d1;
		return;
	case 0xa4d0:
		*res = 0x84d1;
		return;
	case 0xa5d0:
		*res = 0x85d1;
		return;
	case 0xa6d0:
		*res = 0x86d1;
		return;
	case 0xa7d0:
		*res = 0x87d1;
		return;
	case 0xa8d0:
		*res = 0x88d1;
		return;
	case 0xa9d0:
		*res = 0x89d1;
		return;
	case 0xacd0:
		*res = 0x8cd1;
		return;
	case 0xabd0:
		*res = 0x8bd1;
		return;
	case 0xaad0:
		*res = 0x8ad1;
		return;
	case 0xadd0:
		*res = 0x8dd1;
		return;
	case 0xaed0:
		*res = 0x8ed1;
		return;
	case 0xafd0:
		*res = 0x8fd1;
		return;
	default:
		*res = *symbol;
		return;
	}
}

/*
 *  FOR RUSSIAN
 */
static void porter_stemmer_unicode(const char *zIn, int nIn, char *zOut, int *pnOut){
  int i;
  static const int UNICODE_LIMIT = 40; //20 symbols

  //limit to
  int limit = nIn > UNICODE_LIMIT ? UNICODE_LIMIT : nIn;

  i = 0;
  while (i<limit) {
	  bool isNextUtfSymbol = *((unsigned char*)&zIn[i]) > 0x80U;

	  if (isNextUtfSymbol) {

		  bool isNotLastPos = i < limit-1;
		  if (isNotLastPos) {
			  copyEnsuredLowerCase( (unsigned short*) &zOut[i],
					  (unsigned short*) &zIn[i]);
		  }
		  i += 2;
	  } else {
		  //Напр. Грузовозоff. Либо можно не копировать
		  zOut[i] = zIn[i];
		  i++;
	  }
  }

  //Запас есть всгеда. См. выделение памяти для zOut
  zOut[limit] = '\0';


  int len = (int)stem_ru_utf8((unsigned short *) zOut); //Two byte in symbol

  if (len <= 0 || len > limit ) {
	  len = limit;
  }


  *pnOut = len;

  return;

}

static int porterOpen1(
  bx_unicode_sqlite3_tokenizer *pTokenizer,         /* The tokenizer */
  const char *zInput, int nInput,        /* String to be tokenized */
  bx_unicode_sqlite3_tokenizer_cursor **ppCursor    /* OUT: Tokenization cursor */
) {
  stem_ru_init();
  return porterOpen(pTokenizer, zInput, nInput, ppCursor);
}

static int porterNext1(
  bx_unicode_sqlite3_tokenizer_cursor *pCursor,  /* Cursor returned by porterOpen */
  const char **pzToken,               /* OUT: *pzToken is the token text */
  int *pnBytes,                       /* OUT: Number of bytes in token */
  int *piStartOffset,                 /* OUT: Starting offset of token */
  int *piEndOffset,                   /* OUT: Ending offset of token */
  int *piPosition                     /* OUT: Position integer of token */
){
  porter_tokenizer_cursor *c = (porter_tokenizer_cursor *) pCursor;
  const char *z = c->zInput;

  while( c->iOffset<c->nInput ){
    int iStartOffset, ch;

    /* Scan past delimiter characters */
    while( c->iOffset<c->nInput && isDelim(z[c->iOffset]) ){
      c->iOffset++;
    }

    /* Count non-delimiter characters. */
    iStartOffset = c->iOffset;
    while( c->iOffset<c->nInput && !isDelim(z[c->iOffset]) ){
      c->iOffset++;
    }

    if( c->iOffset>iStartOffset ){
      int n = c->iOffset-iStartOffset;

      const char *zIn = &z[iStartOffset];
      //printf("%s \n", zIn);

      bool unicode = isUnicode(zIn, n);

//      int minLength = unicode ? 2 : 1;

      //Можно еще проверить на stop-words.
      //Вообще эта проверка необязательна. Алгоритм по умолчанию не использовал ни ограничения ни стоп слова
//      if (n <= minLength) {
//          //printf("skipped \n");
//    	  continue;
//      }

      if( n>=c->nAllocated ){
        char *pNew;
        c->nAllocated = n+20;
        pNew = (char*) bx_unicode_sqlite3_realloc(c->zToken, c->nAllocated);
        if( !pNew ) return SQLITE_NOMEM;
        c->zToken = pNew;
      }

      if (unicode) {
    	  porter_stemmer_unicode(zIn, n, c->zToken, pnBytes);
      } else {
    	  porter_stemmer(zIn, n, c->zToken, pnBytes);
      }

      //printf("%d \n", *pnBytes);

      *pzToken = c->zToken;
      *piStartOffset = iStartOffset;
      *piEndOffset = c->iOffset;
      *piPosition = c->iToken++;
      return SQLITE_OK;
    }
  }
  return SQLITE_DONE;
}

/*
** The set of routines that implement the porter-stemmer tokenizer
*/
static const bx_unicode_sqlite3_tokenizer_module porterTokenizerModule1 = {
  0,
  porterCreate,
  porterDestroy,
  porterOpen1,
  porterClose,
  porterNext1,
};

/*
** Allocate a new porter tokenizer.  Return a pointer to the new
** tokenizer in *ppModule
*/
void bx_unicode_sqlite3Fts3PorterTokenizerModule1(
  bx_unicode_sqlite3_tokenizer_module const**ppModule
){
  *ppModule = &porterTokenizerModule1;
}
