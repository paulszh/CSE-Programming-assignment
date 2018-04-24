#include <iostream>

std::string reverseString(const std::string &str) {
    std::string result (str.length(), ' ');
    std::cout << "length : " << result.length() << " " << str.length() << std::endl;
    // for (int i = 0; i < result.length(); i++) {
    //     std::cout << str[i] << std::endl;
    //     result[result.length()-i-1] = str[i]; 
    // }
    for (int i = 0, j = result.length() - 1; i <= j; i++, j--) {
        result[i] = str[j];
        result[j] = str[i];
    }
    std::cout << "original string: " << str << "   reversed string:" << result << std::endl;
    return result; 
}

int main(int argc, const char * argv[]) {

    std::string test_1 = "";
    std::string test_2 = " ";
    std::string test_3 = "zhouhang";
    std::string test_4 = "abc";
    std::string test_5 = "sdfdsfdsdsfdsf_sdsafdsfdsf3rwrweefsasfdsfadfasfasfaf093840923849032849080";
    std::string test_6 = "dsfdsdsfdsf_sdsafdsfdsf3rwrweefsasfdsfadfasfasfaf093840923849032849080";

    std::string reverse_1 = reverseString(test_1);
    std::string reverse_2 = reverseString(test_2);
    std::string reverse_3 = reverseString(test_3);
    std::string reverse_4 = reverseString(test_4);
    std::string reverse_5 = reverseString(test_5);
    std::string reverse_6 = reverseString(test_6);
    assert (!reverseString(reverse_5).compare(test_5));
}