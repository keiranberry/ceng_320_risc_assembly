#ifndef __QUEUE__H__
#define __QUEUE__H__
#include <iostream>
using namespace std;
const int MAX_QUEUE_SIZE = 52;


class queue
{
   private:
      int array[MAX_QUEUE_SIZE];
      int frontindex;
      int endindex;
      int nitems;
   public:
      queue();
      ~queue();

      int enque(int item);
      int deque(int &item);
      int front(int &item);
      int isempty();
      int isfull();
      int getcount();
      void print();
};

#endif
