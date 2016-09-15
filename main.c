#include "magic.h"
#include <math.h>
#include <stdio.h>


int magic(int message) {
	printf("message=%d\n",message );
	int prime1 = 7;
	int prime2 = 17;
	int n = prime1*prime2;
	float efunc = (prime1 - 1)*(prime2 - 1);

	float k=0;
	float e = 5;
	float d = 1;
	while (1) {
		k = ((d*e) - 1) / efunc;
		int temp = round(k);

			if (k - temp == 0) {
				break;
			}
			else d = d+1;
	}
	//printf("d=%.f \n", d);

	int encrypt = 0;
	encrypt = pow(message,(e));
	encrypt = encrypt % n;
	printf("magic=%d\n", encrypt);
	return encrypt;

	
}

int main(void){
	int a= magic(19);
	int temp = magic(a);
	





	return 0;



}
