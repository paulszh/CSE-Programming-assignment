import java.util.*;

class Result {

    /*
     * Complete the 'arrange' function below.
     *
     * The function is expected to return a STRING.
     * The function accepts STRING sentence as parameter.
     */

    public static String arrange(String sentence) {
        if (sentence == null || sentence.length() == 0) {
            return "";
        }
        String [] words = sentence.split(" ");
        String lastString = words[words.length-1];
        words[words.length - 1] = lastString.substring(0,lastString.length()-1);
        
        HashMap<Integer, List<String>> map = new HashMap<>();
        int maxWordLength = 0;
    
        for (int i = 0; i < words.length; i++) {
            int wordLength = words[i].length();
            maxWordLength = Math.max(wordLength, maxWordLength);
            
            if (!map.containsKey(wordLength)) {
                List<String> wordList = new ArrayList<>();
                map.put(wordLength, wordList);
            }
            
            List<String> l = map.get(wordLength);
            l.add(words[i].toLowerCase());
            map.put(wordLength, l);
        }
        
        StringBuilder result = new StringBuilder();
        for (int i = 1; i < maxWordLength; i++) {
            if (map.containsKey(i)) {
                List<String> l = map.get(i);
                for (String s : l) {
                    result.append(s + " ");   
                }
            }   
        }
        
        result.setCharAt(0, Character.toUpperCase(result.charAt(0)));
        result.deleteCharAt(result.length() - 1);
        result.append(".");
        
        return result.toString();
    }

    public static void main(String [] args) {
        String input = "He is Strong abcdef";
        System.out.println(arrange(input));
    }

}

