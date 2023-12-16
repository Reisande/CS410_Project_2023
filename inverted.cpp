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


int main(int argc, char **argv) {
  if(argc != 2) {
    std::cout << "Usage: " << argv[0] << " <input_file> " << std::endl;
    return -1;
  }

  std::string input_file(argv[1]);
  std::ifstream triples_file(input_file, std::ios::binary);
  std::vector<triple> triples;

  if(!triples_file.is_open()) {
    std::cout << argv[1] << " is an invalid file" << std::endl;
    return -1;
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

  std::sort(triples.begin(), triples.end(), [](triple a, triple b)
  {
    return a.term == b.term ? a.doc < b.doc : a.term < b.term;
  });
  
  std::ofstream myfile ("./cpp_index.txt");
  for (int i = 0; i < triples.size(); i++) {
    myfile << triples[i].term << "," << triples[i].doc << "," << triples[i].count << std::endl;
  }

  return 0;
}
