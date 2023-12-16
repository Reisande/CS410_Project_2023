import sys, os
from typing import List

def generate_doc_files(file: str) -> List[str]:
    return_list = set()
    
    if not os.path.exists(file):
        print(file + " does not exist")
        
        return return_list

    # read a file of a bunch of triples
    # triples stored as <term id, doc id, count>
    triples_file = open(file, 'r')
    lines = triples_file.readlines()

    # sort triples by doc id
    # write all triples of the same doc type into a file
    for line in lines:
        triple = [x for x in line.split(',') if x.strip().isdigit()]

        if(len(triple) != 3):
            print("invalid triple: ")
            print(triple)
            
            continue

        file_name = "./docs/" + triple[1]

        if not os.path.exists(file_name):
            temp_file = open(file_name, "x")
            temp_file.close()


        return_list.add(file_name)

        write_file = open(file_name, "a")

        write_file.write(line)
        
        write_file.close()

    triples_file.close()
    
    return list(return_list)

# sort by term id
# simply append the triples as we see them into the next file
def generate_term_files(doc_files: List[str]) -> List[str]:
    return_list = set()

    sorted_docs = sorted(doc_files, key=lambda x: int(x.split("/")[-1]))
    for file in sorted_docs:
        doc_file = open(file, 'r')
        lines = doc_file.readlines()

        # sort triples by doc id
        # write all triples of the same doc type into a file
        for line in lines:
            triple = [x for x in line.split(',') if x.strip().isdigit()]

            if(len(triple) != 3):
                print("invalid triple: ")
                print(triple)
            
                continue

            file_name = "./terms/" + triple[0]

            if not os.path.exists(file_name):
                temp_file = open(file_name, "x")
                temp_file.close()
            
            return_list.add(file_name)

            write_file = open(file_name, "a")

            write_file.write(line)
        
            write_file.close()

    return list(return_list)

    
# combine all Lists of term ids into a final List 
def merge_indices(term_files: List[str]):
    merge_file = open("./index.txt", "a+")

    sorted_terms = sorted(term_files, key=lambda x: int(x.split("/")[-1]))

    for term in sorted_terms:
        temp_file = open(term, "r")

        lines = temp_file.readlines()

        merge_file.writelines(lines)

        temp_file.close()

    merge_file.close()

if __name__ == "__main__":
    if not os.path.exists("./docs"):
         os.mkdir("./docs")

    if not os.path.exists("./terms"):
         os.mkdir("./terms")

    if not os.path.exists("./index.txt"):
         write_file = open("./index.txt", "x")
    
    if len(sys.argv) != 2:
        print("Usage: python3 " + str(sys.argv[0]) + " <file>")
        
    else:
        doc_files = generate_doc_files(sys.argv[1])

        term_files = generate_term_files(doc_files)
        
        merge_indices(term_files)
        print("Created inverted index")

