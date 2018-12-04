import re
"Miscellaneous functions to practice Python" 
class Failure(Exception):
    """Failure exception"""
    def __init__(self,value):
        self.value=value
    def __str__(self):
        return repr(self.value)

# Problem 1

# data type functions

def closest_to(l,v):
    """Return the element of the list l closest in value to v.  In the case of
       a tie, the first such element is returned.  If l is empty, None is returned."""
    if not l or len(l) == 0:
        return None

    diff = abs(v-l[0])
    idx = 0

    for i in range(1,len(l)):
        if abs(v-l[i]) < diff:
            diff = abs(v-l[i])
            idx = i

    return l[idx] 

def make_dict(keys,values):
    """Return a dictionary pairing corresponding keys to values."""
    return dict(zip(keys, values))
   
# file IO functions
def word_count(fn):
    """
    Open the file fn and return a dictionary mapping words to the number
    of times they occur in the file.  A word is defined as a sequence of
    alphanumeric characters and _.  All spaces and punctuation are ignored.
    Words are returned in lower case
    """
    pattern = re.compile('[A-Za-z0-9_]+')
    result = dict()
    words = ""
    with open (fn, 'r') as f:
        for w in f.read().lower():
            if pattern.match(w):
                words += w
            else:
                words += ' '
    
    for word in words.split():
        if word in result:
            result[word] += 1
        else:
            result[word] = 1

    print(len(result))
    return result


                    
                  
                
                








