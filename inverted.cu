#include <vector>
#include <algorithm>
#include <iostream>
#include <sstream>
#include <string>
#include <utility>
#include <fstream>

typedef struct {
  unsigned int term;
  unsigned int doc;
  unsigned int count;
} triple;

__global__ void
parallel_sort(triple *index_array, size_t array_size)
{
  // implementing simple odd-even transposition mergesort
  int sort_index = threadIdx.x * 2;
  if (sort_index >= array_size) {
    return;
  }

  for (int i = 0; i < array_size; i++) {
    auto current_index = sort_index + (i % 2);

    auto a = index_array[i];
    auto b = index_array[i + 1];
    if (current_index + 1 < array_size &&
        ((a.term == b.term && a.doc < b.doc)
         || a.term < b.term)) {
      auto temp = b;
      b = a;
      a = temp;
    }
     
    __syncthreads();
  }

  printf("%d %d %d; ", index_array[sort_index].term, index_array[sort_index].doc, index_array[sort_index].index);
}


int main(int argc, char **argv) {
  if(argc != 2) {
    std::cout << "Usage: " << argv[0] << std::endl;
    return;
  }

  std::ifstream triples_file(argv[1]);
  std::vector<triple> triples;

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

    triples.emplace_back(triple({current_triple[0], current_triple[1], current_triple[2]}));
  }

  triple* d_triples;
  cudaMalloc(&d_triples, triples.size() * sizeof(triple));
  cudaMemcpy(d_triples, triples.data(), triples.size() * sizeof(triple), cudaMemcpyHostToDevice);
  
  parallel_sort<<<1, triples.size() / 2>>>(triples.data(), triples.size());

  triple *out_triples = (triple *)malloc(sizeof(triple) * triples.size());
  cudaMemcpy(out_triples, d_triples, triples.size() * sizeof(triple), cudaMemcpyDeviceToHost);

  for (auto &i: triples) {
    std::cout << i.term << " " << i.doc << " " << i.count << std::endl;
  }

  return;
}