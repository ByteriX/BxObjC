//
//  bx_unicode_sqlite3_fts_extension.c
//  FullTextSearch
//
//  Created by Balalaev Sergey on 4/1/13.
//  Copyright (c) 2013 Balalaev Sergey. All rights reserved.
//

#include <stdio.h>
#import "bx_unicode_sqlite3.h"

/*
 ** Пример пользовательской функции SQLite, использующей matchinfo() для
 ** вычисления релевантности записей в таблице FTS. Функция возвращает оценку
 ** релевантности (действительное число, равное или большее нуля). Большее
 ** значение оценки соответствует большей релевантности документа.
 **
 ** Общая релевантность возвращается как сумма релевантностей значений отдельных
 ** столбцов таблицы FTS. Релевантность значения в столбце является суммой
 ** релевантностей этого значения для каждой отдельной фразы FTS-запроса, которые
 ** вычисляются следующим образом:
 **
 **   (<число вхождений>/<общее число вхождений>)*<вес столбца>
 **
 ** где <число вхождений> - это число, сколько раз встречается фраза в
 ** значении столбца текущей строки; <общее число вхождений> - это число,
 ** сколько раз встречается фраза в значениях столбца для всех строк в таблице
 ** FTS; <вес столбца> - это весовой фактор, указываемый для каждого
 ** столбца при вызове функции (смотрите ниже).
 **
 ** Первый аргумент этой функции должен быть значением, которое возвращает
 ** FTS-функция matchinfo(). После этого следует задать по одному числовому
 ** аргументу на каждый столбец таблицы FTS, в которых указать относительные веса
 ** соответствующих столбцов. Пример:
 **
 **     CREATE VIRTUAL TABLE documents USING fts3(title, content)
 **
 ** Следующий запрос выдаст docid-ы документов, которые соответствуют
 ** полнотекстовому запросу <query>, отсортировав по убыванию
 ** релевантности. При вычислении релевантности слова запроса, содержащиеся в
 ** столбце 'title', добавляют документу вдвое больше веса, чем слова,
 ** содержащиеся в столбце 'content'.
 **
 **     SELECT docid FROM documents
 **     WHERE documents MATCH <query>
 **     ORDER BY rank(matchinfo(documents), 1.0, 0.5) DESC
 */
static void rankfunc(bx_unicode_sqlite3_context *pCtx, int nVal, bx_unicode_sqlite3_value **apVal){
    unsigned int *aMatchinfo;             /* Значение, возвращаемое matchinfo() */
    int nCol;                    /* Число столбцов в таблице */
    int nPhrase;                 /* Число фраз в запросе */
    int iPhrase;                 /* Текущая фраза */
    double score = 0.0;          /* Возвращаемое значение */
    
    //assert( sizeof(int)==4 );
    
    /* Проверяем корректность числа аргументов, переданных в данную функцию.
     ** Если оно неверно, переходим к метке wrong_number_args. Задаем aMatchinfo
     ** как массив беззнаковых целых чисел, возвращаемый FTS-функцией matchinfo.
     ** Задаем nPhrase как число фраз, переданных пользователем в полнотекстовом
     ** запросе, а nCol задаем как число столбцов в таблице.
     */
    if( nVal<1 ) goto wrong_number_args;
    aMatchinfo = (unsigned int *)bx_unicode_sqlite3_value_blob(apVal[0]);
    nPhrase = aMatchinfo[0];
    nCol = aMatchinfo[1];
    if( nVal!=(1+nCol) ) goto wrong_number_args;
    
    /* Итерируем по всем фразам пользовательского запроса. */
    for(iPhrase=0; iPhrase<nPhrase; iPhrase++){
        int iCol;                     /* Текущий столбец */
        
        /* Новая итерация по каждому столбцу из пользовательского запроса. Для
         ** каждого столбца оценка релевантности инкрементируется на следующее
         ** значение:
         **
         ** (<число вхождений>/<общее число вхождений>)*<вес столбца>
         **
         ** aPhraseinfo[] позиционируется на начало нужных данных во фразе iPhrase.
         ** Таким образом, число вхождений и общее число вхождений могут быть найдены
         ** для каждого столбца как aPhraseinfo[iCol*3] и aPhraseinfo[iCol*3+1],
         ** соответственно.
         */
        unsigned int *aPhraseinfo = &aMatchinfo[2 + iPhrase*nCol*3];
        for(iCol=0; iCol<nCol; iCol++){
            int nHitCount = aPhraseinfo[3*iCol];
            int nGlobalHitCount = aPhraseinfo[3*iCol+1];
            double weight = bx_unicode_sqlite3_value_double(apVal[iCol+1]);
            if( nHitCount>0 ){
                score += ((double)nHitCount / (double)nGlobalHitCount) * weight;
            }
        }
    }
    
    bx_unicode_sqlite3_result_double(pCtx, score);
    return;
    
    /*
     ** Переходим сюда, если в функцию передано неверное количество аргументов.
     */
wrong_number_args:
    bx_unicode_sqlite3_result_error(pCtx, "wrong number of arguments to function rank()", -1);
}

void bx_unicode_sqlite3_fts_extension_init(bx_unicode_sqlite3 *db)
{
    bx_unicode_sqlite3_create_function(db, "rankMy", -1, SQLITE_UTF8, 0, &rankfunc, 0, 0 );
}

void bx_unicode_sqlite3_fts_extension_load()
{
    bx_unicode_sqlite3_auto_extension((void*)bx_unicode_sqlite3_fts_extension_init);
}