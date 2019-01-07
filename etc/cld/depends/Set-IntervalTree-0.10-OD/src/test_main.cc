#include <cstdio>
#include <cmath>
#include <ctime>
#include <cstdlib>
#include <vector>
#include <string>
#include <iostream>

#include "interval_tree.h"

int main(int argc, char *argv[])
{
  int low;
  int high;

  IntervalTree<int> intervalTree;
  int count = 1000;
  int domain = 1000;
  std::cout << "Inserting " << count << 
    " nodes into [0," << domain << "]." << std::endl;

  srand(time(NULL));
  for(int i=0; i<count; i++) {
    low = rand() % domain;
    high = (rand() % (domain-low)) + low;
    
    intervalTree.insert(i, low, high);
    // std::cout << "Added: [" << low << "," << high << "]" << std::endl;
    if(!(i%25000)){std::cout << "*";fflush(0);}
  }
  std::cout << std::endl;
  
  low = domain * 0.4f;
  high = domain * 0.5f;//10% of the domain is being tested
  std::cout << "Enumerating intervals between " << low 
      << " and " << high << std::endl;
  std::vector<int> results = intervalTree.fetch(low,high);
  std::cout << results.size() << " intervals found." << std::endl;

  for(int i=0; i<results.size(); i++) {
      std::cout << results[i] << ",";
  }
  std::cout << std::endl;
  return 0;
}

