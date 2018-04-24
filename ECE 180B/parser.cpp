#include <iostream>
#include <string>
#include <fstream>
#include <vector>

using namespace std;
string token_type[] ={"IDENTIFIER","CONSTANT","OPERATOR","KEYWORD","TERMINATOR"};
string special[] = {"(", ")", ":=", ";", ","};
vector <string> mystring;

string myoperator[] = { "+", "-"};
string mykeyword[] = {"BEGIN", "END", "READ", "WRITE"};
bool compare(string);
ifstream indata;
ofstream outdata;

int main()
{
	string str="", line="";
	cout << "Enter name of file: ";
	cin >> str;
	string temp, str1; // Enter the file name
	indata.open( str.data() );// Open file
	cout << endl;
	int token_length=0;
	while (!indata.eof() )
	{
		indata >> line;
		if (! compare(line))
		{

			for (int r=0; r <line.size(); r++)
			{
				temp =line.substr(r,1);

				if( !compare(temp) )
				{
					str1 += temp;
				}
				else
				{
					mystring.push_back(str1);
					str1 = "";
					mystring.push_back(temp);
				}
			}
			mystring.push_back(str1);
			str1 = "";
		}
		else
		mystring.push_back(line);
	}
	for (int s=0; s< mystring.size(); s++)
	{
		cout << mystring[s] << endl;
	}
	return 0;
}

bool compare(string line)
{
	for (int i=0; i <2; i++)
	{
		if (line == myoperator[i])
		{
			return true;
		}
	}
	for (int j=0; j <4; j++)
	{
		if (line == mykeyword[j])
		{
			return true;
		}
	}
	for (int k=0; k <5; k++)
	{
		if (line == special[k])
		{

			return true;
		}
	}
	return false;
}