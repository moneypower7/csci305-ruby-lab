
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
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
				puts cleanup_title(line)
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
	if single_line =~ /[^>]*$/ #Starts at the end and finds the first > symbol and matches everything before it (the song title)
    title = "#{$&}"
  end
	if title =~ /^[^(\(|\[|\{|\\|\/|\_|\-|\:|\"|\`|\+|\=|\*|)]*/ #Removes everything after these characters
		title = "#{$&}"
	else #this is here to prevent it form removing the songs that dont have these symbols
	end
	if title =~ /.*?(?=feat.)/ #Credit to user Vasilliy Ermolovich for a almost completely unrelated answer on Stack Overflow that helped me understand this
		title = "#{$&}"
	else
	end
	if title =~ /a-z[^!]/
		title = "#{$&}"
	else
	end
	return title
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
end

if __FILE__==$0
	main_loop()
end
