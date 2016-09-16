     
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define debug
  
unsigned int x=50;
unsigned int y=50;

unsigned int m=143;
//unsigned int r = 193;
int xo=0;

unsigned int s = 0;
unsigned int c = 0;
unsigned int j = 0;

unsigned int myAdd(unsigned int a, unsigned int b)
{
    unsigned int carry = a & b;
    unsigned int result = a ^ b;
    while(carry != 0)
    {
        unsigned int shiftedcarry = carry << 1;
        carry = result & shiftedcarry;
        result ^= shiftedcarry;
    }
    return result;
}

unsigned int mytwo(unsigned int a)
{
    a=~a;
    a=myAdd(a,1);
    return a;
}

unsigned int myMult (unsigned int a, unsigned int b){
	unsigned int result = 0;
    while (b != 0)               // Iterate the loop till b == 0
    {
        if (b & 01)               // Bitwise & of the value of b with 01
        {
            result = result + a;  // Add a to result if b is odd .
        }
        a<<=1;                    // Left shifting the value contained in 'a' by 1
                                  // Multiplies a by 2 for each loop
        b>>=1;                    // Right shifting the value contained in 'b' by 1.
    }
    return result;
}

unsigned int modolo (unsigned long int t, unsigned int n, unsigned int k){
	//unsigned int k =6;
	if (n>t){
		return t;
	}
	unsigned int n2 =n;
	unsigned long int a=t;
	a = a >> k;
	
	//
	unsigned int r = 0;
	for (int i = 1; i<k; i++){
		#ifdef debug
		for (int l=14; l>=0; l--){
			if (! (a >> l & 1))
		      printf("0");
		    else
		      printf("1");
		}
		
		printf("   a = %li \n", a);
		#endif
		if((a >> k-i+2) & 1){
			
			a=myAdd(a,n);
		}
		else{
			
		a=myAdd(a,mytwo(n));			
		}
		n=n >> 1;
		//a = a >> 1;
		
	}
	#ifdef debug
	for (int l=14; l>=0; l--){
			if (! (a >> l & 1))
		      printf("0");
		    else
		      printf("1");
		}
	#endif
	if(a >> k & 1){
			a=myAdd(a,n2);
		}
		return a;
}

unsigned int blakley(void){
	unsigned r = 0;
	unsigned int k =6;
	for (unsigned int i = 0; i < k; i++){
		r=myAdd(2*r, myMult(x, ((y >> k-1-i) & 1)));
		printf("r1=%i\n", r);
		//r=modolo(r,m,8);
		r=r%m;
		printf("r2=%i\n", r);
	}
	return r;
}



unsigned int mont(unsigned int x, unsigned int y, unsigned int m){
	for (int i=0; i<6; i++) {

		if (!(x >> i & 1)){
			j=0;
			if(!((s ^ c) >> 0 & 1)) {
				
				j=0;
				printf("j=0 \n");
			}
			else{
				j=m;
				printf("j=m \n");

			}
			
		}
		else{
			if(!((s ^ c ^ y) >> 0 & 1)){
				
				j=y;
				printf("j=y \n");
			}
			else{
				//j=r;
				printf("j=r \n");
			}
		}

		printf("j=%i \n", j);
		s=myAdd(s,c);
		s=myAdd(s,j);
		c=myAdd(s,c);
		c=myAdd(c,j);
		s=s >> 1;
		c=c >> 1;
	}
	unsigned p=myAdd(s,c);
	if (p>=m){
		p=myAdd(p,-m);
	}

	return p;
}

int main(void){
	printf("mod= %i \n", modolo(3019,53, 6));
	//printf("r= %i \n", blakley());
	
	
	
  /*
  int n=3;
 

  	k = n>>1;
  	    if (k & 1)
      printf("1");
    else
      printf("0");

    k = n >> 0;
 	
    
    if (! (n >> 0 & 1))
      printf("0");
    else
      printf("1");
    
  
 */
/*
  unsigned p = 0;
  unsigned int x0=(x & 1);
  
  unsigned int xi=0;
  unsigned int p0=0;
  for (int i = 0; i<6; i++){
  	xi = ((x >> i) & 1);
  	//printf("xi=%i \n", xi);
  	p=myAdd(p,myMult(y,xi));
  	//printf("p=%i \n", p);
  	p0=(p & 1);
  	
  	p=myAdd(p,myMult(p0,m));
  	p=p >> 1;
  	printf("p=%i\n", p);
  }
  	if (p>=m){
		p=p-m;
	}
	
	//printf("p=%i \n", p);
  */

  printf("\n");

  return 0;
}


