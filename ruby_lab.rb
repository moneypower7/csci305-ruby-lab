#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <Troy> <OSter>
# <toster1011@gmail.com>
#
###############################################################
$bigrams = Hash.new # The Bigram data structure
$name = "<Troy> <Oster>"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		if RUBY_PLATFORM.downcase.include? 'mswin'
			file = File.open(file_name)
			unless file.eof?
				file.each_line do |line|
					# do something for each line (if using windows)

				end
			end
			file.close
		else
			IO.foreach(file_name, encoding: "utf-8") do |line|
				# do something for each line (if using macos or linux)
				testing = cleanup_title(line)
				genBigram(testing)
			end
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end
#Cleans up the tile by extracting the song tile and storing it in the variable title
def  cleanup_title(single_line)
	if single_line =~ /[^>]*$/ #Starts at the end and finds the first > symbol and matches everything before it (the song title), credit goes to Jonah for reminding me that #{$&} exists
    title = "#{$&}"
  end
	#Thank you Isaac for telling me to use gsub instead of what I did above
	title.gsub!(/[\(|\[|\{|\\|\/|_|\-|\:|\"|\`|\+|\{|\*].*$/,"") #Replaces everything after the first instance of ( [ { \ / _ - : " ` + = *
	title.gsub!(/feat\..*/) #removes everything after feat.
	title.gsub!(/[\?|\¿|\!|\¡|\.|\;|\&|\@|\%|\#|\|]/,"") #removes all punctuation
	if title =~ /[^\w\s']/ #ignores songs that contain non-Eng
		title = nil
	end
	if title != nil
		title.downcase!
		#Stop words implementation
		title.gsub!(/is\s|a\s|ab\s|and\s|by\s|for\s|from\s|in\s|of\s|on\s|or\s|out\s|the\s|to\s|with\s/,"")
		return title
	end
end

def genBigram(song) #Debug assistance provided by Jonah and George, got stuck here and they helped debug... minor issues led to wasted time
	if (song != nil)
		wordsArray = song.split(" ") #creates an array of words from each word in the song title
		totalWords = wordsArray.length #represents the total number of words within the song title
		n = 1
		#This loop iterates through each word in the newly created array of words
		while (n<totalWords)
			prev = wordsArray[n-1]
			current = wordsArray[n]
			if $bigrams[prev] == nil #this makes sure that the word we are looking for is not already in the hash
        $bigrams[prev] = Hash.new(0) #this initiates the hash with the value 0 (the number of times that order of words has been found)
      end
			#Incriments the value of the word pair representing the frequency that pair has been found
			$bigrams[prev][current] += 1
			n += 1
		end
	end
end

#Most common word method
def mcw(input) #Debug assistance once again provided by George

	if ($bigrams[input]!=nil)
			wordList = $bigrams[input].keys #Grabs all the keys from bigrams and adds them to wordList
    	currentMCW = $bigrams[input].keys[0]#inits the most common one to the first occurance
    	totalWords = wordList.length #total number of words in the bigram
    	x = 1 #simply a counter variable
    	while(x < totalWords) #iterates through each word in the key
        wordCheck = $bigrams[input].keys[x]
        if($bigrams[input][currentMCW]<$bigrams[input][wordCheck]) #checks to see if the frequency for the word we are checking is greater than our current MCW's frequency
            currentMCW = wordCheck #If it's frequency is greater than the current MCW's then it sets the newly found word to be the MCW
        end
        x+= 1
    	end
			if (currentMCW!=nil)
				return currentMCW
			end
		end
end

#Builds the most probable title
def create_title(input)
	repeatArray = []
  currentTitle = input #Represents the song title string that has been generated thus far, we will be concatenating this with what we find
  prev = input #this represents the most recent word we have looked at
  count = 0
	#I found 200 to be a large enough number to repeat enough times to ensure that it would work without word limits, although it would take a long time
  while(count < 200) #Makes sure the created song title is less than 20 words long
		#Attempt at removing limit implementation
		repeatFound = false
		repeatCount = 0
		repeatLoop = 0
		if mcw(prev)!= nil #makes sure we havnt reached the end f the line (nil)
    	prev =  mcw(prev) # sets the previous word and calls mcw for the next most common word and changes prev to equal the newly found word
			repeatArray[repeatCount] = prev
			while (repeatLoop < repeatArray.length)
				if (currentTitle.include? repeatArray[repeatLoop])
					repeatFound = true
				end
				repeatLoop+=1
			end
			if (!repeatFound)
				currentTitle << " " << prev #concatenates the newly found word onto the current title generated thus far, separating the new word with a space
			end
  	end
  	count = count+1
  end
  return currentTitle #Returns the complete title when we are done
end
# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])
	# Get user input
	u_input=""
	while (u_input != "q")
		puts "Enter a word [Enter 'q' to quit]:"
		u_input = $stdin.gets.chomp #gets the users input and chomps the \n
		if (u_input != "q")
			if $bigrams[u_input]
				createSong = create_title(u_input)
			else
				puts "The word you entered does not match any song titles, thus your song title is of your own creation"
				createSong = u_input
			end
			puts createSong
		end
	end
end

if __FILE__==$0
	main_loop()
end
