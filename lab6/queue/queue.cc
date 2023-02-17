#include "queue.h"


queue::queue()
{
   endindex = 0;
   frontindex = 0;
   nitems = 0;
}

queue::~queue()
{

}

/*int queue::enque(int item)
{
   if(isfull())
      return 0;

   array[endindex] = item;
   if(++endindex >= MAX_QUEUE_SIZE)
     endindex = 0;
   nitems++;
   return 1;
}*/

/*int queue::deque(int &item)
{
   if(isempty())
      return 0;

   item = array[frontindex];
   if(++frontindex >= MAX_QUEUE_SIZE)
     frontindex = 0;
   nitems--;
   return item;
}*/

int queue::front(int &item)
{
   if(isempty())
      return 0;

   item = array[frontindex];
   return item;
}

int queue::isempty()
{
   if(nitems == 0)
      return 1;
   return 0;
}

int queue::isfull()
{
   if(nitems == MAX_QUEUE_SIZE)
      return 1;
   return 0;
}

int queue::getcount()
{
  return nitems;
}

void queue::print()
{
   int i;

   for(i=frontindex; i<endindex; i++)
      cout << array[i] << " ";
   cout << endl;
}
