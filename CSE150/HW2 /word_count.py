#Author: Zhouhang Shao
#CSE 150 HW2 Problem3 
#April 24th 2017

word_dict = {}
count = 0
letter_pools = {'A','B','C','D','E','F','G','H','I',
					'J','K','L','M','N','O','P','Q','R',
					'S','T','U','V','W','X','Y','Z'}
	
potential_letters = {'A','B','C','D','E','F','G','H','I',
						'J','K','L','M','N','O','P','Q','R',
						'S','T','U','V','W','X','Y','Z'}

with open ('hw2_word_counts_05.txt') as datafile:
	for line in datafile:
		pair = line.split()
		word_dict[pair[0]] = int(pair[1])
		count+= int(pair[1])

print(count)
	
for k,v in word_dict.items():
	word_dict[k] = v/float(count)
	
print ('Ten most frequent word')
for word_pair in sorted(word_dict.items(), key=lambda x: x[1],reverse=True)[:10]:
	print (word_pair)
	
print ('')
print ('Ten least frequent word')
for word_pair in sorted(word_dict.items(), key=lambda x: x[1],reverse=False)[:10]:
	print (word_pair)


print(letter_pools)

def update_letter_pool(guessed_letters,potential_letters):
	for letter in guessed_letters:
		if(letter != 'NULL'):
			potential_letters.remove(letter)

def e_given_w(word, correct_guess, incorrect_guess): 

	for i in range (0,len(word)):
		if correct_guess[i] == 'NULL':
			if word[i] in incorrect_guess:
				return False
			if word[i] in correct_guess:
				return False 
		else: 
			if(correct_guess[i] != word[i]):
				return False			
	return True
		
def l_given_e(l, word, correct_guess):
	for i in range (0,len(word)):
		if correct_guess[i] == 'NULL':
			if(word[i] == l):
				return True 
	return False

def next_guess (incorrect_guess, correct_guess):
	potential_letters = {'A','B','C','D','E','F','G','H','I',
							'J','K','L','M','N','O','P','Q','R',
							'S','T','U','V','W','X','Y','Z'}
	update_letter_pool(incorrect_guess,potential_letters)
	update_letter_pool(correct_guess,potential_letters)
	
	letter_prob = {}	
	for letter in potential_letters:
		letter_prob[letter] = int(1);
	
	sum_1 = 0;
	for k in word_dict:
		if e_given_w(list(k), correct_guess, incorrect_guess):
			sum_1 += word_dict[k]
	
	sum_2 = 0;
	#print (potential_letters)
	for l in potential_letters:
		for k in word_dict:
			if e_given_w(list(k), correct_guess, incorrect_guess) and l_given_e(l, list(k),correct_guess):
				sum_2 += float(word_dict[k])/sum_1
		letter_prob[l] = sum_2
		sum_2 = 0	
	
	for word_pair in sorted(letter_prob.items(), key=lambda x: x[1],reverse=True)[:1]:
		print (word_pair)	
	
# Testing the algorithm by using the last 4 results on the writeup	
correct_guess = ['NULL','NULL','NULL','NULL','NULL']
incorrect_guess = {'E','O'}
next_guess(incorrect_guess,correct_guess)

correct_guess = ['D','NULL','NULL','I','NULL']
incorrect_guess = {}
next_guess(incorrect_guess,correct_guess)

correct_guess = ['D','NULL','NULL','I','NULL']
incorrect_guess = {'A'}
next_guess(incorrect_guess,correct_guess)

correct_guess = ['NULL','U','NULL','NULL','NULL']
incorrect_guess = {'A','E','I','O','S'}
next_guess(incorrect_guess,correct_guess)

# input -----  {}
correct_guess = ['NULL','NULL','NULL','NULL','NULL']
incorrect_guess = {}
next_guess(incorrect_guess,correct_guess)

# input -----  {E,T}
correct_guess = ['NULL','NULL','NULL','NULL','NULL']
incorrect_guess = {'E','T'}
next_guess(incorrect_guess,correct_guess)

# input A---R  {}
correct_guess = ['A','NULL','NULL','NULL','R']
incorrect_guess = {}
next_guess(incorrect_guess,correct_guess)

# input A---R  {E}
correct_guess = ['A','NULL','NULL','NULL','R']
incorrect_guess = {'E'}
next_guess(incorrect_guess,correct_guess)

# input --H--  {H}
correct_guess = ['NULL','NULL','H','NULL','NULL']
incorrect_guess = {'I','M','N','T'}
next_guess(incorrect_guess,correct_guess)