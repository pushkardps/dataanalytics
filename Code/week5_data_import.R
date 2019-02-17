
# Lets load tidyverse package which in turn has readr package which is required to import flat files
library(tidyverse)

# read_csv() function can be used to import the necessary file
# It prints out a column specification that gives the name and type of each column
week5_data <- read_csv("C:/Users/pushk/Desktop/pb/Harrisburg University/Exploratory Data Analysis/Git/dataanalytics/Data/week5_data.csv")

# Alternatively, it can used to create an inline csv file
read_csv("ash, brown, cyan
          11, 22, 33
          45, 56, 67")
# read_csv function takes the first line as column names unless mentioned otherwise

# Sometimes there are a few lines of metadata at the top of the file.
# We can use skip = n to skip the first n lines; or use comment = "#"

read_csv("line 1 meta
          line 2 meta
          line 3 meta
          line 4 meta
  pxx,pyy,pzz
  20,30,40
  21,22,23", skip = 4)

read_csv("# will this be skipped too?
          wars,trek,stargate
          yoda,kirk,oyo", comment = "#")

# Sometimes data does not have column names, set col_names = FALSE in read_csv() to auto-name cols from X1 ....Xn
read_csv("har, din, naya, nahi \nshikhe, toh, matlab, kya", col_names = FALSE)

# If we want to set our own col names
read_csv("kirk, yoda, oyo\nspock,vader,okashi", col_names = c("trek", "wars", "stargate"))

# it is possible to tweak na to other values 
read_csv("alo, methi, kaanda \n10, *,2", na = "*")


# parse_*() functions take a character vector and return logical, integer, or date vector
str(parse_integer(c("44", "4442", "3232", "455")))

str(parse_logical(c("TRUE", "FALSE", "NA", "TRUE", "FALSE", "NA")))

str(parse_date(c("2019-01-20", "1988-10-29", "2007-05-23")))


# Like all functions in the tidyverse, the parse_*() functions take the first argument as a character vector
# to parse, and the na argument accounts for missing elements

parse_character(c("aalo", "matar", "kaanda", "-"), na = "-")

# when parsing fails we get a warning
x <- parse_integer(c("aalo", "adrak", ".", "456"), na = ".")

# problems(x) can be use to get a complete set of parsing failures 
problems(x)

# Numbers are written differently in diff parts of the world, 
# locale() can be used to fix problems arising from this

parse_double("13,33", locale = locale(decimal_mark = ","))

# Numbers are often surrounded by other characters that provide some context
# To simply extract the numbers we can use parse_number

parse_number("$20,000")
parse_number("33%")

# Numbers are grouped differently in different parts of the world
# To fix this we will use locale() to ignore grouping mark

# Used in America
parse_number("$200,000")

# Used in many parts of Europe
parse_number("200.122.222", locale = locale(grouping_mark = "."))

# Used in Switzerland
parse_number("111'333'789", locale = locale(grouping_mark = "'"))

# Different parts of the world use different languages 
# and its possible to things to appear gibberish until 
# we explain to our program the correct format to use

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# R uses factors to represent categorical variables that have a known set of possible values
# A warning is generated when an unexpected value is present

vegetable <- c('aalo', 'matar', 'kaanda')
parse_factor(c('aalo', 'matar', 'tinda', 'kaanda'), levels = vegetable)

# parse_datetime() is used to parse dates
parse_datetime("2019-11-05T1955")

# If time is omitted, it will be set to midnight
parse_datetime("2019-11-05")

# parse_date() expects a four digit year, a - or /, the month, a - or /, then the day:
parse_date("2019-11-05")

# parse_time() expects the hour, :, minutes, optionally : and seconds, and an optional am/pm 

library(hms)
parse_time("05:30 am")
parse_time("19:55:55")

# convert to standard format
parse_date("10/09/20", "%m/%d/%y")
parse_date("10/09/20", "%d/%m/%y")
parse_date("10/09/20", "%y/%m/%d")

# built in languages can be used to convert date times in different languages
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

# To figure out the type of each column use guess_parser()
guess_parser("2019-10-21")
guess_parser("19:55")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("21", "4445", "99", "66"))
guess_parser(c("222,888"))

#files with problems
# The first thousand rows might be a special case or columns might contain a lot of missing values
# lets check a file in readr 
challenge <- read_csv(readr_example("challenge.csv"))

# explicitly pull out the problems() to explore them in more depth
problems(challenge)

# copying and pasting the column specification into the original call
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_integer(),
    y = col_character()
  )
)


# then tweak the type of the x column:
  
  challenge <- read_csv(
    readr_example("challenge.csv"), 
    col_types = cols(
      x = col_double(),
      y = col_character()
    )
  )
  
tail(challenge)

#first col fixed, second col looks like date
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
tail(challenge)

# Alternatively, use guess_max
challenge2 <- read_csv(readr_example("challenge.csv"), guess_max = 1001)

# writing files to hard disk
write_csv(challenge, "C:/Users/pushk/Desktop/pb/Harrisburg University/Exploratory Data Analysis/Git/dataanalytics/Data/challenge.csv")

write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")
