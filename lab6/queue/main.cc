#include <iostream>
#include <stdlib.h>
#include <queue.h>

using namespace std;


int main()
{
  int i,rnum;
  queue q;
  
  srand(time(NULL));

  for(i=1;i<=100;i++)
    {
      //rnum=rand();
      rnum = i;
      q.enque(rnum);
      if(!(i%10))
	{
	  cout<<"Current queue:\n";
	  while(!q.isempty())
	    cout << q.deque(rnum) << endl;
	}
    }

  
  return 0;
}
