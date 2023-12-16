#include <vector>
#include <algorithm>
#include <iostream>
#include <sstream>
#include <string>
#include <utility>
#include <fstream>
#include <thrust/sort.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <fstream>


typedef struct {
  unsigned int term;
  unsigned int doc;
  unsigned int count;
} triple;


int main(int argc, char **argv) {
  if(argc != 2) {
    std::cout << "Usage: " << argv[0] << std::endl;
    return;
  }

  std::ifstream triples_file(argv[1]);
  thrust::host_vector<triple> triples;

  if(!triples_file.is_open()) {
    std::cout << argv[1] << " is an invalid file" << std::endl;
    return;
  }
  
  std::string line;

  while(std::getline(triples_file, line)) {
    std::istringstream string_stream(line);
    std::string current_value;
    std::vector<unsigned int> current_triple;
    
    while(std::getline(string_stream, current_value, ',')) {
      current_triple.push_back(std::atoi(current_value.c_str()));
    }

    if(current_triple.size() != 3) {
      std::cout << "invalid length triple, ignoring" << std::endl;

      continue;
    }

    triples.push_back(triple({current_triple[0], current_triple[1], current_triple[2]}));
  }

  size_t offset = (triples.size() * sizeof(triple));
  thrust::device_vector<triple> d_triples = triples;
  thrust::sort(d_triples.begin(), d_triples.end(), []__host__ __device__(triple a, triple b){
    return a.term == b.term ? a.doc < b.doc : a.term < b.term;
  });

  thrust::copy(d_triples.begin(), d_triples.end(), triples.begin());

  std::ofstream myfile ("./cuda_index.txt");
  for (int i = 0; i < triples.size(); i++) {
    myfile << triples[i].term << "," << triples[i].doc << "," << triples[i].count << std::endl;
  }

  return;
}
