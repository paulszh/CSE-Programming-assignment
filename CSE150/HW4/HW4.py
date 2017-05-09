import collections
import math
import matplotlib.pyplot as plt
import numpy as np

word_dict = {}
word_dict_biagram = {}	#used for Part b
word_pair_biagram = {}	#used for Part c to store all pairs of words as keys and their bigram probability as value
word_idx = []	# the list of words, the idx + 1 indicates the position of this word in teh vocab.txt
word_frequency = []	# the list of the frequency corresponding to the word_idx
word_after_freqency = [] # store the total number words followed by a word
word_to_idx = {} # inverse mapping the word name back to idx, key is a string, value is integer number
count = 0
idx = 0;
ONE = 0;

word_count = 1
with open ('vocab.txt') as f1, open ('unigram.txt') as f2:
	for k, v in zip(f1,f2):
		word_dict[k.strip()] = int(v.strip())
		word_to_idx[k.strip()] = word_count
		word_count+=1
		count+=int(v)
		word_idx.append(k.strip())
		word_frequency.append(int(0))
		word_after_freqency.append(int(0))


print(count)

for i in range (0,len(word_idx)):
	if(word_idx[i] == 'ONE'):
		print(i+1)
		idx = i+1

#Part(a)

for k,v in word_dict.items():
		word_dict[k] = v/float(count)

#print the 10 words start with M
for k,v in word_dict.items():
	if(k[0] == 'M'):
		print ("{:10}\t{:5e}".format(k,v))
		
#Part(b)
b_count = 0;
with open ('bigram.txt') as f3:
	for line in f3: 
		b_data = line.split()
		if(int(b_data[0]) == idx):
			b_count += int(b_data[2])
			word_frequency[int(b_data[1])-1] = int(b_data[2])
			

print (b_count,"\n")
#print (word_idx)		
#print (word_frequency)
word_dict_biagram = dict(zip(word_idx,word_frequency))

for k,v in word_dict_biagram.items():
		word_dict_biagram[k] = v/float(b_count)
		
#Sort by frequency
for word_pair in sorted(word_dict_biagram.items(), key=lambda x: x[1],reverse=True)[:10]:
#	print (word_pair)
	print ("{:10} {:>5e}".format(word_pair[0],word_pair[1]))
	
#Part(c)
sentence = '<s> THE MARKET FELL BY ONE HUNDRED POINTS LAST WEEK.'
sentence_list = sentence.replace('.',' ').split()
print ("\n",sentence_list)

#Unigram probability: 
uni_prob = 1.0;


#print (sentence_list[0])
for i in range (1,len(sentence_list)):
	uni_prob = uni_prob * float(word_dict[sentence_list[i]])
	
print ("unigram probability:",	"{:.5f}".format(math.log(uni_prob)))

b_count = 0
w_count = 1
with open ('bigram.txt') as f3:
	for line in f3: 
		b_data = line.split()
		# Tuple structure (word idx(int), word name(string), the word followed words(string))		
		temp = (int(b_data[0]),word_idx[int(b_data[0])-1], word_idx[int(b_data[1])-1]) 
		word_pair_biagram[temp] = int(b_data[2])
		word_after_freqency[int(b_data[0])-1] += int(b_data[2])
	
for k, v in word_pair_biagram.items():
	word_pair_biagram[k] = float(word_pair_biagram[k]/word_after_freqency[int(k[0])-1])
	
	
#print(word_pair_biagram[(word_to_idx['ONE'],'ONE','HUNDRED')])	
#print(word_pair_biagram[(word_to_idx['ONE'],'ONE','OF')])	
def calculate_bigram_prob(sentence_list):
	bigram_prob = 1.0
	for i in range (0,len(sentence_list)-1):
		if((word_to_idx[sentence_list[i]],sentence_list[i],sentence_list[i+1]) in word_pair_biagram):
			bigram_prob *= word_pair_biagram[(word_to_idx[sentence_list[i]],sentence_list[i],sentence_list[i+1])]
		else:
			bigram_prob = bigram_prob * 0 
			print("The following patterns are not observed in training set:", sentence_list[i],sentence_list[i+1])
	if(bigram_prob > 0):
		print("bigram probability:", "{:.5f}".format(math.log(bigram_prob)))
	else:
		print("bigram probability:", float("-inf"))
	


calculate_bigram_prob(sentence_list)

#Part d: 
del sentence_list[:];
uni_prob = 1.0
sentence = "<s> THE FOURTEEN OFFICIALS SOLD FIRE INSURANCE."
sentence_list = sentence.replace('.',' ').split()
for i in range (1,len(sentence_list)):
	uni_prob = uni_prob * float(word_dict[sentence_list[i]])

print ("")
print ("unigram probability:","{:.5f}".format(math.log(uni_prob)))

calculate_bigram_prob(sentence_list)


def get_bigram_prob(i):
	if((word_to_idx[sentence_list[i]],sentence_list[i],sentence_list[i+1]) in word_pair_biagram):
		return word_pair_biagram[(word_to_idx[sentence_list[i]],sentence_list[i],sentence_list[i+1])]
	else:
		return 0.0

l_step = np.linspace(0,1,1000,False)
plot_y = []
prob_dic = {}

for l in l_step:
	temp = 0.0
	for i in range(0,len(sentence_list)-1):
		temp += math.log((1-l)*float(word_dict[sentence_list[i+1]]) + l*get_bigram_prob(i))
	
	prob_dic[l] = temp
	plot_y.append(temp)

for word_pair in sorted(prob_dic.items(), key=lambda x: x[1],reverse=True)[:1]:
	maximum = word_pair


fig = plt.figure()
ax = fig.add_subplot(111)
ax.scatter(maximum[0],maximum[1])
#max_label = 
ax.plot(l_step, plot_y,'-g')
ax.annotate('({:.2f}, {:.2f})'.format(maximum[0], maximum[1]), xy=(maximum[0], maximum[1]), xytext=(maximum[0], maximum[1]))
plt.xlabel("lambda")
plt.ylabel("log-likelihood")
plt.show()





#print ("Starting calculating biagram probability")
#print(word_pair_biagram[(word_to_idx['<s>'],'<s>','THE')])	
#print(word_pair_biagram[(word_to_idx['THE'],'THE','MARKET')])
#print(word_pair_biagram[(word_to_idx['MARKET'],'MARKET','FELL')])		
#print(word_pair_biagram[(word_to_idx['FELL'],'FELL','BY')])
#print(word_pair_biagram[(word_to_idx['BY'],'BY','ONE')])
#print(word_pair_biagram[(word_to_idx['ONE'],'ONE','HUNDRED')])
#print(word_pair_biagram[(word_to_idx['HUNDRED'],'HUNDRED','POINTS')])
#print(word_pair_biagram[(word_to_idx['POINTS'],'POINTS','LAST')])
#print(word_pair_biagram[(word_to_idx['LAST'],'LAST','WEEK')])

		


		

