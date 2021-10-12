/*
 * Redistribution and use in source and binary forms, with
 * or without modification, are permitted provided that the
 * following conditions are met:
 *
 * 1. Redistributions of source code must retain this list
 *    of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce this
 *    list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
#include <config.h>
#include <string.h>
#include <stddef.h>
#include <stdlib.h>
#include "thcrypt105.h"
#include "rng_mt.h"

/* These function can be used for encrypting and decrypting. */
void
th_crypt105_list(
    unsigned char* data,
    unsigned int size,
    unsigned char key,
    unsigned char step1,
    unsigned char step2)
{
    unsigned int i;
    rng_mt* rng = rng_mt_init(6+size);
    for (i = 0; i < size; i++) {
        int ti = i-1;
        data[i] ^= (key + i*step1 + (ti*ti+ti)/2 * step2);
        data[i] ^= (rng_mt_nextint(rng) & 0xff);
    }
    rng_mt_free(rng);
}

void
th_crypt105_file(
    unsigned char* data,
    unsigned int size,
    unsigned int offset)
{
    unsigned char key = ((offset>>1) | 0x23) & 0xff;
    unsigned int i;
    for (i = 0; i < size; i++) {
        data[i] ^= key;
    }
}
