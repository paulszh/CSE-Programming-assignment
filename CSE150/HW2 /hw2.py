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

def prob_l_given_w(l,word):
	for i in range len(word)
		if l = word[i]:
			return 1.0
	return 0.0


def next_guess(correct_guess, incorrect_guess)
	guessed = []
	for l in correct_guess:
		if l != '-':
			guessed.append(l)

	for l in incorrect_guess:
		guessed.append(l)

	guessed = list(set(guessed))