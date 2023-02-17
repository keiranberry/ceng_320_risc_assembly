#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_DECIMAL_DIGITS 16
/* Multiply an unpacked BCD number by 2. Return 1 if there is a
   carry out of the most signignificant digit. 0 otherwise. The
   resulting number is returned in n1.
 */
int base10double( char n1[MAX_DECIMAL_DIGITS] )
{
	long i, carry = 0;
	for( i = 0; i < MAX_DECIMAL_DIGITS; i++ )
	{
		n1[i] += ( n1[i] + carry );
		if( n1[i] > 9 )
		{
			n1[i] -= 10;
			carry = 1;
		}
		else
			carry = 0;
	}
	return carry;
}

/* Convert a string into a signed fixed-point binary
   representation with up to 32 bits of fractional part.
 */
long strtoSfixed( char *s, long frac_bits )
{
	char *point = s;
	unsigned long value;
	long i, negative = 0;
	char digits[MAX_DECIMAL_DIGITS];
	/* get the integer portion */
	if( *s == '-' )
	{
		negative = 1;
		s++;
	}
	value = atoi( s );
	/* find the decimal point */
	while( ( *point != '.' ) && ( *point != 0 ) )
		point++;
	/* if there is nothing after the decimal point, or there is
	   not a decimal point, then shift and return what we already
	   have */
	if( ( *point == 0 ) || ( *( point + 1 ) == 0 ) )
	{
		if( negative )
			value = -value;
		return value << frac_bits;
	}
	++point;
	/* convert the remaining part into an unpacked BCD number. */
	for( i = ( MAX_DECIMAL_DIGITS - 1 ); i >= 0; i-- )
	{
		if( *point == 0 )
			digits[i] = 0;
		else
		{
			digits[i] = *point - '0';
			++point;
		}
	}
	/* convert the unpacked BCD number into binary */
	while( frac_bits > 0 )
	{
		value <<= 1;
		if( base10double( digits ) )
			value |= 1;
		frac_bits--;
	}
	/* negate if there was a leading '-' */
	if( negative )
		value = -value;
	return value;
}

/* Print an unsigned fixed point number with the given number of
   bits in the fractional part. NOTE: frac_bits must be between
   0 and 28 for this function to work properly.
 */
void printS( long num, long frac_bits )
{
	//Typecast on 1 is required so that upper 32 bits of an x register are not zeroed out
	unsigned long mask = ( ( long )1 << frac_bits ) - ( long )1;
	unsigned long fracpart;
	if( num < 0 )
	{
		printf( "-" );
		num = -num;
	}
	/* Print the integer part ( with the sign, if it is negative ) */
	printf( "%ld.", num >> frac_bits );
	/* Remove the integer part ( with the sign, if it is negative ) */
	fracpart = num & mask;
	/* Print all of the digits in the fractional part. The post -
	   test loop ensures that the first digit is printed, even if
	   it is zero. */

  for(int i = 0; i < 4; i++)
  {
    fracpart *= 10;
		printf( "%lu", fracpart >> frac_bits );
		fracpart &= mask;
  }
}
