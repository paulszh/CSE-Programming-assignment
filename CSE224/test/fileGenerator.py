import hashlib
import os
import sys
import random

def decision(probability):
    return random.random() < probability

def generateFileWithLessBlock(filename, default_block_size=4096):
    if not os.path.exists("./input/" + filename):
        print ("File does exist")
    
    input = open("./input/" + filename, 'rb')
    output_file = open("./output/" + filename, 'wb')

    filesize = os.path.getsize("./input/" + filename)
    blocknum = 0
    print (filesize)
    
    while (True):
        block_size = default_block_size if filesize > default_block_size else filesize
        if (decision(0.5)):
            chunk = input.read(block_size)
        else:
            print ("chunk set to zero: " + str(blocknum))
            chunk = bytes(block_size)
        
        output_file.write(chunk)
        filesize -= block_size
        blocknum += 1
        if filesize == 0:
            break
    print("blocknum :", blocknum) 
    input.close()
    output_file.close()		


if __name__ == '__main__':
    
    filename = sys.argv[1]
    generateFileWithLessBlock(filename)

    

        
