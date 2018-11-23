#include<stdlib.h>
#include<iostream>
#include<time.h>
using namespace std;
double fifo(unsigned int* dataset, int dataNum, int slotNum);
double LRU(unsigned int* dataset, int dataNum, int slotNum);
void user_input(void);
void data_input(unsigned int *dataset,int dataNum,int slotNum);
double random(unsigned int* dataset, int dataNum, int slotNum);
int main(void) {

	user_input();
	return 0;
}
void user_input(void) {
	int slotNum = 0;
	int dataNum = 0;
	unsigned int *dataset;
	while (1) {
		cout << "총 몇개의 슬롯으로 캐쉬를 구성하겠습니까? (한 블럭의 크기는 32bit 입니다.) : ";
		cin >> slotNum;
		if ((cin.fail()) || (slotNum < 0)) {
			cout << endl << "슬롯의 개수는 양수이며 정수이고, 2,147,483,647개 이하여야 합니다." << endl;
			cin.clear();
			cin.ignore(256, '\n');
			continue;
		}
		break;
	}
	while (1) {
		cout << "총 몇개의 데이터로 데이터 셋을 구성하겠습니까?  : ";
		cin >> dataNum;
		if ((cin.fail) () || (dataNum < 0)) {
			cout << endl << "데이터의 개수는 양수이며 정수이고, 2,147,483,647개 이하여야 합니다." << endl;
			cin.clear();
			cin.ignore(256, '\n');
			continue;
		}
		break;
	}
	dataset = (unsigned int*)malloc(sizeof(unsigned int)*dataNum);
	data_input(dataset, dataNum,slotNum);
	cout << endl << "FIFO :" << fifo(dataset, dataNum, slotNum) << endl;
	cout << "LRU :"<<LRU(dataset, dataNum, slotNum);
	cout << "RANDOM :"<<random(dataset, dataNum, slotNum)<<endl;

}
void data_input(unsigned int *dataset,int dataNum,int slotNum) {
	for (int i = 0; i < dataNum; i++) {
		dataset[i] = 0;
		while (1) {
			cout << "[" << i << "]번째 데이터의 값 :";
			cin >> dataset[i];
			if (cin.fail()) {
				cout << endl << "데이터의 값은 양수이며 정수이고, 2의 32승 미만이어야 합니다.(한 블럭의 크기는 32bit 입니다.)" << endl;
				cin.clear();
				cin.ignore(256, '\n');
				continue;
			}
			break;
		}
	}
}
double fifo(unsigned int* dataset, int dataNum, int slotNum)
{
	//hit ratio = cache access / total access
	double hit_ratio = 0;
	int cache_access = 0;
	int rep_index = 0;
	int* cache;
	cache = (int*)malloc(slotNum * sizeof(int));
	for (int i = 0; i < slotNum; i++)
		cache[i] = -1;
	for (int i = 0; i < dataNum; i++)
	{
		int j = 0;
		while (j < slotNum)
		{
			if (cache[j] == dataset[i])
			{
				cout << "hit cache ... " << dataset[i] << endl;
				cache_access++;
				break;
			}
			j++;
		}
		if (j == slotNum)
		{
			cache[rep_index] = dataset[i];

			if (rep_index < slotNum)
				rep_index++;
			else if (rep_index == slotNum)
				rep_index = 0;
		}
	}
	hit_ratio = ((double)cache_access / (double)dataNum) * 100.0;
	return hit_ratio;
}
double LRU(unsigned int* dataset, int dataNum, int slotNum)
{
	int *set;//세트안에 슬롯들 저장할 배열
	int hit = 0; //적중할때마다 1씩 올라가는 변수
	double hit_ratio; //적중률
	int *count; //참조 안한 횟수 count 횟수
	int already = 0; //이미 교체 또는 입력을 했는지 확인
	count = (int*)malloc(sizeof(slotNum)); //동적할당
	set = (int*)malloc(sizeof(slotNum));
	for (int i = 0; i < slotNum; i++)
	{
		set[i] = -1; //세트를 -1, count 0으로 초기화
		count[i] = 0;
	}
	for (int i = 0; i < dataNum; i++)
	{
		for (int j = 0; j < slotNum; j++) //적중할 경우
		{
			if (dataset[i] == set[j])
			{
				for (int z = 0; z < slotNum; z++) //적중한 슬롯의 count는 0 나머지는 +1
					count[z]++;
				count[j] = 0;
				hit++; //적중횟수 +1
				already = 1;
				break;
			}
		}
		if (already == 1) //다음 입력값으로 넘어간다.
		{
			already = 0;
			//for (int i = 0; i < slotNum; i++)
			//	cout << set[i];
			//cout << endl;
			continue;
		}
		for (int j = 0; j < slotNum; j++) //적중 x, 슬롯이 비어있는 경우
		{
			if (set[j] == -1)
			{
				set[j] = dataset[i]; // 슬롯 추가
				for (int z = 0; z < j; z++) //추가한 슬롯의 count는 0 나머지는 +1
					count[z]++;
				count[j] = 0;
				already = 1;
				break;
			}
		}
		if (already == 1)
		{
			already = 0;
			//for (int i = 0; i < slotNum; i++)
			//	cout << set[i];
			//cout << endl;
			continue;
		}
		int find_first = 0;//count가 가장 큰 값의 index 저장
		int find_largest = -1;//count가 가장 큰 값 저장
		for (int z = 0; z < slotNum; z++) //적중 x, 교체하는 경우
		{
			if (find_largest < count[z]) //count값이 가장 큰 index를 찾는다
			{
				find_first = z;
				find_largest = count[z];
			}
		}
		set[find_first] = dataset[i]; //해당 index를 dataset 값으로
		for (int z = 0; z < slotNum; z++) //이번에 교체한 슬롯 0 나머지 +1
			count[z]++;
		count[find_first] = 0;

		//for (int i = 0; i < slotNum; i++)
		//	cout << set[i];
		//cout << endl;
	}
	cout << endl;
	hit_ratio = (double)hit / (double)dataNum;
	return hit_ratio;
}
double random(unsigned int* dataset, int dataNum, int slotNum) {
	int hit = 0; // 적중횟수
	int miss = 0; // 미스횟수
	int *set = (int*)malloc(sizeof(int)*slotNum); //슬롯  생성
	for (int i = 0; i < slotNum; i++) {
		set[i] = -1;
	}
	srand((int)time(NULL));
	for (int i = 0; i < dataNum; i++) {
		for (int j = 0; j < slotNum; j++) {
			if (dataset[i] == set[j]) {
				hit++;
				set[j] = dataset[i];
				break;
			}
			if (j == slotNum - 1) {
				int change = rand() % slotNum;
				set[change] = dataset[i];
			}
		}
	}	
	double ratio = (double)hit/(double)dataNum*100;
	return ratio;
}