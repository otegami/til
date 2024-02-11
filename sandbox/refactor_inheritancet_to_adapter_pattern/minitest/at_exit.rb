def do_at_exit(str1)
  at_exit {
    next if str1 == 'first exit'
    puts str1

    at_exit {
      next if str1 == 'second exit'
      puts str1
    }
  }
end
at_exit { puts "cruel world" }
# do_at_exit("first exit")
# > cruel world
# do_at_exit("second exit")
# > second exit
# > cruel world
do_at_exit("goodbye")
# > goodbye
# > goodbye
# > cruel world
exit
