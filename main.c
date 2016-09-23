#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#define maxTimeHeight 10000
#define number 12  // input 12 data
#define t 3  // 3 minutes timer
#define outputName "result.txt"
#define averageGap 25

int OD_time[maxTimeHeight];
int OD[maxTimeHeight][number];
int Speed_time[maxTimeHeight];
int Speed[maxTimeHeight][number];
int avg_time[maxTimeHeight];
int avg[maxTimeHeight][number];
int t0[number];
double Vmax_k[number];
double R[number];
int timeHeight;
double M, S;
int toNum(char *);
int findAvgMax(int,int);
	
int main(){
	// load data
	char file[50] = "./data/A.csv", c;
	printf("Please Input file name (A~H)? ");
	scanf("%c",&c); file[7]=c;
	FILE *pFile = fopen(file,"r");
	if(pFile==NULL) {
		printf("No such file\n");
		exit(0);
	}
	// input data
	int i=0,j=0,k;
	char str[10000];
	while(fgets(str,10000,pFile)!=NULL) {
		char* pch = strtok(str,",\n");
		OD_time[i] = toNum(pch);
		pch = strtok(NULL, ",\n");
		while(pch!=NULL) {
			OD[i][j++] = toNum(pch);
			pch = strtok(NULL, ",\n");
		} 
		++i;
	}
	timeHeight = i;
	
	// calculate speed
	for(j=0; j<number; ++j)
		for(i=0; i<timeHeight-1; ++i){
			Speed_time[i] = OD_time[i+1];
			Speed[i][j] = OD[i+1][j]-OD[i][j];
		}
	
	// run average every averageGap
	for(k=0; k<number; ++k)
		for(i=0; i<timeHeight-1-averageGap; ++i) {
			avg_time[i] = Speed_time[i];
			int sum=0;
			for(j=0; j<averageGap-1; ++j)
				sum += Speed[i+j][k];
			avg[i][k]=sum/averageGap;
		}
	
	// Large counting number
	int l=0;
	// R counting number
	int m=1;
	
	// Analysis data
	double Vmax, x;
	for(k=1; k<number; ++k) {
		int tmp = timeHeight-1-averageGap;
		for(i=1; i<tmp; ++i)
			if(avg[i][k]==findAvgMax(k,tmp))
				t0[k]=avg_time[i];
		Vmax = findAvgMax(k,tmp)/3.0;
		Vmax_k[k]=Vmax;
		if(Vmax>=4.6) {
			++l;
			x=-1;
		} else {
			// TODO: function may be changed
			x=(18.6542*Vmax-38.2493)/(5.07-Vmax);
		}
		if(x>0)
			R[m++]=pow(x,(double)1/2.0183);
	}
	
	if(m<=number/2) {
		if(l>number/2)
			printf("The concentration is too high!!\n");
		else
			printf("The concentration is lower than 0.1\n");
	} else {
		// TODO: histogram
		
		// find mean
		M=0.;
		for(i=0; i<m; ++i) M+=R[i];
		M/=(double)m;
		
		// find standard deviation
		S=0.;
		for(i=0; i<m; ++i) S+=(R[i]-M)*(R[i]-M);
		S=sqrt(S/(double)(m-1));
	
		printf("The mean value is %lf\nStandard deviation is %lf\n",M,S);
	}
	return 0;
}

int toNum(char *s) {
	int len = strlen(s);
	int i, tmp = 0;
	for(i=0; i<len; ++i) tmp=tmp*10+s[i]-'0';
	return tmp;
}

int findAvgMax(int k, int len){
	int i, max=0;
	for(i=0; i<len; ++i) if(avg[i][k]>max) max=avg[i][k];
	return max;
}

