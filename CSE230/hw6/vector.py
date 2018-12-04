from misc import Failure

class Vector(object):
    def __init__ (self, argument):
    	"""
    	The constructor either takes in a integer or an instance of a class derived from int, 
    	then consider this argument to be the length of the vector. If the length is negative, 
    	raise a ValueError with an appropriate message. If the argument is not considered to be 
    	the length, then if the argument is a sequence (such as a list), then initialize with 
    	vector with the length and values of the given sequence. If the argument is not used as 
    	the length of the vector and if it is not a sequence, then raise a TypeError with an 
    	appropriate message. 
    	"""
    	if isinstance (argument,int):
    		if argument < 0:
    			raise ValueError("Vector Length Cannot be Negative");
    		self.len = argument
    		self.vec = [0.0] * self.len
    	elif isinstance(argument, list) or isinstance(argument, tuple) or isinstance(argument, str) or isinstance(argument,range) or instance(bytes) or isinstance(argument, bytearray):
    		self.len = len(argument)
    		self.vec = list(argument)
    	else:
    		TypeError("Parameter Type is wrong") 


    def __repr__(self):
    	"""
    	Return a String of python code which could be used to initialize the Vector
    	"""
    	return "Vector(" + repr(self.vec) + ")"


    def __len__(self):
    	"""
    	The function __len__ should return the length of the Vector
    	"""
    	return len(self.vec)


    def __iter__(self):
    	"""
    	return an object that can iterate over the elements of the Vector
    	"""
    	for v in self.vec:
    		yield(v)

    def __add__(self, other):		
    	"""
    	Implementation of element wide add operation for Vector Class
    	"""
    	if len(self) != len(other):
    		raise ValueError("The length for two input vectors are not compatible")

    	return Vector([first + second for first, second in zip(list(self), list(other))])

    def __iadd__(self, other):
    	"""
    	Implementation for += operation
    	"""
    	if len(self) != len(other):
    		raise ValueError("The length for two input vectors are not compatible")

    	self.vec = Vector([first + second for first, second in zip(list(self), list(other))])
    	return self.vec

    def __radd__ (self, other):
    	"""
    	Used when the self is a list or other sequences and other is a vector
    	"""
    	if len(self) != len(other):
    		raise ValueError("The length for two input vectors are not compatible")
    	return Vector([first + second for first, second in zip(list(self), list(other))])

    def __getitem__(self, idx):
    	"""
    	Used to get the item of the vector at index idx 
    	"""
    	if type(idx) == slice:
    		return self.vec[idx]
    	if idx >= len(self.vec) or idx < (-1) * len(self.vec):
    		raise IndexError("GetItem : Index out of range") 
    	return self.vec[idx]


    def __setitem__(self, idx, val):
    	"""
    	Set the element at key idx for teh vector to val
    	"""
    	if type(idx) == slice: 
    		tmp_vector = [x for x in self.vec]
    		tmp_vector[idx] = val
    		if len(self.vec) != len(tmp_vector):
    			raise ValueError("Cannot Modify the Vector Length")
    		else:
    			self.vec = tmp_vector

    	else: 
    		if idx >= len(self.vec) or idx < (-1) * len(self.vec):
    			raise IndexError("SetItem : Index out of range") 
    		self.vec[idx] = val


    def dot(self, other):
    	"""
    	The dot operation for two input vectors. The function will check the size for 
    	two inputs to make sure. They have equal length. Otherwise, a value exeption 
    	will be thrown
    	"""
    	if len(self) != len(other):
    		raise ValueError("The length for two input vectors are not compatible")
    	sum = 0
    	for first, second in zip(self, other): 
    		sum += first * second
    	return sum


    def __gt__(self,other):
    	"""
    	Implementation for ">" operation for vector class
    	"""
    	sort_vec = sorted(self, reverse=True)
    	sort_other = sorted(other, reverse=True)
    	for first, second in zip(sort_vec, sort_other):
    		if first <= second:  
    			return False
    	return True


    def __ge__(self, other):
    	"""
    	Implementation for ">=" operation for vector class
    	"""
    	sort_vec = sorted(self, reverse=True)
    	sort_other = sorted(other, reverse=True)
    	for first, second in zip(sort_vec, sort_other):
    		if first < second:  
    			return False
    	return True


    def __lt__(self, other):
    	"""
    	Implementation for "<" operation for vector class:
    	"""
    	return not self.__ge__(other)


    def __le__(self, other):
    	"""
    	Implementation for "<=" operation for vector class:
    	"""	
    	return not self.__gt__(other)


    def __eq__(self, other):
    	"""
    	Implementation for "==" operation for vector class
    	"""
    	if (not isinstance(other, Vector)):
    		return False

    	sort_vec = sorted(self, reverse=True)
    	sort_other = sorted(other, reverse=True)
    	for first, second in zip(sort_vec, sort_other):
    		if first != second:
    			return False 
    	return True


    def __ne__(self, other): 
    	"""
    	Implementation for "!=" operation for vector class
    	"""
    	return not self.__eq__(other)









