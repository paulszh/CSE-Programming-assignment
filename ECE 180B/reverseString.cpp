#include<string.h>
#include<malloc.h>
#include<iostream>

char * reverseString(const char * str) {
    int len = strlen(str);
    char *result = (char*)malloc(sizeof(char)*(len+1)); 

    for (int i = 0, j = len - 1; i <= j; i++, j--) {
        result[i] = str[j];
        result[j] = str[i];
    }
    // std::cout << "original string: " << str << "   reversed string:" << result << std::endl;
    return result;
}

int main(int argc, const char * argv[]) {

    const char * test_1 = "";                    // empty string
    const char * test_2 = "zhouhang";        // even length string
    const char * test_3= "abc";             // odd length string
    // test for a very long string
    const char * test_4 = "dsfdsdsfdsfsdsafdsfdsf3rwrweefsasfdsfadfasfa.,,.,.sfaf093840923849032849080";

    char * reverse_1 = reverseString(test_1);
    char * reverse_2 = reverseString(test_2);
    char * reverse_3 = reverseString(test_3);
    char * reverse_4 =  reverseString(test_4);

    std::cout << "original string: " << test_1 << "   reversed string:" << reverse_1 << std::endl;
    std::cout << "original string: " << test_2 << "   reversed string:" << reverse_2 << std::endl;
    std::cout << "original string: " << test_3 << "   reversed string:" << reverse_3 << std::endl;
    std::cout << "original string: " << test_4 << "   reversed string:" << reverse_4 << std::endl;
}